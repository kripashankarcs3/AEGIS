import 'package:flutter/foundation.dart';
import '../models/signal_packet.dart';
import '../services/storage_service.dart';
import 'mesh_router.dart';

class SOSHandler {
  SOSHandler({
    required MeshRouter meshRouter,
    required String selfId,
  })  : _meshRouter = meshRouter,
        _selfId = selfId;

  final MeshRouter _meshRouter;
  final String _selfId;

  DateTime? _lastSentAt;

  /// Returns true if no SOS has been sent in the last 60 seconds.
  bool get canSend =>
      _lastSentAt == null ||
      DateTime.now().difference(_lastSentAt!).inSeconds >= 60;

  Future<void> sendSOS({
    required double latitude,
    required double longitude,
    String message = 'Emergency!',
  }) async {
    final packet = SignalPacket(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      from: _selfId,
      to: 'ALL',
      type: PacketType.sos,
      payload: message,
      ttl: 10,
      hopCount: 0,
      path: [_selfId],
      timestamp: DateTime.now(),
      latitude: latitude,
      longitude: longitude,
    );

    await _meshRouter.sendPacket(packet);
    _lastSentAt = DateTime.now();
  }

  /// Handle an incoming SOS packet: persist to storage log.
  Future<void> onIncoming(SignalPacket packet) async {
    try {
      final log = await StorageService.getSosLog();
      log.add(packet.toJson());
      await StorageService.saveSosLog(log);
    } catch (e) {
      debugPrint('⚠️ SOSHandler.onIncoming error: $e');
    }
  }
}
