import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/signal_packet.dart';
import '../services/storage_service.dart';

// NOTE: this should eventually pull the real identity + mesh send function
// from identity_provider.dart / mesh_provider.dart once those are filled
// in. Left as overridable providers below so chat_screen.dart can be built
// against this right now without waiting.

final myIdentityProvider = Provider<String>((ref) => 'SIG-UNKNOWN');

final sendPacketProvider = Provider<Future<void> Function(String peerId, Map<String, dynamic> packet)>(
  (ref) => (peerId, packet) async {
    // replace with real mesh_router.dart call once wired up
    print('[stub] would send to $peerId: ${packet['type']}');
  },
);

class ChatMessageState {
  final String id;
  final String from;
  final String to;
  final String text;
  final int timestamp;
  final List<String> path;
  final String status; // sending | sent | delivered | queued | failed
  final bool isMine;

  ChatMessageState({
    required this.id,
    required this.from,
    required this.to,
    required this.text,
    required this.timestamp,
    this.path = const [],
    this.status = 'sending',
    this.isMine = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'from': from,
        'to': to,
        'text': text,
        'timestamp': timestamp,
        'path': path,
        'status': status,
        'isMine': isMine,
      };

  factory ChatMessageState.fromMap(Map<String, dynamic> m) => ChatMessageState(
        id: m['id'],
        from: m['from'],
        to: m['to'],
        text: m['text'],
        timestamp: m['timestamp'],
        path: List<String>.from(m['path'] ?? []),
        status: m['status'] ?? 'sent',
        isMine: m['isMine'] ?? false,
      );

  ChatMessageState copyWith({String? status}) => ChatMessageState(
        id: id,
        from: from,
        to: to,
        text: text,
        timestamp: timestamp,
        path: path,
        status: status ?? this.status,
        isMine: isMine,
      );
}

class ChatNotifier extends StateNotifier<List<ChatMessageState>> {
  final String peerId;
  final String myId;
  final Future<void> Function(String, Map<String, dynamic>) sendPacket;

  ChatNotifier({required this.peerId, required this.myId, required this.sendPacket}) : super([]) {
    _load();
  }

  void _load() {
    final raw = StorageService.getChatHistory(peerId);
    state = raw.map((m) => ChatMessageState.fromMap(m)).toList();
  }

  Future<void> send(String text) async {
    final msg = ChatMessageState(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      from: myId,
      to: peerId,
      text: text,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      isMine: true,
      status: 'sending',
    );

    state = [...state, msg];
    _persist();

    try {
      final packet = SignalPacket(
        id: msg.id,
        from: myId,
        to: peerId,
        type: PacketType.chat,
        payload: text,
        timestamp: msg.timestamp,
      );
      await sendPacket(peerId, packet.toJson());
      _updateStatus(msg.id, 'sent');
    } catch (_) {
      _updateStatus(msg.id, 'queued'); // message_queue.dart picks this up
    }
  }

  // called when mesh_router.dart hands us an incoming chat packet for this peer
  void receiveIncoming(SignalPacket packet) {
    final msg = ChatMessageState(
      id: packet.id,
      from: packet.from,
      to: myId,
      text: packet.payload ?? '',
      timestamp: packet.timestamp,
      path: packet.path,
      status: 'delivered',
      isMine: false,
    );
    state = [...state, msg];
    _persist();
  }

  void _updateStatus(String msgId, String status) {
    state = state.map((m) => m.id == msgId ? m.copyWith(status: status) : m).toList();
    _persist();
  }

  void _persist() {
    StorageService.saveChatHistory(peerId, state.map((m) => m.toMap()).toList());
  }
}

final chatProvider = StateNotifierProvider.family<ChatNotifier, List<ChatMessageState>, String>(
  (ref, peerId) => ChatNotifier(
    peerId: peerId,
    myId: ref.watch(myIdentityProvider),
    sendPacket: ref.watch(sendPacketProvider),
  ),
);
