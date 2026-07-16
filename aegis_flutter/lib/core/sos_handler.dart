import '../models/signal_packet.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';

class SosHandler {
  final NotificationService notificationService;
  DateTime? _lastSentAt;

  SosHandler({required this.notificationService});

  // Part 1 wires this up — floods the packet to every reachable peer.
  Future<void> Function(Map<String, dynamic> packet) broadcastToMesh = (_) async {};

  // my own identity, set once identity_provider.dart has generated it
  String myIdentity = 'SIG-UNKNOWN';

  static const _cooldownSeconds = 60;

  bool get canSend =>
      _lastSentAt == null ||
      DateTime.now().difference(_lastSentAt!).inSeconds >= _cooldownSeconds;

  Future<SignalPacket> trigger({
    required String category, // medical | trapped | water | fire | all_clear
    String? customMessage,
    double? lat,
    double? lng,
  }) async {
    if (!canSend) {
      throw StateError('SOS on cooldown, wait before sending again');
    }

    final packet = SignalPacket(
      id: 'sos_${DateTime.now().millisecondsSinceEpoch}',
      from: myIdentity,
      to: 'broadcast',
      type: PacketType.sos,
      category: category,
      message: customMessage ?? _defaultMessageFor(category),
      lat: lat,
      lng: lng,
      alarm: true,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      ttl: 15,
    );

    await broadcastToMesh(packet.toJson());
    _lastSentAt = DateTime.now();
    await _appendToLog(packet);
    return packet;
  }

  // called from mesh_router.dart's incoming packet handler once Part 1
  // wires it in — for now just call this manually to test
  Future<void> onIncoming(SignalPacket packet) async {
    if (packet.type != PacketType.sos) return;
    if (packet.from == myIdentity) return;

    await _appendToLog(packet);
    notificationService.showSosNotification(
      from: packet.from,
      category: packet.category ?? 'unknown',
      message: packet.message ?? '',
    );
    // actual alarm sound + red banner is triggered from SOS.jsx-equivalent
    // screen widget (Part 3), not here — this just persists + notifies
  }

  Future<List<Map<String, dynamic>>> get log => StorageService.getSosLog();

  Future<void> _appendToLog(SignalPacket packet) async {
    final list = await StorageService.getSosLog();
    if (list.any((p) => p['id'] == packet.id)) return;
    list.add(packet.toJson());
    await StorageService.saveSosLog(list);
  }

  String _defaultMessageFor(String category) {
    switch (category) {
      case 'medical':
        return 'MEDICAL — need doctor/medicine at my location';
      case 'trapped':
        return 'TRAPPED — cannot move, need rescue at my location';
      case 'water':
        return 'NEED WATER/FOOD — critical, please respond';
      case 'fire':
        return 'FIRE/DANGER — evacuate area near my location';
      case 'all_clear':
        return 'ALL CLEAR — I am safe, no longer in distress';
      default:
        return 'EMERGENCY — need help at my location';
    }
  }
}
