import 'dart:async';
import '../models/signal_packet.dart';
import '../models/resource_model.dart';
import '../services/storage_service.dart';

class ResourceManager {
  Timer? _cleanupTimer;
  String myIdentity = 'SIG-UNKNOWN';

  // Part 1 wires this — broadcasts to every reachable peer
  Future<void> Function(Map<String, dynamic> packet) broadcastToMesh = (_) async {};

  void start() {
    _cleanupTimer?.cancel();
    _cleanupTimer = Timer.periodic(const Duration(minutes: 5), (_) => _purgeExpired());
  }

  void stop() => _cleanupTimer?.cancel();

  Future<ResourceModel> post({
    required String subtype, // 'offer' | 'request'
    required String category,
    required String quantity,
    required String message,
    double? lat,
    double? lng,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final expires = now + (2 * 60 * 60 * 1000); // 2hr per spec

    final packet = SignalPacket(
      id: 'res_${DateTime.now().millisecondsSinceEpoch}',
      from: myIdentity,
      to: 'broadcast',
      type: PacketType.resource,
      subtype: subtype,
      category: category,
      quantity: quantity,
      message: message,
      lat: lat,
      lng: lng,
      expires: expires,
      timestamp: now,
      ttl: 10,
    );

    await broadcastToMesh(packet.toJson());

    final item = ResourceModel(
      id: packet.id,
      from: myIdentity,
      subtype: subtype,
      category: category,
      quantity: quantity,
      message: message,
      lat: lat,
      lng: lng,
      timestamp: now,
      expires: expires,
      isMine: true,
    );
    await StorageService.saveResourceModel(item);
    return item;
  }

  // called from mesh_router.dart once incoming routing is wired
  Future<void> onIncoming(SignalPacket packet) async {
    if (packet.type != PacketType.resource) return;
    if (packet.from == myIdentity) return;
    if (DateTime.now().millisecondsSinceEpoch > (packet.expires ?? 0)) return;

    final item = ResourceModel(
      id: packet.id,
      from: packet.from,
      subtype: packet.subtype ?? 'offer',
      category: packet.category ?? 'water',
      quantity: packet.quantity ?? '',
      message: packet.message ?? '',
      lat: packet.lat,
      lng: packet.lng,
      timestamp: packet.timestamp,
      expires: packet.expires ?? 0,
    );
    await StorageService.saveResourceModel(item);
  }

  Future<List<ResourceModel>> get feed => StorageService.getResourceFeed();

  Future<void> _purgeExpired() => StorageService.purgeExpiredResources();
}
