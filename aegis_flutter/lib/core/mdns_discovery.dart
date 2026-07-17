import 'dart:async';

import 'package:multicast_dns/multicast_dns.dart';

class MdnsPeer {
  final String domainName;
  final String? targetHostname;
  final int? port;
  final String? ip;

  MdnsPeer({
    required this.domainName,
    this.targetHostname,
    this.port,
    this.ip,
  });
}

class MdnsDiscovery {
  MdnsDiscovery();

  final MDnsClient _client = MDnsClient();

  bool _isRunning = false;

  final List<MdnsPeer> _discoveredPeers = [];

  final StreamController<List<MdnsPeer>> _peerController =
      StreamController.broadcast();

  Stream<List<MdnsPeer>> get peerStream => _peerController.stream;

  List<MdnsPeer> get peers => List.unmodifiable(_discoveredPeers);

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

    _peerController.add(List.unmodifiable(_discoveredPeers));
  }

  /// Discover nearby peers
  Future<void> _discover() async {
    await _runLookup();
    _discoveryTimer = Timer.periodic(const Duration(seconds: 15), (_) => _runLookup());
  }

  Future<void> _runLookup() async {
    try {
      final pendingPtrs = <PtrResourceRecord>[];
      await for (final PtrResourceRecord ptr
          in _client.lookup<PtrResourceRecord>(
        ResourceRecordQuery.serverPointer('_aegis._tcp.local'),
      ).timeout(const Duration(seconds: 4))) {
        if (!_discoveredPeers.any((p) => p.domainName == ptr.domainName)) {
          pendingPtrs.add(ptr);
        }
      }
      for (final ptr in pendingPtrs) {
        await _resolveAndAddPeer(ptr);
      }
    } catch (_) {}
  }

  Future<void> _resolveAndAddPeer(PtrResourceRecord ptr) async {
    String? target;
    int? port;
    String? ip;

    try {
      await for (final SrvResourceRecord srv
          in _client.lookup<SrvResourceRecord>(
        ResourceRecordQuery.service('_aegis._tcp.local'),
      ).timeout(const Duration(seconds: 3))) {
        if (srv.name == ptr.domainName) {
          target = srv.target;
          port = srv.port;
          break;
        }
      }

      if (target != null) {
        await for (final IPAddressResourceRecord a
            in _client.lookup<IPAddressResourceRecord>(
          ResourceRecordQuery.addressIPv4(target),
        ).timeout(const Duration(seconds: 3))) {
          ip = a.address.address;
          break;
        }
      }
    } catch (_) {}

    _discoveredPeers.add(MdnsPeer(
      domainName: ptr.domainName,
      targetHostname: target,
      port: port,
      ip: ip,
    ));
    _peerController.add(List.unmodifiable(_discoveredPeers));
  }

  void dispose() {
    _discoveryTimer?.cancel();

    _peerController.close();

    if (_isRunning) {
      _client.stop();
    }
  }
}
