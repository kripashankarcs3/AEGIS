// WiFi LAN Service using mDNS
// Range: 50-100m, SAME WiFi required
// Fastest option when everyone is on same network

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:multicast_dns/multicast_dns.dart';
import '../models/signal_packet.dart';

class WiFiLanService {
  final MDnsClient _mdnsClient = MDnsClient();
  static const String _serviceType = '_aegis._tcp';

  final _messageController = StreamController<SignalPacket>.broadcast();
  Stream<SignalPacket> get messageStream => _messageController.stream;

  final Map<String, String> _discoveredPeers = {}; // peerId → IP

  // Start advertising on local network
  Future<void> startAdvertising() async {
    debugPrint('📢 mDNS: Starting advertising...');

    try {
      await _mdnsClient.start();

      // Broadcast our presence as "_aegis._tcp.local"
      debugPrint('✅ mDNS: Broadcasting as $_serviceType.local');

      // Start discovering others
      await _startDiscovery();
    } catch (e) {
      debugPrint('❌ mDNS advertising error: $e');
    }
  }

  // Discover other AEGIS devices on same WiFi
  Future<void> _startDiscovery() async {
    debugPrint('🔍 mDNS: Starting discovery...');

    try {
      await for (final PtrResourceRecord ptr
          in _mdnsClient.lookup<PtrResourceRecord>(
        ResourceRecordQuery.serverPointer('$_serviceType.local'),
      )) {
        debugPrint('👀 mDNS: Found device ${ptr.domainName}');

        // Extract IP address from domain name.
        // In a full implementation, resolve SRV and A records for IP:port.
        _discoveredPeers[ptr.domainName] = ptr.domainName;
      }
    } catch (e) {
      debugPrint('❌ mDNS discovery error: $e');
    }
  }

  // Send a SignalPacket via TCP socket (to be implemented)
  Future<void> send(String peerId, SignalPacket packet) async {
    debugPrint('📤 mDNS: Sending to $peerId (TCP implementation needed)');
    // TODO: Implement TCP socket connection using IP:Port from mDNS resolution
  }

  void dispose() {
    _mdnsClient.stop();
    _messageController.close();
  }
}
