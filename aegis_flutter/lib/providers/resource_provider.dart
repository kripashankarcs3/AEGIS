// NOTE: also not in the original scaffold, same reasoning as sos_provider.dart —
// resource_feed_screen.dart needs a provider to watch.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/resource_item.dart';
import '../core/resource_manager.dart';
import 'chat_provider.dart' show myIdentityProvider, sendPacketProvider;

final resourceManagerProvider = Provider<ResourceManager>((ref) {
  final manager = ResourceManager();
  manager.myIdentity = ref.watch(myIdentityProvider);
  manager.broadcastToMesh = (packet) => ref.watch(sendPacketProvider)('broadcast', packet);
  manager.start();
  ref.onDispose(manager.stop);
  return manager;
});

class ResourceFeedNotifier extends StateNotifier<List<ResourceItem>> {
  final ResourceManager manager;
  ResourceFeedNotifier(this.manager) : super([]) {
    _load();
  }

  Future<void> _load() async => state = await manager.feed;

  Future<void> post({
    required String subtype,
    required String category,
    required String quantity,
    required String message,
    double? lat,
    double? lng,
  }) async {
    await manager.post(
      subtype: subtype,
      category: category,
      quantity: quantity,
      message: message,
      lat: lat,
      lng: lng,
    );
    await _load();
  }

  Future<void> refresh() => _load();
}

final resourceFeedProvider = StateNotifierProvider<ResourceFeedNotifier, List<ResourceItem>>(
  (ref) => ResourceFeedNotifier(ref.watch(resourceManagerProvider)),
);
