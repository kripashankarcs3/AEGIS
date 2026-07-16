import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/aegis_colors.dart';
import '../constants/aegis_styles.dart';
import '../constants/aegis_animations.dart';
import '../models/signal_packet.dart';
import '../models/survivor_node.dart';
import '../widgets/radar_painter.dart';
import '../widgets/mesh_stats_bar.dart';
import '../providers/theme_provider.dart';
import '../providers/mesh_provider.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';
import 'sos_incoming_overlay.dart';
import '../widgets/node_popup_card.dart';
import 'chat_conversation_screen.dart';

class RadarScreen extends ConsumerStatefulWidget {
  const RadarScreen({super.key});

  @override
  ConsumerState<RadarScreen> createState() => _RadarScreenState();
}

class _RadarScreenState extends ConsumerState<RadarScreen>
    with TickerProviderStateMixin {
  bool _isEmptyRadar = false;

  static const _nodes = [
    SurvivorNode(
        id: 'SIG-7F3A',
        hops: 0,
        status: NodeStatus.online,
        isUser: true,
        dx: 0.0,
        dy: 0.0),
    SurvivorNode(
        id: 'SIG-8AF3', hops: 2, status: NodeStatus.online, dx: 0.0, dy: -0.58),
    SurvivorNode(
        id: 'SIG-C4E1',
        hops: 1,
        status: NodeStatus.online,
        dx: -0.48,
        dy: -0.38),
    SurvivorNode(
        id: 'SIG-B2C1', hops: 2, status: NodeStatus.relay, dx: 0.58, dy: -0.22),
    SurvivorNode(
        id: 'SIG-9E10', hops: 3, status: NodeStatus.busy, dx: 0.45, dy: 0.38),
    SurvivorNode(
        id: 'SIG-1D9A', hops: 3, status: NodeStatus.sos, dx: -0.58, dy: 0.22),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StaggeredFadeIn(index: 0, child: _header()),
              const SizedBox(height: 18),
              StaggeredFadeIn(index: 1, child: _statusRow()),
              const SizedBox(height: 24),
              StaggeredFadeIn(index: 2, child: _radarSection()),
              const SizedBox(height: 24),
              if (!_isEmptyRadar) ...[
                StaggeredFadeIn(index: 3, child: _statsSection()),
                const SizedBox(height: 28),
                StaggeredFadeIn(index: 4, child: _activitySection()),
              ],
              if (_isEmptyRadar) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: StaggeredFadeIn(index: 3, child: _emptyState()),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    final themeProvider = ThemeProviderWidget.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                image: const DecorationImage(
                  image: AssetImage('assets/images/logo.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'AEGIS',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.3,
                color: AegisColors.textPrimary,
              ),
            ),
          ],
        ),
        Row(
          children: [
            _iconBtn(
              _isEmptyRadar ? Icons.wifi_off_rounded : Icons.wifi_rounded,
              _isEmptyRadar ? AegisColors.sosRed : AegisColors.neonGreen,
              () => setState(() => _isEmptyRadar = !_isEmptyRadar),
            ),
            const SizedBox(width: 8),
            _iconBtn(
              themeProvider.isLightActive
                  ? Icons.dark_mode_rounded
                  : Icons.light_mode_rounded,
              AegisColors.textPrimary,
              () {
                if (themeProvider.isLightActive) {
                  themeProvider.setMode(AppThemeMode.dark);
                } else {
                  themeProvider.setMode(AppThemeMode.light);
                }
              },
            ),
            const SizedBox(width: 8),
            _iconBtn(
              Icons.notifications_none_outlined,
              AegisColors.textPrimary,
              () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const NotificationsScreen())),
              badge: true,
            ),
            const SizedBox(width: 8),
            _avatarBtn(),
          ],
        ),
      ],
    );
  }

  Widget _iconBtn(IconData icon, Color color, VoidCallback onTap,
      {bool badge = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
            color: AegisColors.surface2,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AegisColors.border1, width: 0.5)),
        child: Stack(clipBehavior: Clip.none, children: [
          Center(child: Icon(icon, color: color, size: 18)),
          if (badge)
            Positioned(
                right: 6,
                top: 6,
                child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                        color: AegisColors.sosRed, shape: BoxShape.circle))),
        ]),
      ),
    );
  }

  Widget _avatarBtn() {
    return GestureDetector(
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => const ProfileScreen())),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AegisColors.isLight
              ? const Color(0xFF8B5CF6)
              : const Color(0xFF5B21B6),
          border: Border.all(
              color: AegisColors.isLight
                  ? const Color(0xFFDDD6FE)
                  : AegisColors.violet.withOpacity(0.15),
              width: 1.5),
        ),
        child: const Center(
          child: Icon(
            Icons.person_rounded,
            size: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _statusRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AegisColors.neonGreen,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Mesh Active',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AegisColors.neonGreen,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () => setState(() => _isEmptyRadar = !_isEmptyRadar),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AegisColors.electricBlue.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: AegisColors.electricBlue.withOpacity(0.2), width: 0.5),
            ),
            child: Text(
              _isEmptyRadar ? '0 Nodes' : '8 Nodes',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AegisColors.electricBlue,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _radarSection() {
    return AspectRatio(
      aspectRatio: 1.12,
      child: Container(
        decoration: BoxDecoration(
          color: AegisColors.cardBg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AegisColors.border1, width: 0.5),
          boxShadow: AegisColors.cardShadow,
        ),
        clipBehavior: Clip.antiAlias,
        child: LayoutBuilder(builder: (_, constraints) {
          final c = Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);
          final maxR =
              min(constraints.maxWidth, constraints.maxHeight) / 2 * 0.82;

          return Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: RadarBackgroundPainter(
                    nodes: _isEmptyRadar
                        ? _nodes.where((n) => n.isUser).toList()
                        : _nodes,
                    pulseValue: 0.0,
                  ),
                ),
              ),
              ...(_isEmptyRadar
                      ? _nodes.where((n) => n.isUser).toList()
                      : _nodes)
                  .map((node) {
                final floatY = 0.0;
                final nx = c.dx + node.dx * maxR;
                final ny = c.dy + node.dy * maxR + floatY;
                final size = node.isUser ? 38.0 : 30.0;
                final isSos = node.status == NodeStatus.sos;

                return Positioned(
                  left: nx - 30,
                  top: ny - 30,
                  child: GestureDetector(
                    onTap: () {
                      if (isSos) {
                        final dummyPacket = SignalPacket(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          from: node.id,
                          to: 'broadcast',
                          type: PacketType.sos,
                          payload: 'Emergency assistance needed!',
                          ttl: 5,
                          hopCount: node.hops,
                          path: [node.id],
                          timestamp: DateTime.now(),
                        );
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) =>
                                SosIncomingOverlayScreen(packet: dummyPacket)));
                      } else {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          builder: (_) => NodePopupCard(
                            nodeId: node.id,
                            onOpenChat: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) =>
                                      ChatConversationScreen(nodeId: node.id)));
                            },
                          ),
                        );
                      }
                    },
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: size,
                            height: size,
                            decoration: BoxDecoration(
                              gradient: node.isUser
                                  ? AegisColors.primaryGradient
                                  : LinearGradient(colors: [
                                      node.color,
                                      node.color.withOpacity(0.8)
                                    ]),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.9),
                                width: node.isUser ? 2.5 : 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: node.color.withOpacity(0.25),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                )
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                node.isUser
                                    ? Icons.person_rounded
                                    : (isSos
                                        ? Icons.warning_amber_rounded
                                        : Icons.sensors_rounded),
                                color: Colors.white,
                                size: node.isUser ? 18 : 14,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            node.isUser
                                ? 'You'
                                : (node.status == NodeStatus.busy
                                    ? 'Offline'
                                    : '${node.hops} hops'),
                            style: TextStyle(
                              fontSize: 8.5,
                              fontWeight: FontWeight.w700,
                              color: AegisColors.textSecondary,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          );
        }),
      ),
    );
  }

  Widget _statsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
                width: 3,
                height: 16,
                decoration: BoxDecoration(
                    gradient: AegisColors.primaryGradient,
                    borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 10),
            Text('NETWORK OVERVIEW', style: AegisStyles.overline),
          ],
        ),
        const SizedBox(height: 14),
        const MeshStatsBar(),
      ],
    );
  }

  Widget _activitySection() {
    final activity = ref.watch(meshActivityProvider);

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
                    height: 16,
                    decoration: BoxDecoration(
                        gradient: AegisColors.cyanGradient,
                        borderRadius: BorderRadius.circular(2))),
                const SizedBox(width: 10),
                Text('RECENT ACTIVITY', style: AegisStyles.overline),
              ],
            ),
            Icon(Icons.close_rounded, color: AegisColors.textMuted, size: 18),
          ],
        ),
        const SizedBox(height: 16),
        if (activity.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AegisColors.cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AegisColors.border1, width: 0.5),
            ),
            child: Center(
              child: Text(
                'Waiting for mesh activity...',
                style: TextStyle(
                  color: AegisColors.textMuted,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
        else
          ...activity.map((entry) {
            Color color;
            IconData icon;
            if (entry.contains('SOS') || entry.contains('\u{1F6E8}')) {
              color = AegisColors.sosRed;
              icon = Icons.warning_amber_rounded;
            } else if (entry.contains('chat') || entry.contains('\u{1F4AC}')) {
              color = AegisColors.electricBlue;
              icon = Icons.chat_bubble_outline_rounded;
            } else if (entry.contains('joined') ||
                entry.contains('\u{1F50D}')) {
              color = AegisColors.neonGreen;
              icon = Icons.link_rounded;
            } else {
              color = AegisColors.textMuted;
              icon = Icons.swap_horiz_rounded;
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _activityLog(color, icon, entry, ''),
            );
          }),
      ],
    );
  }

  Widget _activityLog(Color color, IconData icon, String text, String time) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AegisColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AegisColors.border1, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 15),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AegisColors.textPrimary),
            ),
          ),
          Text(time,
              style: TextStyle(
                  fontSize: 11,
                  color: AegisColors.textMuted,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AegisColors.cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AegisColors.border1, width: 0.5),
          ),
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AegisColors.sosRed.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: AegisColors.sosRed.withOpacity(0.2), width: 1),
                ),
                child: Icon(Icons.wifi_off_rounded,
                    color: AegisColors.sosRed, size: 26),
              ),
              const SizedBox(height: 16),
              Text(
                '0 nodes detected',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AegisColors.textPrimary,
                    letterSpacing: -0.3),
              ),
              const SizedBox(height: 8),
              Text(
                'Make sure other AEGIS devices are\non the same WiFi network.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13,
                    color: AegisColors.textSecondary,
                    height: 1.5),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _legendItem(AegisColors.neonGreen, 'Strong'),
            const SizedBox(width: 24),
            _legendItem(AegisColors.warning, 'Medium'),
            const SizedBox(width: 24),
            _legendItem(AegisColors.sosRed, 'Weak'),
            const SizedBox(width: 24),
            _legendItem(AegisColors.textMuted, 'Offline'),
          ],
        ),
      ],
    );
  }

  Widget _legendItem(Color c, String t) {
    return Column(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: c,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: c.withOpacity(0.4), blurRadius: 6, spreadRadius: 1)
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(t,
            style: TextStyle(
                color: AegisColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w500)),
      ],
    );
  }
}
