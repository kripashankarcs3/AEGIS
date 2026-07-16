import 'dart:async';
import '../models/signal_packet.dart';
import '../models/survivor_node_model.dart';
import '../services/storage_service.dart';

class StatusBeacon {
  Timer? _timer;
  String myIdentity = 'SIG-UNKNOWN';

  // Part 1 wires this — broadcasts to every reachable peer
  Future<void> Function(Map<String, dynamic> packet) broadcastToMesh = (_) async {};

  String myStatus = 'safe';
  List<String> myResources = [];
  String myMessage = '';
  double? myLat;
  double? myLng;

  void start() {
    _sendNow();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => _sendNow());
  }

  void stop() => _timer?.cancel();

  void updateStatus({required String status, List<String>? resources, String? message}) {
    myStatus = status;
    if (resources != null) myResources = resources;
    if (message != null) myMessage = message;
    _sendNow(); // push right away instead of waiting for next tick
  }

  void updateLocation(double lat, double lng) {
    myLat = lat;
    myLng = lng;
  }

  Future<void> _sendNow() async {
    final packet = SignalPacket(
      id: 'hb_${DateTime.now().millisecondsSinceEpoch}',
      from: myIdentity,
      to: 'broadcast',
      type: PacketType.status,
      status: myStatus,
      resources: myResources,
      message: myMessage,
      lat: myLat,
      lng: myLng,
      ttl: 8,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    await broadcastToMesh(packet.toJson());
  }

  // called from mesh_router.dart once incoming packet routing is wired
  Future<void> onIncoming(SignalPacket packet) async {
    if (packet.type != PacketType.status) return;
    if (packet.from == myIdentity) return;

    final node = SurvivorNodeModel(
      id: packet.from,
      status: packet.status ?? 'safe',
      lat: packet.lat,
      lng: packet.lng,
      resources: packet.resources ?? [],
      message: packet.message ?? '',
      lastSeen: DateTime.now().millisecondsSinceEpoch,
    );
    await StorageService.saveSurvivorNodeModel(node);
  }

  Future<List<SurvivorNodeModel>> get survivorMap => StorageService.getAllSurvivorNodeModels();
}
