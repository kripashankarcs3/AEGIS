import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/resource_item.dart';
import '../models/signal_packet.dart';
import 'mesh_router.dart';

class ResourceManager {
  ResourceManager({
    required MeshRouter meshRouter,
    required String selfId,
  })  : _meshRouter = meshRouter,
        _selfId = selfId;

  final MeshRouter _meshRouter;
  final String _selfId;

  final List<ResourceItem> _resources = [];

  List<ResourceItem> get resources => List.unmodifiable(_resources);

  void addResource(ResourceItem item) {
    _resources.add(item);
  }

  void removeResource(String id) {
    _resources.removeWhere((e) => e.id == id);
  }

  ResourceItem? getResource(String id) {
    try {
      return _resources.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<bool> broadcastResource(ResourceItem item) async {
    final packet = SignalPacket(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      from: _selfId,
      to: 'ALL',
      type: PacketType.resource,
      payload:
          '{"title":"${item.title}","detail":"${item.detail}","type":"${item.type.name}"}',
      ttl: 5,
      hopCount: 0,
      path: [_selfId],
      timestamp: DateTime.now(),
      category: item.category.name,
    );

    return await _meshRouter.sendPacket(packet);
  }

  /// Handle an incoming resource packet: add a synthetic ResourceItem entry.
  Future<void> onIncoming(SignalPacket packet) async {
    debugPrint(
        '📦 ResourceManager.onIncoming: ${packet.from} → ${packet.payload}');
    String title = packet.payload;
    String detail = '';
    ResourceType rType = ResourceType.offered;
    try {
      final decoded = jsonDecode(packet.payload) as Map<String, dynamic>;
      title = decoded['title'] as String? ?? packet.payload;
      detail = decoded['detail'] as String? ?? '';
      rType = decoded['type'] == 'requested'
          ? ResourceType.requested
          : ResourceType.offered;
    } catch (_) {
      // Legacy plain-text payload — keep defaults
    }
    final item = ResourceItem(
      id: packet.id,
      category: _categoryFromString(packet.category),
      title: title,
      detail: detail,
      nodeId: packet.from,
      hops: packet.hopCount,
      timeAgo: 'just now',
      type: rType,
    );
    // Avoid duplicates
    if (_resources.any((r) => r.id == item.id)) return;
    _resources.add(item);
  }

  ResourceCategory _categoryFromString(String? raw) {
    switch (raw?.toLowerCase()) {
      case 'water':
        return ResourceCategory.water;
      case 'food':
        return ResourceCategory.food;
      case 'medical':
        return ResourceCategory.medical;
      case 'battery':
        return ResourceCategory.battery;
      default:
        return ResourceCategory.other;
    }
  }

  void clear() {
    _resources.clear();
  }

  int get totalResources => _resources.length;
}
