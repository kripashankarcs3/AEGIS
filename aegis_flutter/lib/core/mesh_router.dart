import 'dart:convert';

import '../models/signal_packet.dart';
import 'message_queue.dart';
import '../transport/transport_manager.dart';

class MeshRouter {
  MeshRouter({
    required TransportManager transportManager,
    required MessageQueue messageQueue,
  })  : _transportManager = transportManager,
        _messageQueue = messageQueue;

  final TransportManager _transportManager;
  final MessageQueue _messageQueue;

  String localSigId = 'SIG-????';

  final Set<String> _processedPackets = {};
  static const int _cacheLimit = 1000;

  Future<List<int>> Function(List<int> message)? _signCallback;
  List<int>? _publicKeyBytes;

  void setSignCallback(
    Future<List<int>> Function(List<int> message) sign,
    List<int> publicKeyBytes,
  ) {
    _signCallback = sign;
    _publicKeyBytes = publicKeyBytes;
  }

  Future<void> Function(SignalPacket)? onChatReceived;
  Future<void> Function(SignalPacket)? onAckReceived;
  Future<void> Function(SignalPacket)? onSosReceived;
  Future<void> Function(SignalPacket)? onStatusReceived;
  Future<void> Function(SignalPacket)? onResourceReceived;

  Future<void> receivePacket(SignalPacket packet) async {
    if (_processedPackets.contains(packet.id)) return;

    _processedPackets.add(packet.id);
    if (_processedPackets.length > _cacheLimit) {
      final first = _processedPackets.first;
      _processedPackets.remove(first);
    }

    if (packet.ttl <= 0) return;

    if (packet.to == 'broadcast' || packet.to == 'ALL') {
      await _deliverPacket(packet);
      await relayPacket(packet);
      return;
    }

    if (packet.to == localSigId) {
      await _deliverPacket(packet);
      return;
    }

    await relayPacket(packet);
  }

  Future<void> relayPacket(SignalPacket packet) async {
    var forwarded = packet.copyWith(
      ttl: packet.ttl - 1,
      hopCount: packet.hopCount + 1,
      path: [...packet.path, localSigId],
      signature: null,
    );

    if (_signCallback != null && _publicKeyBytes != null) {
      try {
        final data = _canonicalBytes(forwarded);
        final sig = await _signCallback!(data);
        forwarded = forwarded.copyWith(signature: base64Encode(sig));
      } catch (_) {}
    }

    await _transportManager.sendPacket(forwarded);
  }

  Future<void> sendPacket(SignalPacket packet) async {
    var outgoing = packet;

    if (_signCallback != null && _publicKeyBytes != null) {
      try {
        final data = _canonicalBytes(outgoing);
        final sig = await _signCallback!(data);
        outgoing = outgoing.copyWith(signature: base64Encode(sig));
      } catch (_) {}
    }

    await _transportManager.sendPacket(outgoing);
  }

  Future<void> flushQueue() async {
    while (!_messageQueue.isEmpty) {
      final packet = _messageQueue.dequeue();
      if (packet == null) break;
      await sendPacket(packet);
    }
  }

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

  List<int> _canonicalBytes(SignalPacket packet) {
    return utf8.encode(
      '${packet.id}|${packet.from}|${packet.to}|${packet.payload}|${packet.timestamp.millisecondsSinceEpoch}',
    );
  }

  void clearCache() => _processedPackets.clear();

  int get processedPacketCount => _processedPackets.length;
}