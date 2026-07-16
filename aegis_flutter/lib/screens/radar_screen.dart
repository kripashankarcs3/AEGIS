import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';
import '../constants/aegis_styles.dart';
import '../constants/aegis_animations.dart';
import '../models/survivor_node.dart';
import '../widgets/radar_painter.dart';
import '../widgets/mesh_stats_bar.dart';
import 'identity_screen.dart';
import 'notifications_screen.dart';
import 'sos_incoming_overlay.dart';
import '../widgets/node_popup_card.dart';
import 'chat_conversation_screen.dart';

class RadarScreen extends StatefulWidget {
  const RadarScreen({super.key});

  @override
  State<RadarScreen> createState() => _RadarScreenState();
}

class _RadarScreenState extends State<RadarScreen> with TickerProviderStateMixin {
  bool _isEmptyRadar = false;
  late AnimationController _scanCtrl;
  late Animation<double> _scanAnim;

  static const _nodes = [
    SurvivorNode(id: 'SIG-7F3A', hops: 0, status: NodeStatus.online, isUser: true, dx: 0.0, dy: 0.0),
    SurvivorNode(id: 'SIG-8AF3', hops: 2, status: NodeStatus.online, dx: 0.0, dy: -0.65),
    SurvivorNode(id: 'SIG-C4E1', hops: 1, status: NodeStatus.online, dx: -0.65, dy: -0.22),
    SurvivorNode(id: 'SIG-B2C1', hops: 2, status: NodeStatus.relay, dx: 0.55, dy: -0.30),
    SurvivorNode(id: 'SIG-9E10', hops: 3, status: NodeStatus.busy, dx: 0.45, dy: 0.55),
    SurvivorNode(id: 'SIG-1D9A', hops: 0, status: NodeStatus.sos, dx: -0.55, dy: 0.58),
  ];

  @override
  void initState() {
    super.initState();
    _scanCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
    _scanAnim = Tween<double>(begin: -0.2, end: 1.2).animate(_scanCtrl);
  }

