import 'dart:async';
import '../models/signal_packet.dart';

class MessageQueue {
  final List<SignalPacket> _queue = [];
  bool _running = false;
  Timer? _retryTimer;

  bool Function(String peerId) isPeerReachable = (_) => false;
  Future<void> Function(String peerId, SignalPacket packet) sendToPeer = (_, __) async {};

  void start() {
    if (_running) return;
    _running = true;
    _retryTimer = Timer.periodic(const Duration(seconds: 10), (_) => _retryAll());
  }

  void stop() {
    _running = false;
    _retryTimer?.cancel();
    _retryTimer = null;
  }

  bool get isRunning => _running;

  void enqueue(SignalPacket packet) {
    if (_queue.any((p) => p.id == packet.id)) return;
    _queue.add(packet);
  }

  SignalPacket? dequeue() {
    if (_queue.isEmpty) return null;
    return _queue.removeAt(0);
  }

  SignalPacket? peek() => _queue.isEmpty ? null : _queue.first;
  bool get isEmpty => _queue.isEmpty;
  int get length => _queue.length;
  List<SignalPacket> getAll() => List.unmodifiable(_queue);
  void clear() => _queue.clear();

  Future<void> _retryAll() async {
    if (_queue.isEmpty) return;
    final toRetry = List<SignalPacket>.from(_queue);
    _queue.clear();
    for (final packet in toRetry) {
      final target = packet.to == 'ALL' || packet.to == 'broadcast' ? 'broadcast' : packet.to;
      if (isPeerReachable(target)) {
        try {
          await sendToPeer(target, packet);
        } catch (_) {
          _queue.add(packet);
        }
      } else {
        _queue.add(packet);
      }
    }
  }
}
