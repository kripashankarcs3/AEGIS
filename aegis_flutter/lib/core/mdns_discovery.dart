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

  Timer? _discoveryTimer;

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

    _discoveryTimer?.cancel();

    _client.stop();

    _isRunning = false;

    _discoveredPeers.clear();

    _peerController.add(_discoveredPeers);
  }

  /// Discover nearby peers
  Future<void> _discover() async {
    await _runLookup();
    _discoveryTimer = Timer.periodic(const Duration(seconds: 15), (_) => _runLookup());
  }

  Future<void> _runLookup() async {
    try {
      await for (final PtrResourceRecord ptr in _client.lookup<PtrResourceRecord>(
        ResourceRecordQuery.serverPointer('_aegis._tcp.local'),
      ).timeout(const Duration(seconds: 5))) {
        if (!_discoveredPeers.contains(ptr.domainName)) {
          _discoveredPeers.add(ptr.domainName);

          _peerController.add(
            List.unmodifiable(_discoveredPeers),
          );
        }
      }
    } catch (_) {}
  }

  void dispose() {
    _discoveryTimer?.cancel();

    _peerController.close();

    if (_isRunning) {
      _client.stop();
    }
  }
}
