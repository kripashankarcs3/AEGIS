import '../models/signal_packet.dart';
import 'message_queue.dart';
import 'peer_manager.dart';
import '../transport/transport_manager.dart';

class MeshRouter {
  MeshRouter({
    required PeerManager peerManager,
    required TransportManager transportManager,
    required MessageQueue messageQueue,
  })  : _peerManager = peerManager,
        _transportManager = transportManager,
        _messageQueue = messageQueue;

  final PeerManager _peerManager;
  final TransportManager _transportManager;
  final MessageQueue _messageQueue;

  /// The local node's SIG-ID, set by MeshProvider after identity is ready.
  /// Used to append self to path during relay so the full route is tracked.
  String localSigId = 'SIG-????';

  /// Packet IDs already processed (deduplication cache).
  final Set<String> _processedPackets = {};

  /// Maximum dedup cache size.
  static const int _cacheLimit = 1000;

  // ── Delivery callbacks — wired by MeshProvider ──────────────────────
  Future<void> Function(SignalPacket)? onChatReceived;
  Future<void> Function(SignalPacket)? onAckReceived;
  Future<void> Function(SignalPacket)? onSosReceived;
  Future<void> Function(SignalPacket)? onStatusReceived;
  Future<void> Function(SignalPacket)? onResourceReceived;

  // ─────────────────────────────────────────────────────────────────────
  // Entry point for all incoming packets (from TransportManager).
  // ─────────────────────────────────────────────────────────────────────
  Future<void> receivePacket(SignalPacket packet) async {
    // 1. Deduplication check
    if (_processedPackets.contains(packet.id)) return;

    _processedPackets.add(packet.id);
    if (_processedPackets.length > _cacheLimit) {
      _processedPackets.remove(_processedPackets.first);
    }

    // 2. TTL check
    if (packet.ttl <= 0) return;

    // 3. Broadcast packets (sos/status/resource) — deliver locally AND relay
    if (packet.to == 'broadcast' || packet.to == 'ALL') {
      await _deliverPacket(packet);
      await relayPacket(packet);
      return;
    }

    // 4. Unicast — check if we are the destination
    if (!_peerManager.containsPeer(packet.to)) {
      // Packet is addressed to an ID we don't have as a peer → it's for us
      await _deliverPacket(packet);
      return;
    }

    // 5. Forward to next hop
    await relayPacket(packet);
  }

  // ─────────────────────────────────────────────────────────────────────
  // Relay packet to connected peers.
  // ─────────────────────────────────────────────────────────────────────
  Future<void> relayPacket(SignalPacket packet) async {
    if (!_transportManager.isConnected) {
      _messageQueue.enqueue(packet);
      return;
    }

    final forwarded = packet.copyWith(
      ttl: packet.ttl - 1,
      hopCount: packet.hopCount + 1,
      path: [...packet.path, localSigId],
    );

    await _transportManager.sendPacket(forwarded);
  }

  // ─────────────────────────────────────────────────────────────────────
  // Send a brand-new outgoing packet.
  // ─────────────────────────────────────────────────────────────────────
  Future<void> sendPacket(SignalPacket packet) async {
    if (!_transportManager.isConnected) {
      _messageQueue.enqueue(packet);
      return;
    }
    await _transportManager.sendPacket(packet);
  }

  // ─────────────────────────────────────────────────────────────────────
  // Retry packets that were queued while offline.
  // ─────────────────────────────────────────────────────────────────────
  Future<void> flushQueue() async {
    while (!_messageQueue.isEmpty) {
      final packet = _messageQueue.dequeue();
      if (packet == null) break;
      await sendPacket(packet);
    }
  }

  // ─────────────────────────────────────────────────────────────────────
  // Deliver a packet to the appropriate local service.
  // ─────────────────────────────────────────────────────────────────────
  Future<void> _deliverPacket(SignalPacket packet) async {
    switch (packet.type) {
      case PacketType.chat:
        await onChatReceived?.call(packet);
        break;

      case PacketType.ack:
        await onAckReceived?.call(packet);
        break;

      case PacketType.sos:
        await onSosReceived?.call(packet);
        break;

      case PacketType.status:
        await onStatusReceived?.call(packet);
        break;

      case PacketType.resource:
        await onResourceReceived?.call(packet);
        break;
    }
  }

  // ─────────────────────────────────────────────────────────────────────
  // Utilities
  // ─────────────────────────────────────────────────────────────────────
  void clearCache() => _processedPackets.clear();

  int get processedPacketCount => _processedPackets.length;
}
