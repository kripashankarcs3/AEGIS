import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';
import '../constants/aegis_styles.dart';
import '../constants/aegis_animations.dart';

class StatusHistoryScreen extends StatefulWidget {
  const StatusHistoryScreen({super.key});

  @override
  State<StatusHistoryScreen> createState() => _StatusHistoryScreenState();
}

class _StatusHistoryScreenState extends State<StatusHistoryScreen> {
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
            icon: Icon(Icons.arrow_back, color: AegisColors.textPrimary, size: 18),
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
            child: Icon(Icons.calendar_today_rounded, color: AegisColors.textPrimary, size: 16),
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
              color: AegisColors.neonGreen.withOpacity(0.08),
              shape: BoxShape.circle,
              border: Border.all(color: AegisColors.neonGreen.withOpacity(0.15), width: 1),
            ),
            child: Center(
              child: Icon(Icons.shield_outlined, color: AegisColors.neonGreen, size: 20),
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
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AegisColors.neonGreen.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AegisColors.neonGreen.withOpacity(0.2), width: 0.5),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 3, height: 14, decoration: BoxDecoration(color: AegisColors.violet, borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 8),
            Text(
              'RECENT STATUS BEACONS',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AegisColors.textSecondary, letterSpacing: 0.5),
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
          child: Column(
            children: [
              _beaconRow('SIG-8AF3', 'Online', AegisColors.neonGreen, 'Just now', '2 hops away'),
              _divider(),
              _beaconRow('SIG-C4E1', 'Online', AegisColors.neonGreen, '1 min ago', '1 hop away'),
              _divider(),
              _beaconRow('SIG-B2C1', 'Busy', AegisColors.orange, '2 min ago', '2 hops away'),
              _divider(),
              _beaconRow('SIG-1D9A', 'Needs Help', AegisColors.sosRed, '5 min ago', '3 hops away'),
              _divider(),
              _beaconRow('SIG-9E10', 'Offline', AegisColors.textMuted, '10 min ago', 'Unknown', isOffline: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _beaconRow(String nodeId, String status, Color statusColor, String time, String distance, {bool isOffline = false}) {
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
                decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
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
                style: TextStyle(fontSize: 11, color: AegisColors.textPrimary, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 2),
              Text(
                distance,
                style: TextStyle(fontSize: 10, color: AegisColors.textSecondary, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _historySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(width: 3, height: 14, decoration: BoxDecoration(color: AegisColors.violet, borderRadius: BorderRadius.circular(2))),
                const SizedBox(width: 8),
                Text(
                  'HISTORY LOG',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AegisColors.textSecondary, letterSpacing: 0.5),
                ),
              ],
            ),
            Text(
              'View all',
              style: TextStyle(
                color: AegisColors.isLight ? const Color(0xFF6D28D9) : AegisColors.violet,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
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
          child: Column(
            children: [
              _logRow(
                icon: Icons.sensors_rounded,
                iconColor: AegisColors.neonGreen,
                title: 'Status from SIG-8AF3',
                subtitle: 'Online',
                time: 'Just now',
              ),
              _divider(),
              _logRow(
                icon: Icons.warning_amber_rounded,
                iconColor: AegisColors.sosRed,
                title: 'SOS from SIG-1D9A',
                subtitle: 'Needs medical assistance',
                time: '5 min ago',
                isAlert: true,
              ),
              _divider(),
              _logRow(
                icon: Icons.library_books_rounded,
                iconColor: const Color(0xFF8B5CF6),
                title: 'Resource from SIG-C4E1',
                subtitle: 'Relayed item: Water',
                time: '7 min ago',
              ),
              _divider(),
              _logRow(
                icon: Icons.sensors_rounded,
                iconColor: AegisColors.neonGreen,
                title: 'SIG-4D2F joined the network',
                subtitle: '',
                time: '8 min ago',
              ),
            ],
          ),
        ),
      ],
    );
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
              color: iconColor.withOpacity(0.08),
              shape: BoxShape.circle,
              border: Border.all(color: iconColor.withOpacity(0.15), width: 1),
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
                      color: isAlert ? AegisColors.sosRed : AegisColors.textSecondary,
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
      color: AegisColors.border1.withOpacity(0.5),
    );
  }
}
