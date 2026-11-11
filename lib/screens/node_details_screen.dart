import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/aegis_colors.dart';
import '../constants/aegis_animations.dart';
import '../models/survivor_node_model.dart';
import '../providers/survivor_provider.dart';
import 'chat_conversation_screen.dart';

class NodeDetailsScreen extends ConsumerWidget {
  final String nodeId;
  const NodeDetailsScreen({super.key, required this.nodeId});

  static String _timeAgo(int timestamp) {
    final diff = DateTime.now().millisecondsSinceEpoch - timestamp;
    if (diff < 10000) return 'Just now';
    if (diff < 60000) return '${diff ~/ 1000}s ago';
    if (diff < 3600000) return '${diff ~/ 60000}m ago';
    return '${diff ~/ 3600000}h ago';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final survivor = ref
        .watch(survivorProvider)
        .values
        .where((n) => n.id == nodeId)
        .firstOrNull;
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final isOffline = survivor == null || nowMs - survivor.lastSeen > 120000;

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
          'Node Details',
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
            child:
                Icon(Icons.more_vert, color: AegisColors.textPrimary, size: 18),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StaggeredFadeIn(
                  index: 0, child: _profileCard(survivor, isOffline)),
              const SizedBox(height: 24),
              StaggeredFadeIn(
                  index: 1, child: _connectionSection(survivor, isOffline)),
              const SizedBox(height: 24),
              StaggeredFadeIn(index: 2, child: _deviceSection(survivor)),
              const SizedBox(height: 28),
              StaggeredFadeIn(
                  index: 3, child: _actionsSection(context, survivor)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileCard(SurvivorNodeModel? survivor, bool isOffline) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AegisColors.cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AegisColors.border1, width: 0.5),
        boxShadow: AegisColors.cardShadow,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AegisColors.isLight
                      ? const Color(0xFFEDE9FE)
                      : const Color(0xFF1E1B4B),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.person_rounded,
                    color: AegisColors.isLight
                        ? const Color(0xFF6D28D9)
                        : AegisColors.violet,
                    size: 26,
                  ),
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
                          nodeId,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AegisColors.textPrimary,
                            letterSpacing: -0.3,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: (isOffline
                                    ? AegisColors.textMuted
                                    : AegisColors.neonGreen)
                                .withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: (isOffline
                                        ? AegisColors.textMuted
                                        : AegisColors.neonGreen)
                                    .withValues(alpha: 0.2),
                                width: 0.5),
                          ),
                          child: Text(
                            isOffline ? 'Offline' : 'Online',
                            style: TextStyle(
                              color: isOffline
                                  ? AegisColors.textMuted
                                  : AegisColors.neonGreen,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isOffline
                          ? 'Disconnected'
                          : survivor != null && survivor.signalStrength > 0
                              ? '${5 - survivor.signalStrength} hop(s) away'
                              : 'Nearby',
                      style: TextStyle(
                        fontSize: 12,
                        color: AegisColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(height: 0.5, color: AegisColors.border1.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Last seen',
                  style: TextStyle(
                      fontSize: 12,
                      color: AegisColors.textSecondary,
                      fontWeight: FontWeight.w500)),
              Text(survivor != null ? _timeAgo(survivor.lastSeen) : 'Never',
                  style: TextStyle(
                      fontSize: 12,
                      color: AegisColors.textPrimary,
                      fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Signal strength',
                  style: TextStyle(
                      fontSize: 12,
                      color: AegisColors.textSecondary,
                      fontWeight: FontWeight.w500)),
              Text(survivor != null ? '${survivor.signalStrength}/4' : '--',
                  style: TextStyle(
                      fontSize: 12,
                      color: AegisColors.textPrimary,
                      fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _connectionSection(SurvivorNodeModel? survivor, bool isOffline) {
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
              'CONNECTION',
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
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AegisColors.border1, width: 0.5),
            boxShadow: AegisColors.cardShadow,
          ),
          child: Column(
            children: [
              _infoRow('Signal Strength',
                  isOffline ? '--' : '${survivor?.signalStrength ?? 0}/4',
                  isStatus: true,
                  statusColor: isOffline
                      ? AegisColors.textMuted
                      : (survivor?.signalStrength ?? 0) >= 3
                          ? AegisColors.neonGreen
                          : AegisColors.electricBlue),
              _divider(),
              _infoRow('Hops Away', isOffline ? '--' : '1'),
              _divider(),
              _infoRow(
                  'Battery',
                  survivor?.hasBattery == true
                      ? '${survivor!.batteryLevel}%'
                      : '--',
                  showBattery: survivor?.hasBattery == true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _deviceSection(SurvivorNodeModel? survivor) {
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
              'DEVICE INFO',
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
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AegisColors.border1, width: 0.5),
            boxShadow: AegisColors.cardShadow,
          ),
          child: Column(
            children: [
              _infoRow(
                  'Device Name',
                  survivor?.deviceName.isNotEmpty == true
                      ? survivor!.deviceName
                      : 'Unknown'),
              _divider(),
              _infoRow(
                  'Platform',
                  survivor?.platform.isNotEmpty == true
                      ? survivor!.platform
                      : 'Unknown'),
              _divider(),
              _infoRow(
                  'App Version',
                  survivor?.appVersion.isNotEmpty == true
                      ? survivor!.appVersion
                      : '--'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _actionsSection(BuildContext context, SurvivorNodeModel? survivor) {
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
              'ACTIONS',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AegisColors.textSecondary,
                  letterSpacing: 0.5),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _actionBtn(
                icon: Icons.chat_bubble_outline_rounded,
                label: 'Send Message',
                color: const Color(0xFF6D28D9),
                bgColor: AegisColors.isLight
                    ? const Color(0xFFF5F3FF)
                    : const Color(0xFF1E152A),
                borderColor: AegisColors.isLight
                    ? const Color(0xFFDDD6FE)
                    : const Color(0xFF3B1E63),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ChatConversationScreen(nodeId: nodeId))),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _actionBtn(
                icon: Icons.share_rounded,
                label: 'Share Resource',
                color: const Color(0xFFD97706),
                bgColor: AegisColors.isLight
                    ? const Color(0xFFFFFBEB)
                    : const Color(0xFF2D1F10),
                borderColor: AegisColors.isLight
                    ? const Color(0xFFFDE68A)
                    : const Color(0xFF6B4B1B),
                onTap: () {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: _actionBtn(
            icon: Icons.map_outlined,
            label: 'View on Map',
            color: AegisColors.electricBlue,
            bgColor: AegisColors.isLight
                ? const Color(0xFFEFF6FF)
                : const Color(0xFF0F172A),
            borderColor: AegisColors.isLight
                ? const Color(0xFFBFDBFE)
                : const Color(0xFF1E3A8A),
            onTap: () => Navigator.of(context).pop(),
          ),
        ),
      ],
    );
  }

  Widget _actionBtn({
    required IconData icon,
    required String label,
    required Color color,
    required Color bgColor,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value,
      {bool isStatus = false, Color? statusColor, bool showBattery = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  color: AegisColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500)),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showBattery) ...[
                Icon(Icons.battery_charging_full_rounded,
                    color: AegisColors.neonGreen, size: 14),
                const SizedBox(width: 4),
              ],
              Text(
                value,
                style: TextStyle(
                  color: isStatus ? statusColor : AegisColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
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
