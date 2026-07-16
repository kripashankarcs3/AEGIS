import 'dart:async';

import 'package:flutter/foundation.dart';
import '../models/signal_packet.dart';
import 'mesh_router.dart';

class StatusBeacon {
  StatusBeacon({
    MeshRouter? meshRouter,
    String selfId = 'SIG-7F3A',
  })  : _meshRouter = meshRouter,
        _selfId = selfId;

  final MeshRouter? _meshRouter;
  final String _selfId;
  String? myIdentity;
  FutureOr<void> Function(SignalPacket packet)? broadcastToMesh;

  Timer? _timer;

  /// Tracks the last-known status of each peer: peerId → payload string.
  final Map<String, String> _peerStatus = {};

  bool get isRunning => _timer != null;

  Map<String, String> get peerStatus => Map.unmodifiable(_peerStatus);

  void start({
    Duration interval = const Duration(seconds: 10),
  }) {
    stop();
    _timer = Timer.periodic(interval, (_) {
      _broadcastStatus();
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _broadcastStatus() async {
    final packet = SignalPacket(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      from: _selfId,
      to: 'ALL',
      type: PacketType.status,
      payload: 'ONLINE',
      ttl: 5,
      hopCount: 0,
      path: [_selfId],
      timestamp: DateTime.now(),
    );

    final meshRouter = _meshRouter;
    if (meshRouter != null) {
      await meshRouter.sendPacket(packet);
      return;
    }

    await broadcastToMesh?.call(packet);
  }

  /// Handle an incoming status packet: update peer tracking.
  Future<void> onIncoming(SignalPacket packet) async {
    _peerStatus[packet.from] = packet.payload;
    debugPrint('📡 StatusBeacon: peer ${packet.from} → ${packet.payload}');
  }
}
