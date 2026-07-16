import '../models/signal_packet.dart';

class MessageQueue {
  final List<SignalPacket> _queue = [];
  bool _running = false;

  // ── Wired by MeshProvider after transport layer is ready ───────────────
  /// Returns true if [peerId] is currently reachable via transport.
  bool Function(String peerId) isPeerReachable = (_) => false;

  /// Sends a packet directly to [peerId] via the transport layer.
  Future<void> Function(String peerId, SignalPacket packet) sendToPeer =
      (_, __) async {};

  void start() {
    _running = true;
  }

  void stop() {
    _running = false;
  }

  bool get isRunning => _running;

  /// Add a packet to the queue.
  void enqueue(SignalPacket packet) {
    _queue.add(packet);
  }

  /// Remove and return the oldest packet.
  SignalPacket? dequeue() {
    if (_queue.isEmpty) return null;
    return _queue.removeAt(0);
  }

  /// View the next packet without removing it.
  SignalPacket? peek() {
    if (_queue.isEmpty) return null;
    return _queue.first;
  }

  /// Check if queue is empty.
  bool get isEmpty => _queue.isEmpty;

  /// Number of queued packets.
  int get length => _queue.length;

  /// Get all queued packets.
  List<SignalPacket> getAll() {
    return List.unmodifiable(_queue);
  }

  /// Clear queue.
  void clear() {
    _queue.clear();
  }
}
