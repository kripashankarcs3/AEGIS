import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/aegis_colors.dart';
import '../providers/survivor_provider.dart';
import '../providers/mesh_provider.dart';
import '../providers/identity_provider.dart';
import '../models/signal_packet.dart';

class VoiceMessageScreen extends ConsumerStatefulWidget {
  const VoiceMessageScreen({super.key});

  @override
  ConsumerState<VoiceMessageScreen> createState() => _VoiceMessageScreenState();
}

class _VoiceMessageScreenState extends ConsumerState<VoiceMessageScreen> {
  bool _isRecording = false;
  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  int _elapsedSeconds = 0;

  void _toggleRecording() {
    if (_isRecording) {
      _stopwatch.stop();
      _timer?.cancel();
      if (mounted) {
        setState(() {
          _isRecording = false;
          _elapsedSeconds = _stopwatch.elapsed.inSeconds;
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Recording stopped: ${_formatTime(_elapsedSeconds)}'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      _stopwatch = Stopwatch()..start();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) {
          setState(() {
            _elapsedSeconds = _stopwatch.elapsed.inSeconds;
          });
        }
      });
      setState(() => _isRecording = true);
    }
  }

  String _formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> _sendVoice(String peerId) async {
    if (!_isRecording && _elapsedSeconds == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Record a voice message first'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final sigId = ref.read(sigIdProvider);
    final packet = SignalPacket(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      from: sigId,
      to: peerId,
      type: PacketType.chat,
      payload: '🎙 Voice note (${_formatTime(_elapsedSeconds)})',
      ttl: 5,
      hopCount: 0,
      path: [sigId],
      timestamp: DateTime.now(),
    );

    await ref.read(meshProvider.notifier).sendPacket(packet);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Voice sent to $peerId'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AegisColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AegisColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Voice Message',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: AegisColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline_rounded, color: AegisColors.textPrimary, size: 22.0),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0),
              Center(
                child: Container(
                  height: 64.0,
                  alignment: Alignment.center,
                  child: Text(
                    _isRecording ? '🔴 Recording...' : 'Tap mic to send a voice note',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: _isRecording ? AegisColors.sosRed : AegisColors.textSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12.0),
              Center(
                child: Text(
                  _formatTime(_elapsedSeconds),
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: AegisColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 18.0),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: _toggleRecording,
                      child: Container(
                        width: 64.0,
                        height: 64.0,
                        decoration: BoxDecoration(
                          color: _isRecording ? AegisColors.sosRed : AegisColors.violet,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: (_isRecording ? AegisColors.sosRed : AegisColors.violet)
                                  .withValues(alpha: 0.4),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            _isRecording ? Icons.stop_rounded : Icons.mic_none_rounded,
                            color: Colors.white,
                            size: 28.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      _isRecording ? 'Tap to stop' : 'Tap to record',
                      style: TextStyle(
                        color: AegisColors.textSecondary,
                        fontSize: 11.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 28.0),
              Text(
                'Nearby Devices',
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: AegisColors.textSecondary,
                ),
              ),
              const SizedBox(height: 10.0),
              Expanded(
                child: _buildPeerList(ref),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVoiceShareDeviceRow(String nodeId, String hops) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 36.0,
                height: 36.0,
                decoration: BoxDecoration(
                  color: AegisColors.neonGreen.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.sensors_rounded,
                  color: AegisColors.neonGreen,
                  size: 16.0,
                ),
              ),
              const SizedBox(width: 14.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nodeId,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: AegisColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    hops,
                    style: TextStyle(
                      fontSize: 11.0,
                      color: AegisColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: () => _sendVoice(nodeId),
            child: Container(
              width: 32.0,
              height: 32.0,
              decoration: BoxDecoration(
                color: AegisColors.violet.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(color: AegisColors.violet.withValues(alpha: 0.4), width: 1.0),
              ),
              child: const Center(
                child: Icon(
                  Icons.send_rounded,
                  color: AegisColors.violet,
                  size: 14.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInnerDivider() {
    return Divider(
      color: AegisColors.border1,
      height: 1.0,
      thickness: 0.5,
    );
  }

  Widget _buildPeerList(WidgetRef ref) {
    final peers = ref.watch(survivorProvider);
    if (peers.isEmpty) {
      return Center(
        child: Text(
          'No peers available',
          style: TextStyle(
            color: AegisColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }
    final items = peers.values.toList();
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final peer = items[index];
        final status = peer.isOffline ? 'Offline' : 'Online';
        return Column(
          children: [
            if (index > 0) _buildInnerDivider(),
            _buildVoiceShareDeviceRow(peer.id, status),
          ],
        );
      },
    );
  }
}