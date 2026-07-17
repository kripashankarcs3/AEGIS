import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/aegis_colors.dart';
import '../constants/aegis_animations.dart';
import '../models/survivor_node_model.dart';
import '../providers/survivor_provider.dart';

class StatusHistoryScreen extends ConsumerStatefulWidget {
  const StatusHistoryScreen({super.key});

  @override
  ConsumerState<StatusHistoryScreen> createState() => _StatusHistoryScreenState();
}

class _StatusHistoryScreenState extends ConsumerState<StatusHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AegisColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AegisColors.surface2,
            shape: BoxShape.circle,
            border: Border.all(color: AegisColors.border1, width: 0.5),
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back,
                color: AegisColors.textPrimary, size: 18),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: Text(
          'Status & History',
          style: TextStyle(
            color: AegisColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AegisColors.surface2,
              shape: BoxShape.circle,
              border: Border.all(color: AegisColors.border1, width: 0.5),
            ),
            child: Icon(Icons.calendar_today_rounded,
                color: AegisColors.textPrimary, size: 16),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StaggeredFadeIn(index: 0, child: _myStatusCard()),
              const SizedBox(height: 28),
              StaggeredFadeIn(index: 1, child: _beaconsSection()),
              const SizedBox(height: 28),
              StaggeredFadeIn(index: 2, child: _historySection()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _myStatusCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AegisColors.cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AegisColors.border1, width: 0.5),
        boxShadow: AegisColors.cardShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AegisColors.neonGreen.withValues(alpha: 0.08),
              shape: BoxShape.circle,
              border: Border.all(
                  color: AegisColors.neonGreen.withValues(alpha: 0.15), width: 1),
            ),
            child: Center(
              child: Icon(Icons.shield_outlined,
                  color: AegisColors.neonGreen, size: 20),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Status (Broadcasting)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AegisColors.textSecondary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AegisColors.neonGreen.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: AegisColors.neonGreen.withValues(alpha: 0.2),
                            width: 0.5),
                      ),
                      child: Text(
                        'Online',
                        style: TextStyle(
                          color: AegisColors.neonGreen,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'I am safe and available.',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AegisColors.textPrimary,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Updated just now',
                  style: TextStyle(
                    fontSize: 11,
                    color: AegisColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.edit_outlined, color: AegisColors.textMuted, size: 18),
        ],
      ),
    );
  }

  Widget _beaconsSection() {
    final peers = ref.watch(survivorProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
                width: 3,
                height: 14,
                decoration: BoxDecoration(
                    color: AegisColors.violet,
                    borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 8),
            Text(
              'RECENT STATUS BEACONS',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AegisColors.textSecondary,
                  letterSpacing: 0.5),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AegisColors.cardBg,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AegisColors.border1, width: 0.5),
            boxShadow: AegisColors.cardShadow,
          ),
          child: peers.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: Text(
                      'No status history yet',
                      style: TextStyle(
                        fontSize: 13,
                        color: AegisColors.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              : Column(
                  children: [
                    for (int i = 0; i < peers.length; i++) ...[
                      if (i > 0) _divider(),
                      _buildBeaconFromPeer(peers.values.elementAt(i)),
                    ],
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildBeaconFromPeer(SurvivorNodeModel peer) {
    final (status, statusColor, isOffline) = _resolveStatus(peer.status);
    final time = _formatTime(peer.lastSeen);
    return _beaconRow(peer.id, status, statusColor, time, '',
        isOffline: isOffline);
  }

  (String, Color, bool) _resolveStatus(String status) {
    switch (status) {
      case 'safe':
        return ('Online', AegisColors.neonGreen, false);
      case 'need_help':
        return ('Needs Help', AegisColors.sosRed, false);
      case 'busy':
        return ('Busy', AegisColors.orange, false);
      case 'offline':
        return ('Offline', AegisColors.textMuted, true);
      default:
        return (status, AegisColors.textSecondary, false);
    }
  }

  String _formatTime(int millis) {
    final diff = DateTime.now().difference(
        DateTime.fromMillisecondsSinceEpoch(millis));
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    return '${diff.inHours} hr ago';
  }

  Widget _beaconRow(String nodeId, String status, Color statusColor,
      String time, String distance,
      {bool isOffline = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration:
                    BoxDecoration(color: statusColor, shape: BoxShape.circle),
              ),
              const SizedBox(width: 12),
              Text(
                nodeId,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AegisColors.textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          Text(
            status,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: statusColor,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: TextStyle(
                    fontSize: 11,
                    color: AegisColors.textPrimary,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 2),
              Text(
                distance,
                style: TextStyle(
                    fontSize: 10,
                    color: AegisColors.textSecondary,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _historySection() {
    final peers = ref.watch(survivorProvider);
    final now = DateTime.now().millisecondsSinceEpoch;
    final recentPeers = peers.values
        .where((n) => now - n.lastSeen <= 120000)
        .toList()
      ..sort((a, b) => b.lastSeen.compareTo(a.lastSeen));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                    width: 3,
                    height: 14,
                    decoration: BoxDecoration(
                        color: AegisColors.violet,
                        borderRadius: BorderRadius.circular(2))),
                const SizedBox(width: 8),
                Text(
                  'HISTORY LOG',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AegisColors.textSecondary,
                      letterSpacing: 0.5),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AegisColors.cardBg,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AegisColors.border1, width: 0.5),
            boxShadow: AegisColors.cardShadow,
          ),
          child: recentPeers.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: Text(
                      'No history yet',
                      style: TextStyle(
                        fontSize: 13,
                        color: AegisColors.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              : Column(
                  children: [
                    for (int i = 0; i < recentPeers.length; i++) ...[
                      if (i > 0) _divider(),
                      _buildHistoryFromPeer(recentPeers[i]),
                    ],
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildHistoryFromPeer(SurvivorNodeModel peer) {
    final (status, iconColor, icon) = _resolveHistory(peer.status);
    final time = _formatTime(peer.lastSeen);
    return _logRow(
      icon: icon,
      iconColor: iconColor,
      title: '${peer.id} — $status',
      subtitle: peer.message.isNotEmpty ? peer.message : '',
      time: time,
      isAlert: peer.status == 'need_help',
    );
  }

  (String, Color, IconData) _resolveHistory(String status) {
    switch (status) {
      case 'safe':
        return ('Online', AegisColors.neonGreen, Icons.sensors_rounded);
      case 'need_help':
        return ('SOS', AegisColors.sosRed, Icons.warning_amber_rounded);
      case 'have_resources':
        return ('Resources', const Color(0xFF8B5CF6), Icons.library_books_rounded);
      case 'busy':
        return ('Busy', AegisColors.orange, Icons.brightness_1_rounded);
      default:
        return (status, AegisColors.textSecondary, Icons.sensors_rounded);
    }
  }

  Widget _logRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String time,
    bool isAlert = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.08),
              shape: BoxShape.circle,
              border: Border.all(color: iconColor.withValues(alpha: 0.15), width: 1),
            ),
            child: Center(
              child: Icon(icon, color: iconColor, size: 16),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AegisColors.textPrimary,
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: isAlert
                          ? AegisColors.sosRed
                          : AegisColors.textSecondary,
                      fontWeight: isAlert ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            time,
            style: TextStyle(
              fontSize: 11,
              color: AegisColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      height: 0.5,
      color: AegisColors.border1.withValues(alpha: 0.5),
    );
  }
}
