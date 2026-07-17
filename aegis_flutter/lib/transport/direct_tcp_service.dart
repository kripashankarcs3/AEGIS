import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import '../models/signal_packet.dart';

class DirectTcpService {
  static const int _defaultPort = 9090;

  ServerSocket? _server;
  final Map<String, Socket> _connections = {}; // sigId → Socket
  bool _isRunning = false;

  final StreamController<SignalPacket> _messageController =
      StreamController<SignalPacket>.broadcast();
  Stream<SignalPacket> get messageStream => _messageController.stream;

  bool get isConnected => _connections.isNotEmpty;
  int get peerCount => _connections.length;

  String _mySigId = 'SIG-????';

  void setMySigId(String id) => _mySigId = id;

  Future<int> startServer({int port = _defaultPort}) async {
    if (_isRunning) return port;
    try {
      _server = await ServerSocket.bind(InternetAddress.anyIPv4, port);
      _isRunning = true;
      debugPrint('🔌 DirectTCP: Server listening on port $port');
      _server!.listen(_handleIncoming);
      return port;
    } catch (e) {
      debugPrint('❌ DirectTCP: Failed on port $port: $e');
      if (port < 9095) return startServer(port: port + 1);
      rethrow;
    }
  }

  Future<void> connectToPeer(String sigId, String ip, int port) async {
    if (_connections.containsKey(sigId)) {
      debugPrint('🔌 DirectTCP: Already connected to $sigId');
      return;
    }
    try {
      final socket = await Socket.connect(ip, port,
          timeout: const Duration(seconds: 5));
      debugPrint('🔌 DirectTCP: Connected to $sigId at $ip:$port');
      _sendHandshake(socket);
      _attachSocketReader(socket, sigId);
      _connections[sigId] = socket;
    } catch (e) {
      debugPrint('❌ DirectTCP: Failed to connect to $sigId: $e');
    }
  }

  void _handleIncoming(Socket socket) {
    String? peerSigId;
    final buffer = <int>[];
    debugPrint(
        '🔌 DirectTCP: Incoming from ${socket.remoteAddress.address}:${socket.remotePort}');
    socket.listen(
      (data) {
        buffer.addAll(data);
        _processBuffer(buffer, socket, (id) {
          peerSigId = id;
          _connections[id] = socket;
          debugPrint('🔌 DirectTCP: Handshake from $id');
        }, peerSigId);
      },
      onDone: () {
        if (peerSigId != null) _onDisconnected(peerSigId!);
      },
      onError: (e) {
        debugPrint('❌ DirectTCP: Server socket error: $e');
        if (peerSigId != null) _onDisconnected(peerSigId!);
      },
    );
  }

  void _attachSocketReader(Socket socket, String peerSigId) {
    final buffer = <int>[];
    socket.listen(
      (data) {
        buffer.addAll(data);
        _processBuffer(buffer, socket, (id) {
          // Re-handshake (shouldn't happen for outgoing connections)
        }, peerSigId);
      },
      onDone: () => _onDisconnected(peerSigId),
      onError: (e) {
        debugPrint('❌ DirectTCP: Socket error for $peerSigId: $e');
        _onDisconnected(peerSigId);
      },
    );
  }

  /// Processes a byte buffer using length-prefixed framing.
  /// Format: [4-byte length (big-endian)] [JSON payload bytes]
  void _processBuffer(List<int> buffer, Socket socket,
      void Function(String) onHandshake, String? knownPeerId) {
    while (true) {
      if (buffer.length < 4) break;
      final length = (buffer[0] << 24) |
          (buffer[1] << 16) |
          (buffer[2] << 8) |
          buffer[3];
      if (buffer.length < 4 + length) break;
      final msgBytes = buffer.sublist(4, 4 + length);
      buffer.removeRange(0, 4 + length);
      final str = utf8.decode(msgBytes);

      final handshake = _tryParseHandshake(str);
      if (handshake != null) {
        onHandshake(handshake);
        continue;
      }
      if (knownPeerId != null) {
        try {
          final json = jsonDecode(str);
          if (json is Map && json['type'] != 'handshake') {
            final packet =
                SignalPacket.fromJson(json as Map<String, dynamic>);
            _messageController.add(packet);
            debugPrint('📨 DirectTCP: Packet from ${packet.from}');
          }
        } catch (e) {
          debugPrint('❌ DirectTCP: Parse error: $e');
        }
      }
    }
  }

  void _sendHandshake(Socket socket) {
    final json = '{"type":"handshake","sigId":"$_mySigId"}';
    _sendMsg(socket, json);
  }

  void _sendMsg(Socket socket, String json) {
    final bytes = utf8.encode(json);
    final length = bytes.length;
    final header = Uint8List(4)
      ..buffer.asByteData().setInt32(0, length, Endian.big);
    socket.add(header);
    socket.add(bytes);
  }

  String? _tryParseHandshake(String str) {
    try {
      final json = jsonDecode(str);
      if (json is Map && json['type'] == 'handshake') {
        return json['sigId'] as String?;
      }
    } catch (_) {}
    return null;
  }

  void _onDisconnected(String peerSigId) {
    _connections.remove(peerSigId);
    debugPrint('🔌 DirectTCP: Disconnected from $peerSigId');
  }

  bool hasPeer(String sigId) => _connections.containsKey(sigId);

  Future<void> send(SignalPacket packet, {String? peerSigId}) async {
    final json = jsonEncode(packet.toJson());

    if (peerSigId != null) {
      final socket = _connections[peerSigId];
      if (socket != null) {
        _sendMsg(socket, json);
        debugPrint('📤 DirectTCP: Sent to $peerSigId');
        return;
      }
      debugPrint('❌ DirectTCP: No connection to $peerSigId');
      return;
    }

    for (final entry in _connections.entries) {
      try {
        _sendMsg(entry.value, json);
        debugPrint('📤 DirectTCP: Sent to ${entry.key}');
      } catch (e) {
        debugPrint('❌ DirectTCP: Failed to send to ${entry.key}: $e');
      }
    }
  }

  void dispose() {
    _isRunning = false;
    for (final socket in _connections.values) {
      try {
        socket.close();
      } catch (_) {}
    }
    _connections.clear();
    _server?.close();
    _messageController.close();
  }
}
