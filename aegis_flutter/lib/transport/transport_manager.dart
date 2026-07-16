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
    debugPrint('🚀 [Transport] Initializing all transports...');

    // Start mDNS discovery (listen mode only)
    try {
      await _mdns.start();
      debugPrint('✅ [mDNS] Started discovery');
    } catch (e) {
      debugPrint('❌ [mDNS] Failed: $e');
    }

    // Start Nearby Connections (WiFi Direct — primary transport)
    try {
      await _nearby.startAdvertising();
      debugPrint('✅ [Nearby] Advertising started');
    } catch (e) {
      debugPrint('❌ [Nearby] Advertising failed: $e');
    }

    try {
      await _nearby.startDiscovery();
      debugPrint('✅ [Nearby] Discovery started');
    } catch (e) {
      debugPrint('❌ [Nearby] Discovery failed: $e');
    }

    // Start Bluetooth LE fallback
    try {
      await _bluetooth.startAdvertising();
      debugPrint('✅ [BLE] Started');
    } catch (e) {
      debugPrint('❌ [BLE] Failed: $e');
    }

    _nearby.messageStream.listen((packet) {
      debugPrint('📨 [Nearby] Packet received from ${packet.from}');
      onPacketReceived?.call(packet);
    });

    _bluetooth.messageStream.listen((packet) {
      debugPrint('📨 [BLE] Packet received from ${packet.from}');
      onPacketReceived?.call(packet);
    });

    if (_tcpDirect != null) {
      _tcpDirect!.messageStream.listen((packet) {
        debugPrint('📨 [TCP] Packet received from ${packet.from}');
        onPacketReceived?.call(packet);
      });
    }

    debugPrint('✅ [Transport] All transports initialized. isConnected=$isConnected');
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
