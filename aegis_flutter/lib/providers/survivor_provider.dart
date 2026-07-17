import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/survivor_node_model.dart';

class SurvivorMapNotifier
    extends StateNotifier<Map<String, SurvivorNodeModel>> {
  SurvivorMapNotifier() : super({});

  // called from mesh_router.dart's incoming handler once wired up
  void updateFromIncoming(SurvivorNodeModel node) {
    state = {...state, node.id: node};
  }

  void removeSurvivor(String id) {
    state = Map.from(state)..remove(id);
  }

  /// Remove all survivors not seen for more than [timeout].
  void removeStale(Duration timeout) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final staleIds = state.entries
        .where((e) => now - e.value.lastSeen > timeout.inMilliseconds)
        .map((e) => e.key)
        .toList();
    if (staleIds.isEmpty) return;
    state = Map.from(state)..removeWhere((k, _) => staleIds.contains(k));
  }
}

final survivorProvider =
    StateNotifierProvider<SurvivorMapNotifier, Map<String, SurvivorNodeModel>>(
  (ref) => SurvivorMapNotifier(),
);
