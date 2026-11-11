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

  /// Tracks connected endpoints: endpointId → endpointId (used as a set).
  final Map<String, String> _connectedPeers = {};
  /// Maps peer SIG-ID → Nearby endpoint ID for unicast lookups.
  final Map<String, String> _sigIdToEndpointId = {};
  bool get isConnected => _connectedPeers.isNotEmpty;

  /// Called when a new Nearby connection is established.
  VoidCallback? onNewPeerConnected;

  Future<void> startAdvertising() async {
    final deviceId = _myDeviceId ?? 'AEGIS-${DateTime.now().millisecondsSinceEpoch}';
    debugPrint('📢 Nearby: Advertising as $deviceId serviceId=com.aegis.mesh.aegis_flutter');

    if (_myDeviceId == null) {
      debugPrint('⚠️ Nearby: _myDeviceId is null — identity may not be ready');
    }

    try {
      await _nearby.startAdvertising(
        deviceId,
        Strategy.P2P_CLUSTER,
        serviceId: 'com.aegis.mesh.aegis_flutter',
        onConnectionInitiated: _onConnectionInitiated,
        onConnectionResult: _onConnectionResult,
        onDisconnected: _onDisconnected,
      );

      debugPrint('✅ Nearby: Advertising started successfully');
    } catch (e) {
      debugPrint('❌ Nearby advertising error: $e');
      debugPrint('⚠️ NOTE: Nearby Connections requires location services ON');
      debugPrint('⚠️ Check: Settings → Location → ON');
      debugPrint('⚠️ Check: app permissions → Nearby devices allowed');
      Future.delayed(const Duration(seconds: 2), restart);
    }
  }

  Future<void> startDiscovery() async {
    final deviceId = _myDeviceId ?? 'AEGIS-${DateTime.now().millisecondsSinceEpoch}';
    debugPrint('🔍 Nearby: Discovery as $deviceId serviceId=com.aegis.mesh.aegis_flutter');

    if (_myDeviceId == null) {
      debugPrint('⚠️ Nearby: _myDeviceId is null — identity may not be ready');
    }

    try {
      await _nearby.startDiscovery(
        deviceId,
        Strategy.P2P_CLUSTER,
        serviceId: 'com.aegis.mesh.aegis_flutter',
        onEndpointFound: _onEndpointFound,
        onEndpointLost: _onEndpointLost,
      );
      debugPrint('✅ Nearby: Discovery started successfully');
    } catch (e) {
      debugPrint('❌ Nearby discovery error: $e');
      debugPrint('⚠️ NOTE: Nearby discovery requires location services ON');
      debugPrint('⚠️ Check: Settings → Location → ON');
      debugPrint('⚠️ Check: app permissions → Nearby devices allowed');
      Future.delayed(const Duration(seconds: 2), restart);
    }
  }

  void _onEndpointFound(String id, String name, String serviceId) {
    debugPrint(
        '👀 [Nearby] Endpoint found: $name (id=$id, serviceId=$serviceId)');
    if (_connectedPeers.containsKey(id)) {
      debugPrint(
          '👀 [Nearby] Already connected to endpoint $id, skipping request');
      return;
    }
    if (_myDeviceId != null && name == _myDeviceId) {
      debugPrint('👀 [Nearby] Discovered self endpoint, ignoring');
      return;
    }
    _sigIdToEndpointId[name] = id;
    _nearby.requestConnection(
      _myDeviceId ?? 'AEGIS-${DateTime.now().millisecondsSinceEpoch}',
      id,
      onConnectionInitiated: _onConnectionInitiated,
      onConnectionResult: _onConnectionResult,
      onDisconnected: _onDisconnected,
    );
  }

  void _onConnectionInitiated(String id, ConnectionInfo info) {
    debugPrint('🤝 Connection initiated: $id from ${info.endpointName}');
    if (_myDeviceId != null && info.endpointName == _myDeviceId) {
      debugPrint('🤝 Ignoring self-initiated Nearby connection for $id');
      _nearby.rejectConnection(id);
      return;
    }
    _sigIdToEndpointId[info.endpointName] = id;
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
      onNewPeerConnected?.call();
    } else {
      debugPrint('❌ [Nearby] Connection REJECTED for $id: $status');
    }
  }

  void _onDisconnected(String id) {
    debugPrint('👋 Disconnected: $id');
    _connectedPeers.remove(id);
    _sigIdToEndpointId.removeWhere((_, epId) => epId == id);
  }

  void _onEndpointLost(String? id) {
    if (id != null) {
      _connectedPeers.remove(id);
      _sigIdToEndpointId.removeWhere((_, epId) => epId == id);
    }
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

  Future<bool> send(SignalPacket packet, {String? targetPeerId}) async {
    try {
      final json = jsonEncode(packet.toJson());
      final bytes = Uint8List.fromList(utf8.encode(json));

      // Unicast: resolve SIG-ID → endpoint ID via mapping
      if (targetPeerId != null) {
        final endpointId = _sigIdToEndpointId[targetPeerId];
        if (endpointId != null && _connectedPeers.containsKey(endpointId)) {
          await _nearby.sendBytesPayload(endpointId, bytes);
          return true;
        }
        debugPrint(
            '⚠️ [Nearby] No endpoint ID mapping for $targetPeerId, falling back to broadcast');
      }

      if (_connectedPeers.isEmpty) {
        debugPrint('⚠️ [Nearby] No connected peers available for send');
        return false;
      }

      var success = false;
      for (var peerId in _connectedPeers.keys) {
        try {
          await _nearby.sendBytesPayload(peerId, bytes);
          success = true;
        } catch (e) {
          debugPrint('❌ [Nearby] Failed to send payload to $peerId: $e');
        }
      }
      return success;
    } catch (e) {
      debugPrint('❌ Send error: $e');
      return false;
    }
  }

  void setMyDeviceId(String id) => _myDeviceId = id;

  Future<void> restart() async {
    debugPrint('🔄 [Nearby] Restarting...');
    _nearby.stopAdvertising();
    _nearby.stopDiscovery();
    await Future.delayed(const Duration(milliseconds: 500));
    await startAdvertising();
    await startDiscovery();
  }

  void dispose() {
    _nearby.stopAdvertising();
    _nearby.stopDiscovery();
    _nearby.stopAllEndpoints();
    _messageController.close();
  }
}
