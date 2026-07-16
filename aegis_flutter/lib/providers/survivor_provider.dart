import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/survivor_node_model.dart';
import '../core/status_beacon.dart';
import '../services/storage_service.dart';
import 'identity_provider.dart';
import 'mesh_send_provider.dart';

final statusBeaconProvider = Provider<StatusBeacon>((ref) {
  final beacon = StatusBeacon();
  beacon.myIdentity = ref.watch(sigIdProvider);
  beacon.broadcastToMesh =
      (packet) => ref.watch(meshSendProvider)('broadcast', packet);
  beacon.start();
  ref.onDispose(beacon.stop);
  return beacon;
});

class SurvivorMapNotifier
    extends StateNotifier<Map<String, SurvivorNodeModel>> {
  SurvivorMapNotifier() : super({}) {
    _load();
  }

  Future<void> _load() async {
    final nodes = await StorageService.getAllSurvivorNodeModels();
    state = {for (final n in nodes) n.id: n};
  }

  // called from mesh_router.dart's incoming handler once wired up
  void updateFromIncoming(SurvivorNodeModel node) {
    state = {...state, node.id: node};
    StorageService.saveSurvivorNodeModel(node);
  }

  void refresh() => _load();
}

final survivorProvider =
    StateNotifierProvider<SurvivorMapNotifier, Map<String, SurvivorNodeModel>>(
  (ref) => SurvivorMapNotifier(),
);
