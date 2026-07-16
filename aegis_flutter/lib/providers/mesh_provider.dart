// MeshProvider — Central coordinator for the entire mesh stack.
//
// Wires together:
//   TransportManager ↔ MeshRouter ↔ [SOSHandler, StatusBeacon,
//   ResourceManager, ChatNotifier, PeerManager]
//
// Usage: ProviderScope wraps MaterialApp in main.dart.
//        SplashScreen calls ref.read(meshProvider.notifier).start().

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/mesh_router.dart';
import '../core/peer_manager.dart';
import '../core/message_queue.dart';
import '../core/sos_handler.dart';
import '../core/status_beacon.dart';
import '../core/resource_manager.dart';
import '../models/signal_packet.dart';
import '../services/background_service.dart';
import '../services/storage_service.dart';
import '../transport/transport_manager.dart';
import '../transport/nearby_service.dart';
import '../transport/bluetooth_service.dart' as bt;
import '../core/mdns_discovery.dart';
import 'identity_provider.dart';

// ──────────────────────────────────────────────
// State
// ──────────────────────────────────────────────

class MeshState {
  final bool isRunning;
  final bool isConnected;
  final int peerCount;
  final int packetsRelayed;
  final List<String> recentActivity;

  const MeshState({
    this.isRunning = false,
    this.isConnected = false,
    this.peerCount = 0,
    this.packetsRelayed = 0,
    this.recentActivity = const [],
  });

  MeshState copyWith({
    bool? isRunning,
    bool? isConnected,
    int? peerCount,
    int? packetsRelayed,
    List<String>? recentActivity,
  }) =>
      MeshState(
        isRunning: isRunning ?? this.isRunning,
        isConnected: isConnected ?? this.isConnected,
        peerCount: peerCount ?? this.peerCount,
        packetsRelayed: packetsRelayed ?? this.packetsRelayed,
        recentActivity: recentActivity ?? this.recentActivity,
      );
}

// ──────────────────────────────────────────────
// Notifier
// ──────────────────────────────────────────────

class MeshNotifier extends StateNotifier<MeshState> {
  MeshNotifier(this._ref) : super(const MeshState());

  final Ref _ref;

  // Core mesh objects (created in start())
  late PeerManager _peerManager;
  late MessageQueue _messageQueue;
  late NearbyService _nearby;
  late bt.BluetoothService _bluetooth;
  late MdnsDiscovery _mdns;
  late TransportManager _transport;
  late MeshRouter _router;
  late SOSHandler _sosHandler;
  late StatusBeacon _statusBeacon;
  late ResourceManager _resourceManager;
  late BackgroundService _backgroundService;

  // Public accessors for screens/providers
  SOSHandler get sosHandler => _sosHandler;
  StatusBeacon get statusBeacon => _statusBeacon;
  ResourceManager get resourceManager => _resourceManager;
  MeshRouter get meshRouter => _router;
  PeerManager get peerManager => _peerManager;

  /// Callback wired by ChatProvider to receive incoming chat packets.
  void Function(SignalPacket)? onChatReceived;
  void Function(SignalPacket)? onAckReceived;

  // ─────────────────────────────────────────────────────────────────────
  // Lifecycle
  // ─────────────────────────────────────────────────────────────────────

