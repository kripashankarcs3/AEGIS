import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import '../models/signal_packet.dart';
import 'mesh_router.dart';

class StatusBeacon {
  StatusBeacon({
    MeshRouter? meshRouter,
    String selfId = 'SIG-????',
  })  : _meshRouter = meshRouter,
        _selfId = selfId;

  final MeshRouter? _meshRouter;
  final String _selfId;
  String? myIdentity;
  FutureOr<void> Function(SignalPacket packet)? broadcastToMesh;

  Timer? _timer;

  String _deviceName = '';
  String _platform = '';
  String _appVersion = '1.0.0';
  String? _profileImageBase64;

  void setDeviceInfo(
      {String deviceName = '',
      String platform = '',
      String appVersion = '1.0.0'}) {
    _deviceName = deviceName;
    _platform = platform;
    _appVersion = appVersion;
  }

  void setProfileImage(String? base64) {
    _profileImageBase64 = base64;
  }

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
    final info = {
      'status': 'ONLINE',
      'battery': -1,
      'deviceName':
          _deviceName.isNotEmpty ? _deviceName : Platform.localHostname,
      'platform': _platform.isNotEmpty
          ? _platform
          : '${Platform.operatingSystem} ${Platform.version}',
      'appVersion': _appVersion,
      'profileImageBase64': _profileImageBase64 ?? '',
    };

    final packet = SignalPacket(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      from: _selfId,
      to: 'ALL',
      type: PacketType.status,
      payload: jsonEncode(info),
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
