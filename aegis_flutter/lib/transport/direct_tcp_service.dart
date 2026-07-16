import 'dart:async';
import 'dart:convert';
import 'dart:io';

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
      socket.listen(
        (data) => _onData(socket, data, sigId),
        onDone: () => _onDisconnected(sigId),
        onError: (e) {
          debugPrint('❌ DirectTCP: Socket error for $sigId: $e');
          _onDisconnected(sigId);
        },
      );
      _connections[sigId] = socket;
    } catch (e) {
      debugPrint('❌ DirectTCP: Failed to connect to $sigId: $e');
    }
  }

  void _handleIncoming(Socket socket) {
    final peerSigId = _PeerIdHolder();
    debugPrint(
        '🔌 DirectTCP: Incoming from ${socket.remoteAddress.address}:${socket.remotePort}');
    socket.listen(
      (data) {
        final str = utf8.decode(data).trim();
        if (str.isEmpty) return;
        final handshake = _tryParseHandshake(str);
        if (handshake != null) {
          peerSigId.id = handshake;
          _connections[handshake] = socket;
          debugPrint('🔌 DirectTCP: Handshake from $handshake');
          return;
        }
        if (peerSigId.id != null) {
          _parseAndEmit(str, peerSigId.id!);
        }
      },
      onDone: () {
        if (peerSigId.id != null) _onDisconnected(peerSigId.id!);
      },
      onError: (e) {
        debugPrint('❌ DirectTCP: Server socket error: $e');
        if (peerSigId.id != null) _onDisconnected(peerSigId.id!);
      },
    );
  }

  void _sendHandshake(Socket socket) {
    final msg = utf8.encode('{"type":"handshake","sigId":"$_mySigId"}\n');
    socket.add(msg);
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

  void _parseAndEmit(String str, String peerSigId) {
    for (final line in str.split('\n')) {
      if (line.isEmpty) continue;
      try {
        final json = jsonDecode(line);
        if (json is Map && json['type'] == 'handshake') continue;
        final packet = SignalPacket.fromJson(json as Map<String, dynamic>);
        _messageController.add(packet);
        debugPrint('📨 DirectTCP: Packet from ${packet.from}');
      } catch (e) {
        debugPrint('❌ DirectTCP: Parse error: $e');
      }
    }
  }

  void _onData(Socket socket, List<int> data, String peerSigId) {
    final str = utf8.decode(data).trim();
    if (str.isEmpty) return;
    final handshake = _tryParseHandshake(str);
    if (handshake != null) {
      if (handshake != peerSigId) {
        _connections.remove(peerSigId);
        _connections[handshake] = socket;
        debugPrint('🔌 DirectTCP: Rebound handshake $peerSigId → $handshake');
      }
      return;
    }
    _parseAndEmit(str, peerSigId);
  }

  void _onDisconnected(String peerSigId) {
    _connections.remove(peerSigId);
    debugPrint('🔌 DirectTCP: Disconnected from $peerSigId');
  }

  bool hasPeer(String sigId) => _connections.containsKey(sigId);

  Future<void> send(SignalPacket packet, {String? peerSigId}) async {
    final json = jsonEncode(packet.toJson());
    final msg = utf8.encode('$json\n');

    if (peerSigId != null) {
      final socket = _connections[peerSigId];
      if (socket != null) {
        socket.add(msg);
        debugPrint('📤 DirectTCP: Sent to $peerSigId');
        return;
      }
      debugPrint('❌ DirectTCP: No connection to $peerSigId');
      return;
    }

    for (final entry in _connections.entries) {
      try {
        entry.value.add(msg);
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

class _PeerIdHolder {
  String? id;
}
