// Chat Provider — per-peer conversation state.
//
// Uses Riverpod StateNotifier. Each open conversation is a separate
// ChatNotifier instance keyed by the remote peer's SIG-ID.
//
// Wiring:
//   - Uses sigIdProvider from identity_provider.dart for the local identity.
//   - Uses meshSendProvider from mesh_provider.dart for packet transmission.
//   - MeshProvider wires meshProvider.notifier.onChatReceived to
//     forward incoming SignalPackets to the correct chatProvider(peerId).

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/signal_packet.dart';
import '../models/chat_message.dart';
import '../services/storage_service.dart';
import 'identity_provider.dart';
import 'mesh_send_provider.dart';

// ──────────────────────────────────────────────
// Message delivery status
// ──────────────────────────────────────────────

enum MessageStatus { sending, sent, delivered, queued, failed }

// ──────────────────────────────────────────────
// State entry
// ──────────────────────────────────────────────

class ChatEntry {
  final String id;
  final String from;
  final String to;
  final String text;
  final DateTime timestamp;
  final List<String> path;
  final MessageStatus status;
  final bool isMine;

  const ChatEntry({
    required this.id,
    required this.from,
    required this.to,
    required this.text,
    required this.timestamp,
    this.path = const [],
    this.status = MessageStatus.sending,
    this.isMine = false,
  });

  ChatEntry copyWith({MessageStatus? status}) => ChatEntry(
        id: id,
        from: from,
        to: to,
        text: text,
        timestamp: timestamp,
        path: path,
        status: status ?? this.status,
        isMine: isMine,
      );

  /// Convert to the legacy ChatMessage model used by UI screens.
  ChatMessage toChatMessage() => ChatMessage(
        id: id,
        senderId: from,
        senderName: from,
        message: text,
        timestamp: timestamp,
        isMine: isMine,
      );
}

// ──────────────────────────────────────────────
// Notifier
// ──────────────────────────────────────────────

class ChatNotifier extends StateNotifier<List<ChatEntry>> {
  ChatNotifier({
    required this.peerId,
    required this.myId,
    required this.sendFn,
  }) : super([]) {
    _loadHistory();
  }

  final String peerId;
  final String myId;
  final Future<void> Function(String, SignalPacket) sendFn;

  // ── Send a new message ────────────────────────────────────────────────
  Future<void> send(String text) async {
    final entry = ChatEntry(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      from: myId,
      to: peerId,
      text: text,
      timestamp: DateTime.now(),
      isMine: true,
      status: MessageStatus.sending,
    );

    state = [...state, entry];

    try {
      final packet = SignalPacket(
        id: entry.id,
        from: myId,
        to: peerId,
        type: PacketType.chat,
        payload: text,
        ttl: 10,
        hopCount: 0,
        path: [myId],
        timestamp: DateTime.now(),
      );
      await sendFn(peerId, packet);
      _updateStatus(entry.id, MessageStatus.sent);
      _persistHistory();
    } catch (_) {
      // Message queue in MeshRouter will retry
      _updateStatus(entry.id, MessageStatus.queued);
    }
  }

  // ── Receive incoming packet from MeshProvider ─────────────────────────
  void receiveIncoming(SignalPacket packet) {
    // Dedup check
    if (state.any((e) => e.id == packet.id)) return;

    final entry = ChatEntry(
      id: packet.id,
      from: packet.from,
      to: myId,
      text: packet.payload,
      timestamp: packet.timestamp,
      path: packet.path,
      status: MessageStatus.delivered,
      isMine: false,
    );

    state = [...state, entry];
    _persistHistory();
  }

  // ── Mark message delivered on ACK ─────────────────────────────────────
  void markDelivered(String messageId) {
    _updateStatus(messageId, MessageStatus.delivered);
  }

  void _updateStatus(String id, MessageStatus status) {
    state =
        state.map((e) => e.id == id ? e.copyWith(status: status) : e).toList();
  }

  Future<void> _loadHistory() async {
    final raw = StorageService.getChatHistory(peerId);
    if (raw.isEmpty) return;
    state = raw.map((m) => ChatEntry(
      id: m['id'] as String,
      from: m['from'] as String,
      to: m['to'] as String,
      text: m['text'] as String,
      timestamp: DateTime.fromMillisecondsSinceEpoch(m['timestamp'] as int),
      isMine: m['isMine'] as bool,
      status: MessageStatus.values.firstWhere(
        (s) => s.name == (m['status'] ?? 'delivered'),
        orElse: () => MessageStatus.delivered,
      ),
    )).toList();
  }

  void _persistHistory() {
    StorageService.saveChatHistory(peerId, state.map((e) => {
      'id': e.id, 'from': e.from, 'to': e.to, 'text': e.text,
      'timestamp': e.timestamp.millisecondsSinceEpoch,
      'isMine': e.isMine, 'status': e.status.name,
    }).toList());
  }

  /// All entries as the legacy ChatMessage type (for existing UI screens).
  List<ChatMessage> get messages =>
      state.map((e) => e.toChatMessage()).toList();
}

// ──────────────────────────────────────────────
// Provider (one per peer SIG-ID)
// ──────────────────────────────────────────────

final chatProvider =
    StateNotifierProvider.family<ChatNotifier, List<ChatEntry>, String>(
  (ref, peerId) => ChatNotifier(
    peerId: peerId,
    myId: ref.watch(sigIdProvider),
    sendFn: ref.watch(meshSendProvider),
  ),
);

/// Convenience provider: messages as legacy ChatMessage list for a given peer.
final chatMessagesProvider =
    Provider.family<List<ChatMessage>, String>((ref, peerId) {
  return ref.watch(chatProvider(peerId).notifier).messages;
});
