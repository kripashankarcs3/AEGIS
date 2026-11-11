import '../models/survivor_node.dart';

class PeerManager {
  PeerManager();

  /// Stores all active peers.
  /// Key = SIG-ID
  final Map<String, SurvivorNode> _peers = {};
  final Map<String, DateTime> _lastSeen = {};

  /// Add a new peer.
  void addPeer(SurvivorNode peer) {
    _peers[peer.id] = peer;
    _lastSeen[peer.id] = DateTime.now();
  }

  /// Update an existing peer.
  void updatePeer(SurvivorNode peer) {
    _peers[peer.id] = peer;
    _lastSeen[peer.id] = DateTime.now();
  }

  /// Remove peer.
  void removePeer(String peerId) {
    _peers.remove(peerId);
    _lastSeen.remove(peerId);
  }

  /// Get peer by ID.
  SurvivorNode? getPeer(String peerId) {
    return _peers[peerId];
  }

  /// Get all peers.
  List<SurvivorNode> getAllPeers() {
    return _peers.values.toList();
  }

  /// Check if peer exists.
  bool containsPeer(String peerId) {
    return _peers.containsKey(peerId);
  }

  /// Total active peers.
  int get peerCount => _peers.length;

  /// Remove all peers.
  void clearPeers() {
    _peers.clear();
    _lastSeen.clear();
  }

  /// Remove inactive peers.
  ///
  /// Any peer not seen for more than [timeout]
  /// will be removed.
  void clearInactivePeers(Duration timeout) {
    final now = DateTime.now();

    _peers.removeWhere((peerId, _) {
      final seenAt = _lastSeen[peerId];
      final shouldRemove = seenAt == null || now.difference(seenAt) > timeout;
      if (shouldRemove) {
        _lastSeen.remove(peerId);
      }
      return shouldRemove;
    });
  }
}
