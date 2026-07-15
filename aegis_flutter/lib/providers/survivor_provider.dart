import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/survivor_node.dart';
import '../core/status_beacon.dart';
import '../services/storage_service.dart';
import 'chat_provider.dart' show myIdentityProvider, sendPacketProvider;

final statusBeaconProvider = Provider<StatusBeacon>((ref) {
  final beacon = StatusBeacon();
  beacon.myIdentity = ref.watch(myIdentityProvider);
  beacon.broadcastToMesh = (packet) => ref.watch(sendPacketProvider)('broadcast', packet);
  beacon.start();
  ref.onDispose(beacon.stop);
  return beacon;
});

class SurvivorMapNotifier extends StateNotifier<Map<String, SurvivorNode>> {
  SurvivorMapNotifier() : super({}) {
    _load();
  }

  Future<void> _load() async {
    final nodes = await StorageService.getAllSurvivorNodes();
    state = {for (final n in nodes) n.id: n};
  }

  // called from mesh_router.dart's incoming handler once wired up
  void updateFromIncoming(SurvivorNode node) {
    state = {...state, node.id: node};
    StorageService.saveSurvivorNode(node);
  }

  void refresh() => _load();
}

final survivorProvider = StateNotifierProvider<SurvivorMapNotifier, Map<String, SurvivorNode>>(
  (ref) => SurvivorMapNotifier(),
);