  Future<void> start() async {
    if (state.isRunning) return;

    // 1. Storage
    await StorageService.init();

    // 2. Identity — generate or load
    final identity = _ref.read(identityProvider.notifier);
    await identity.initialize();
    final myId = _ref.read(identityProvider).sigId;
    debugPrint('🆔 Identity ready: $myId');

    // 3. Build core objects with real constructor signatures
    _peerManager = PeerManager();
    _messageQueue = MessageQueue();
    _nearby = NearbyService()..setMyDeviceId(myId);
    _bluetooth = bt.BluetoothService();
    _mdns = MdnsDiscovery();

    _transport = TransportManager(
      nearby: _nearby,
      bluetooth: _bluetooth,
      mdns: _mdns,
    );

    _router = MeshRouter(
      peerManager: _peerManager,
      transportManager: _transport,
      messageQueue: _messageQueue,
    );

    // SOSHandler uses constructor injection (meshRouter + selfId)
    _sosHandler = SOSHandler(
      meshRouter: _router,
      selfId: myId,
    );

    // StatusBeacon optionally takes meshRouter
    _statusBeacon = StatusBeacon(
      meshRouter: _router,
      selfId: myId,
    );

    // ResourceManager uses constructor injection (meshRouter + selfId)
    _resourceManager = ResourceManager(
      meshRouter: _router,
      selfId: myId,
    );

    _backgroundService = BackgroundService(
      statusBeacon: _statusBeacon,
      messageQueue: _messageQueue,
    );

    // 4. Wire transport → router
    _transport.onPacketReceived = (packet) {
      _router.receivePacket(packet);
      _incrementRelayed();
      _addActivity('Packet received from ${packet.from}');
    };

    // 5. Wire router delivery callbacks
    _router
      ..onSosReceived = (p) async {
        _addActivity('🆘 SOS from ${p.from}');
      }
      ..onStatusReceived = (p) async {
        _addActivity('📡 Status update from ${p.from}');
        state = state.copyWith(peerCount: _peerManager.peerCount);
      }
      ..onResourceReceived = (p) async {
        _addActivity('📦 Resource from ${p.from}: ${p.payload}');
      }
      ..onChatReceived = (p) async {
        onChatReceived?.call(p);
        _addActivity('💬 Message from ${p.from}');
      }
      ..onAckReceived = (p) async {
        onAckReceived?.call(p);
      };

    // 6. Listen to mDNS peer discovery
    _mdns.peerStream.listen((peers) {
      state = state.copyWith(peerCount: peers.length);
      _addActivity('🔍 Discovered ${peers.length} peer(s) via mDNS');
    });

    // 7. Start transport (non-fatal — may not have permissions yet)
    try {
      await _transport.initialize();
      state = state.copyWith(isConnected: _transport.isConnected);
    } catch (e) {
      debugPrint('⚠️ Transport init error: $e');
    }

    // 8. Start background timers
    _backgroundService.start();

    state = state.copyWith(isRunning: true);
    debugPrint('✅ MeshProvider: stack running as $myId');
  }

  Future<void> stop() async {
    if (!state.isRunning) return;
    _backgroundService.stop();
    await _transport.dispose();
    state = state.copyWith(isRunning: false, isConnected: false, peerCount: 0);
  }

  // ─────────────────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────────────────

  /// Send a typed packet directly (used by ChatProvider).
  Future<void> sendPacket(SignalPacket packet) => _router.sendPacket(packet);

  void _incrementRelayed() {
    state = state.copyWith(packetsRelayed: state.packetsRelayed + 1);
  }

  void _addActivity(String message) {
    final updated = [message, ...state.recentActivity].take(20).toList();
    state = state.copyWith(recentActivity: updated);
  }

  @override
  void dispose() {
    stop();
    super.dispose();
  }
}

// ──────────────────────────────────────────────
// Provider
// ──────────────────────────────────────────────

final meshProvider = StateNotifierProvider<MeshNotifier, MeshState>(
  (ref) => MeshNotifier(ref),
);

// Convenience providers consumed by screens
final meshConnectedProvider =
    Provider<bool>((ref) => ref.watch(meshProvider).isConnected);

final meshPeerCountProvider =
    Provider<int>((ref) => ref.watch(meshProvider).peerCount);

final meshPacketsRelayedProvider =
    Provider<int>((ref) => ref.watch(meshProvider).packetsRelayed);

final meshActivityProvider =
    Provider<List<String>>((ref) => ref.watch(meshProvider).recentActivity);