  @override
  void dispose() {
    _scanCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _scanAnim,
              builder: (_, __) => Positioned.fill(child: CustomPaint(painter: ScanningLinesPainter(progress: _scanAnim.value))),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StaggeredFadeIn(index: 0, child: _header()),
                  const SizedBox(height: 16),
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
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: const DecorationImage(
                image: AssetImage('assets/images/logo.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Text('AEGIS', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: -0.5, color: Colors.white)),
        ]),
        Row(children: [
          _iconBtn(_isEmptyRadar ? Icons.wifi_off_rounded : Icons.wifi_rounded, _isEmptyRadar ? AegisColors.sosRed : AegisColors.neonGreen, () => setState(() => _isEmptyRadar = !_isEmptyRadar)),
          const SizedBox(width: 8),
          _iconBtn(Icons.notifications_none_outlined, Colors.white, () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NotificationsScreen())), badge: true),
          const SizedBox(width: 8),
          _avatarBtn(),
        ]),
      ],
    );
  }

  Widget _iconBtn(IconData icon, Color color, VoidCallback onTap, {bool badge = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38, height: 38,
        decoration: BoxDecoration(color: AegisColors.surface2, borderRadius: BorderRadius.circular(10), border: Border.all(color: AegisColors.border1, width: 0.5)),
        child: Stack(clipBehavior: Clip.none, children: [
          Center(child: Icon(icon, color: color, size: 18)),
          if (badge) Positioned(right: 6, top: 6, child: PulseDot(color: AegisColors.sosRed, size: 6)),
        ]),
      ),
    );
  }

  Widget _avatarBtn() {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const IdentityScreen())),
      child: Container(width: 38, height: 38, decoration: BoxDecoration(shape: BoxShape.circle, gradient: AegisColors.purpleGradient, border: Border.all(color: AegisColors.border2, width: 1.5)), child: const Center(child: Icon(Icons.person_rounded, size: 18, color: Colors.white))),
    );
  }

  Widget _statusRow() {
    return Row(children: [
      _chip(Icons.circle, AegisColors.neonGreen, 'Mesh Active', AegisColors.neonGreen, AegisColors.neonGreen.withOpacity(0.1), glow: true),
      const SizedBox(width: 10),
      _chip(Icons.sensors_rounded, AegisColors.violet, _isEmptyRadar ? '0 Nodes' : '8 Nodes', AegisColors.violet, AegisColors.violet.withOpacity(0.1)),
      const Spacer(),
      AnimatedBuilder(
        animation: _scanCtrl,
        builder: (_, __) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: AegisColors.neonGreen.withOpacity(0.1 * sin(_scanCtrl.value * pi) + 0.05), borderRadius: BorderRadius.circular(8)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              PulseDot(color: AegisColors.neonGreen, size: 6),
              const SizedBox(width: 6),
              Text('LIVE', style: TextStyle(color: AegisColors.neonGreen.withOpacity(0.7 * sin(_scanCtrl.value * pi) + 0.3), fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
            ]),
          );
        },
      ),
    ]);
  }

  Widget _chip(IconData icon, Color iconColor, String label, Color labelColor, Color bgColor, {bool glow = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10), border: Border.all(color: labelColor.withOpacity(0.2), width: 0.5), boxShadow: glow ? [BoxShadow(color: iconColor.withOpacity(0.15), blurRadius: 12, spreadRadius: 1)] : null),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (icon == Icons.circle) PulseDot(color: iconColor, size: 7) else Icon(icon, color: iconColor, size: 13),
        const SizedBox(width: 7),
        Text(label, style: TextStyle(color: labelColor, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.3)),
      ]),
    );
  }

  Widget _radarSection() {
    return Column(children: [
      Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(color: const Color(0xFF00E5FF).withOpacity(0.08), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFF00E5FF).withOpacity(0.15), width: 0.5)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            PulseDot(color: AegisColors.electricCyan, size: 5),
            const SizedBox(width: 8),
            Text('MESH RADAR', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AegisColors.electricCyan.withOpacity(0.8), letterSpacing: 1.5)),
          ]),
        ),
      ),
      const SizedBox(height: 12),
      Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), boxShadow: AegisColors.cardShadow),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Container(
            decoration: BoxDecoration(gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF111122), Color(0xFF0C0C16)]), border: Border.all(color: AegisColors.border1.withOpacity(0.4), width: 0.5)),
            child: AnimatedRadarSweepWidget(
              sweepAngle: 0.6,
              child: Container(
                decoration: BoxDecoration(border: Border.all(color: const Color(0xFF00E5FF).withOpacity(0.05), width: 0.5)),
                child: RadarVisualization(
                  nodes: _isEmptyRadar ? _nodes.where((n) => n.isUser).toList() : _nodes,
                  onLocateTap: () {},
                  onNodeTap: (node) {
                    if (node.id == 'SIG-1D9A') {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SosIncomingOverlayScreen()));
                    } else {
                      showModalBottomSheet(context: context, backgroundColor: Colors.transparent, isScrollControlled: true, builder: (_) => NodePopupCard(nodeId: node.id, onOpenChat: () { Navigator.of(context).pop(); Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChatConversationScreen(nodeId: node.id))); }));
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    ]);
  }

  Widget _statsSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(width: 3, height: 16, decoration: BoxDecoration(gradient: AegisColors.primaryGradient, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 10),
        const Text('NETWORK OVERVIEW', style: AegisStyles.overline),
      ]),
      const SizedBox(height: 14),
      const MeshStatsBar(),
    ]);
  }

  Widget _activitySection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(children: [
          Container(width: 3, height: 16, decoration: BoxDecoration(gradient: AegisColors.cyanGradient, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 10),
          const Text('RECENT ACTIVITY', style: AegisStyles.overline),
        ]),
        GestureDetector(
          onTap: () {},
          child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: AegisColors.electricBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: AegisColors.electricBlue.withOpacity(0.2), width: 0.5)),
            child: const Text('View all', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AegisColors.electricBlue))),
        ),
      ]),
      const SizedBox(height: 16),
      _activityLog(AegisColors.neonGreen, Icons.link_rounded, 'SIG-8AF3 joined the network', '2m ago'),
      const SizedBox(height: 10),
      _activityLog(AegisColors.electricBlue, Icons.swap_horiz_rounded, 'Packet relayed to SIG-B2C1', '3m ago'),
      const SizedBox(height: 10),
      _activityLog(AegisColors.sosRed, Icons.warning_amber_rounded, 'SOS from SIG-1D9A received', '5m ago'),
      const SizedBox(height: 10),
      _activityLog(AegisColors.textMuted, Icons.cloud_download_rounded, 'Resource from SIG-C4E1 relayed', '7m ago'),
    ]);
  }

  Widget _activityLog(Color color, IconData icon, String text, String time) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AegisColors.cardBg.withOpacity(0.6), borderRadius: BorderRadius.circular(14), border: Border.all(color: AegisColors.border1.withOpacity(0.4), width: 0.5)),
      child: Row(children: [
        Container(width: 32, height: 32, decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle), child: Icon(icon, color: color, size: 15)),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AegisColors.textPrimary))),
        Text(time, style: const TextStyle(fontSize: 11, color: AegisColors.textMuted, fontWeight: FontWeight.w500)),
      ]),
    );
  }

  Widget _emptyState() {
    return Column(children: [
      const SizedBox(height: 16),
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: AegisColors.cardBg.withOpacity(0.5), borderRadius: BorderRadius.circular(20), border: Border.all(color: AegisColors.border1.withOpacity(0.3), width: 0.5)),
        child: Column(children: [
          Container(width: 56, height: 56, decoration: BoxDecoration(color: AegisColors.sosRed.withOpacity(0.1), shape: BoxShape.circle, border: Border.all(color: AegisColors.sosRed.withOpacity(0.2), width: 1)), child: const Icon(Icons.wifi_off_rounded, color: AegisColors.sosRed, size: 26)),
          const SizedBox(height: 16),
          const Text('0 nodes detected', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: -0.3)),
          const SizedBox(height: 8),
          Text('Make sure other AEGIS devices are\non the same WiFi network.', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: AegisColors.textSecondary.withOpacity(0.7), height: 1.5)),
        ]),
      ),
      const SizedBox(height: 28),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        _legendItem(AegisColors.neonGreen, 'Strong'),
        const SizedBox(width: 24),
        _legendItem(AegisColors.warning, 'Medium'),
        const SizedBox(width: 24),
        _legendItem(AegisColors.sosRed, 'Weak'),
        const SizedBox(width: 24),
        _legendItem(AegisColors.textMuted, 'Offline'),
      ]),
    ]);
  }

  Widget _legendItem(Color c, String t) {
    return Column(children: [
      Container(width: 8, height: 8, decoration: BoxDecoration(color: c, shape: BoxShape.circle, boxShadow: [BoxShadow(color: c.withOpacity(0.4), blurRadius: 6, spreadRadius: 1)])),
      const SizedBox(height: 6),
      Text(t, style: const TextStyle(color: AegisColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w500)),
    ]);
  }
}
