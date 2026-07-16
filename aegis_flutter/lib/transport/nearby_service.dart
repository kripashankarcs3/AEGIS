// WiFi Direct using Nearby Connections - NO same WiFi needed!
// Range: 100-200m

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:nearby_connections/nearby_connections.dart';
import '../models/signal_packet.dart';

class NearbyService {
  final Nearby _nearby = Nearby();
  String? _myDeviceId;

  final _messageController = StreamController<SignalPacket>.broadcast();
  Stream<SignalPacket> get messageStream => _messageController.stream;

  final Map<String, String> _connectedPeers = {};
  bool get isConnected => _connectedPeers.isNotEmpty;

  Future<void> startAdvertising() async {
    debugPrint('📢 Nearby: Advertising...');

    try {
      bool success = await _nearby.startAdvertising(
        _myDeviceId ?? 'AEGIS',
        Strategy.P2P_CLUSTER,
        serviceId: 'com.aegis.mesh',
        onConnectionInitiated: _onConnectionInitiated,
        onConnectionResult: _onConnectionResult,
        onDisconnected: _onDisconnected,
      );

      if (success) debugPrint('✅ Nearby: Advertising');
    } catch (e) {
      debugPrint('❌ Nearby error: $e');
    }
  }

  Future<void> startDiscovery() async {
    debugPrint('🔍 Nearby: Discovery...');

    try {
      await _nearby.startDiscovery(
        _myDeviceId ?? 'AEGIS',
        Strategy.P2P_CLUSTER,
        serviceId: 'com.aegis.mesh',
        onEndpointFound: _onEndpointFound,
        onEndpointLost: _onEndpointLost,
      );
    } catch (e) {
      debugPrint('❌ Nearby discovery: $e');
    }
  }

  void _onEndpointFound(String id, String name, String serviceId) {
    debugPrint('👀 [Nearby] Endpoint found: $name (id=$id, serviceId=$serviceId)');
    _nearby.requestConnection(
      _myDeviceId ?? 'AEGIS',
      id,
      onConnectionInitiated: _onConnectionInitiated,
      onConnectionResult: _onConnectionResult,
      onDisconnected: _onDisconnected,
    );
  }

  void _onConnectionInitiated(String id, ConnectionInfo info) {
    debugPrint('🤝 Connection: $id');
    _nearby.acceptConnection(
      id,
      onPayLoadRecieved: _onPayloadReceived,
      onPayloadTransferUpdate: (_, __) {},
    );
  }

  void _onConnectionResult(String id, Status status) {
    debugPrint('🔗 [Nearby] Connection result for $id: $status');
    if (status == Status.CONNECTED) {
      debugPrint('✅ [Nearby] Connected to $id');
      _connectedPeers[id] = id;
    } else {
      debugPrint('❌ [Nearby] Connection REJECTED for $id: $status');
    }
  }

  void _onDisconnected(String id) {
    debugPrint('👋 Disconnected: $id');
    _connectedPeers.remove(id);
  }

  void _onEndpointLost(String? id) {
    if (id != null) _connectedPeers.remove(id);
  }

  void _onPayloadReceived(String id, Payload payload) {
    if (payload.type == PayloadType.BYTES && payload.bytes != null) {
      try {
        final json = jsonDecode(utf8.decode(payload.bytes!));
        final packet = SignalPacket.fromJson(json);
        _messageController.add(packet);
      } catch (e) {
        debugPrint('❌ Parse error: $e');
      }
    }
  }

  Future<void> send(SignalPacket packet) async {
    try {
      final json = jsonEncode(packet.toJson());
      final bytes = Uint8List.fromList(utf8.encode(json));

      for (var peerId in _connectedPeers.keys) {
        await _nearby.sendBytesPayload(peerId, bytes);
      }
    } catch (e) {
      debugPrint('❌ Send error: $e');
    }
  }

  void setMyDeviceId(String id) => _myDeviceId = id;

  void dispose() {
    _nearby.stopAdvertising();
    _nearby.stopDiscovery();
    _nearby.stopAllEndpoints();
    _messageController.close();
  }
}
