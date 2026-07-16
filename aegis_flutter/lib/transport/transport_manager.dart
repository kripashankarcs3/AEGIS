import 'package:flutter/foundation.dart';
import 'nearby_service.dart';
import 'bluetooth_service.dart';
import 'direct_tcp_service.dart';
import '../models/signal_packet.dart';
import '../core/mdns_discovery.dart';

class TransportManager {
  final NearbyService _nearby;
  final BluetoothService _bluetooth;
  final MdnsDiscovery _mdns;
  DirectTcpService? _tcpDirect;

  Function(SignalPacket packet)? onPacketReceived;

  bool get isConnected =>
      _nearby.isConnected || _bluetooth.isConnected || (_tcpDirect?.isConnected ?? false);

  TransportManager({
    required NearbyService nearby,
    required BluetoothService bluetooth,
    required MdnsDiscovery mdns,
    DirectTcpService? tcpDirect,
  })  : _nearby = nearby,
        _bluetooth = bluetooth,
        _mdns = mdns {
    _tcpDirect = tcpDirect;
  }

  void setTcpDirect(DirectTcpService service) {
    _tcpDirect = service;
  }

  Future<void> initialize() async {
    debugPrint('Initializing transports...');

    await _mdns.start();
    await _nearby.startAdvertising();
    await _nearby.startDiscovery();
    await _bluetooth.startAdvertising();

    _nearby.messageStream.listen((packet) {
      onPacketReceived?.call(packet);
    });

    _bluetooth.messageStream.listen((packet) {
      onPacketReceived?.call(packet);
    });

    if (_tcpDirect != null) {
      _tcpDirect!.messageStream.listen((packet) {
        debugPrint('TCP Direct -> mesh_router');
        onPacketReceived?.call(packet);
      });
    }

    debugPrint('All transports active');
  }

  bool hasDirectTcp(String sigId) => _tcpDirect?.hasPeer(sigId) ?? false;

  Future<void> sendPacket(SignalPacket packet, {String? directPeerId}) async {
    final targetId = directPeerId ??
        (packet.to != 'broadcast' && packet.to != 'ALL' ? packet.to : null);
    if (targetId != null && _tcpDirect != null && _tcpDirect!.hasPeer(targetId)) {
      await _tcpDirect!.send(packet, peerSigId: targetId);
      return;
    }

    if (_nearby.isConnected) {
      await _nearby.send(packet);
      return;
    }

    if (_bluetooth.isConnected) {
      await _bluetooth.send(packet);
      return;
    }

    if (_tcpDirect != null && _tcpDirect!.isConnected) {
      await _tcpDirect!.send(packet);
      return;
    }

    debugPrint('No transport available');
  }

  Future<void> dispose() async {
    _nearby.dispose();
    _bluetooth.dispose();
    _mdns.dispose();
    _tcpDirect?.dispose();
  }
}
