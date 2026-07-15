import 'dart:async';
import '../models/signal_packet.dart';
import '../services/storage_service.dart';

// Store-and-forward. If peer_manager.dart (Part 1) says a peer isn't
// reachable right now, the message sits here and we retry on a timer until
// it goes through.
//
// depends on Part 1's peer reachability check — swap the function below
// once mesh_provider.dart / peer_manager.dart exposes something real.
class MessageQueue {
  Timer? _retryTimer;

  // Part 1 wires this up — return true if 'peerId' currently has a route.
  // left as a settable function instead of a hard interface dependency so
  // this file compiles standalone before peer_manager.dart is finished.
  bool Function(String peerId) isPeerReachable = (_) => false;

  // Part 1 wires this up too — actually push the packet onto the mesh.
  Future<void> Function(String peerId, Map<String, dynamic> packet) sendToPeer =
      (_, __) async {};

  void start() {
    _retryTimer?.cancel();
    _retryTimer = Timer.periodic(const Duration(seconds: 5), (_) => _retryAll());
  }

  void stop() => _retryTimer?.cancel();

  Future<void> enqueue(SignalPacket packet) async {
    final list = await StorageService.getQueuedPackets();
    if (list.any((p) => p['id'] == packet.id)) return;
    list.add(packet.toJson());
    await StorageService.saveQueuedPackets(list);
  }

  Future<List<Map<String, dynamic>>> get pending => StorageService.getQueuedPackets();

  Future<void> _retryAll() async {
    final list = await StorageService.getQueuedPackets();
    if (list.isEmpty) return;

    final stillPending = <Map<String, dynamic>>[];
    for (final raw in list) {
      final peer = raw['to'] as String;
      if (isPeerReachable(peer)) {
        try {
          await sendToPeer(peer, raw);
        } catch (_) {
          stillPending.add(raw);
        }
      } else {
        stillPending.add(raw);
      }
    }
    await StorageService.saveQueuedPackets(stillPending);
  }
}
