import 'dart:async';

import 'package:multicast_dns/multicast_dns.dart';

class MdnsDiscovery {
  MdnsDiscovery();

  final MDnsClient _client = MDnsClient();

  bool _isRunning = false;

  final List<String> _discoveredPeers = [];

  final StreamController<List<String>> _peerController =
      StreamController.broadcast();

  Stream<List<String>> get peerStream => _peerController.stream;

  List<String> get peers => List.unmodifiable(_discoveredPeers);

  bool get isRunning => _isRunning;

  /// Start mDNS
  Future<void> start() async {
    if (_isRunning) return;

    await _client.start();

    _isRunning = true;

    _discover();
  }

  /// Stop mDNS
  Future<void> stop() async {
    if (!_isRunning) return;

    _client.stop();

    _isRunning = false;

    _discoveredPeers.clear();

    _peerController.add(_discoveredPeers);
  }

  /// Discover nearby peers
  Future<void> _discover() async {
    await for (final PtrResourceRecord ptr in _client.lookup<PtrResourceRecord>(
      ResourceRecordQuery.serverPointer('_aegis._tcp.local'),
    )) {
      if (!_discoveredPeers.contains(ptr.domainName)) {
        _discoveredPeers.add(ptr.domainName);

        _peerController.add(
          List.unmodifiable(_discoveredPeers),
        );
      }
    }
  }

  void dispose() {
    _peerController.close();

    if (_isRunning) {
      _client.stop();
    }
  }
}
