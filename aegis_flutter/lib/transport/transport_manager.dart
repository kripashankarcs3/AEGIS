// Transport Manager - Replaces WebRTCManager
// Coordinates: Nearby Connections (WiFi Direct) + Bluetooth LE + mDNS
// Connects to existing mesh_router.dart

import 'package:flutter/foundation.dart';
import 'nearby_service.dart';
import 'bluetooth_service.dart';
import '../models/signal_packet.dart';
import '../core/mdns_discovery.dart';

class TransportManager {
  final NearbyService _nearby;
  final BluetoothService _bluetooth;
  final MdnsDiscovery _mdns;

  // Callback to mesh_router (same as WebRTCManager)
  Function(SignalPacket packet)? onPacketReceived;

  bool get isConnected => _nearby.isConnected || _bluetooth.isConnected;

  TransportManager({
    required NearbyService nearby,
    required BluetoothService bluetooth,
    required MdnsDiscovery mdns,
  })  : _nearby = nearby,
        _bluetooth = bluetooth,
        _mdns = mdns;

  // Initialize all transports
  Future<void> initialize() async {
    debugPrint('🚀 Initializing transports...');

    // Start mDNS discovery (reuse existing)
    await _mdns.start();

    // Start Nearby Connections (WiFi Direct)
    await _nearby.startAdvertising();
    await _nearby.startDiscovery();

    // Start Bluetooth scanning
    await _bluetooth.startAdvertising();

    // Listen to incoming packets → send to mesh_router
    _nearby.messageStream.listen((packet) {
      debugPrint('📨 Nearby → mesh_router');
      onPacketReceived?.call(packet);
    });

    _bluetooth.messageStream.listen((packet) {
      debugPrint('📨 Bluetooth → mesh_router');
      onPacketReceived?.call(packet);
    });

    debugPrint('✅ All transports active');
  }

  // Send packet (called by mesh_router.sendPacket)
  Future<void> sendPacket(SignalPacket packet) async {
    // Try WiFi Direct first (fastest, longest range)
    if (_nearby.isConnected) {
      debugPrint('📤 Sending via WiFi Direct');
      await _nearby.send(packet);
      return;
    }

    // Fallback to Bluetooth
    if (_bluetooth.isConnected) {
      debugPrint('📤 Sending via Bluetooth');
      await _bluetooth.send(packet);
      return;
    }

    debugPrint('❌ No transport available');
  }

  Future<void> dispose() async {
    _nearby.dispose();
    _bluetooth.dispose();
    _mdns.dispose();
  }
}
