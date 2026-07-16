import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';
import '../constants/aegis_animations.dart';
import 'identity_screen.dart';
import '../widgets/node_popup_card.dart';
import 'chat_conversation_screen.dart';

class MapMarkerNode {
  final String label; final Color color; final double dx; final double dy; final bool isUser; final IconData icon;
  const MapMarkerNode({required this.label, required this.color, required this.dx, required this.dy, this.isUser = false, required this.icon});
}

class SurvivorMapPainter extends CustomPainter {
  final List<MapMarkerNode> nodes; final double pulseValue;
  SurvivorMapPainter({required this.nodes, this.pulseValue = 0.0});

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2); final maxR = min(size.width, size.height) / 2 * 0.82;
    _rings(canvas, c, maxR); _grid(canvas, c, maxR); _conns(canvas, c, maxR);
  }

  void _rings(Canvas canvas, Offset c, double maxR) {
    final p = Paint()..color = const Color(0xFF1E293B).withOpacity(0.2)..style = PaintingStyle.stroke..strokeWidth = 0.5;
    for (final r in [maxR * 0.35, maxR * 0.68, maxR]) canvas.drawCircle(c, r, p);
  }

  void _grid(Canvas canvas, Offset c, double maxR) {
    final p = Paint()..color = const Color(0xFF1E293B).withOpacity(0.2)..strokeWidth = 0.5;
    canvas.drawLine(Offset(c.dx - maxR, c.dy), Offset(c.dx + maxR, c.dy), p);
    canvas.drawLine(Offset(c.dx, c.dy - maxR), Offset(c.dx, c.dy + maxR), p);
  }

  void _conns(Canvas canvas, Offset c, double maxR) {
    final user = nodes.firstWhere((n) => n.isUser);
    final up = Offset(c.dx + user.dx * maxR, c.dy + user.dy * maxR);

    for (final n in nodes) {
      if (n.isUser) continue;
      final p = Offset(c.dx + n.dx * maxR, c.dy + n.dy * maxR);

      if (n.label.contains('Danger')) {
        final sg = Paint()..color = AegisColors.sosRed.withOpacity(0.1 + 0.08 * sin(pulseValue * pi * 2))..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
        canvas.drawLine(up, p, sg);
        for (int i = 0; i < 3; i++) {
          final pp = Paint()..color = AegisColors.sosRed.withOpacity(0.2 - i * 0.05)..strokeWidth = 1.5;
          final t = ((pulseValue * 3 + i * 0.33) % 1.0);
          canvas.drawCircle(Offset(up.dx + (p.dx - up.dx) * t, up.dy + (p.dy - up.dy) * t), 2, pp);
        }
      }

      final lp = Paint()..color = n.color.withOpacity(0.15)..strokeWidth = 1.0;
      _dashed(canvas, up, p, lp);
    }
  }

  void _dashed(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    final dx = p2.dx - p1.dx, dy = p2.dy - p1.dy, dist = sqrt(dx * dx + dy * dy);
    const dl = 4.0, sl = 4.0;
    final cnt = (dist / (dl + sl)).floor();
    for (int i = 0; i < cnt; i++) {
      final s = i * (dl + sl) / dist, e = (s + dl / dist).clamp(0.0, 1.0);
      canvas.drawLine(Offset(p1.dx + dx * s, p1.dy + dy * s), Offset(p1.dx + dx * e, p1.dy + dy * e), paint);
    }
  }

  @override bool shouldRepaint(covariant SurvivorMapPainter old) => true;
}

class NetworkMapScreen extends StatefulWidget {
  const NetworkMapScreen({super.key});
  @override State<NetworkMapScreen> createState() => _NetworkMapScreenState();
}

class _NetworkMapScreenState extends State<NetworkMapScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulse; late Animation<double> _pulseA;

  static const _markers = [
    MapMarkerNode(label: 'YOU', color: AegisColors.electricBlue, dx: 0.0, dy: 0.0, isUser: true, icon: Icons.person_rounded),
    MapMarkerNode(label: 'Shelter 1', color: AegisColors.violet, dx: 0.05, dy: 0.65, icon: Icons.roofing_rounded),
    MapMarkerNode(label: 'Danger 1', color: AegisColors.sosRed, dx: -0.15, dy: -0.62, icon: Icons.warning_amber_rounded),
    MapMarkerNode(label: 'Medical 1', color: AegisColors.electricBlue, dx: -0.45, dy: 0.28, icon: Icons.local_hospital_rounded),
    MapMarkerNode(label: 'Safe Zone 1', color: AegisColors.neonGreen, dx: -0.58, dy: -0.22, icon: Icons.shield_outlined),
    MapMarkerNode(label: 'Shelter 2', color: AegisColors.warning, dx: 0.6, dy: 0.2, icon: Icons.roofing_rounded),
    MapMarkerNode(label: 'Safe Zone 2', color: AegisColors.neonGreen, dx: 0.48, dy: -0.48, icon: Icons.shield_outlined),
  ];

  @override void initState() { super.initState(); _pulse = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(); _pulseA = Tween<double>(begin: 0.0, end: 1.0).animate(_pulse); }
  @override void dispose() { _pulse.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(20, 12, 20, 100), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          StaggeredFadeIn(index: 0, child: _header()),
          const SizedBox(height: 16),
          StaggeredFadeIn(index: 1, child: _legend()),
          const SizedBox(height: 20),
          StaggeredFadeIn(index: 2, child: _map()),
          const SizedBox(height: 20),
          StaggeredFadeIn(index: 3, child: _infoCard()),
        ])),
      ),
    );
  }

  Widget _header() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(children: [
        Container(width: 40, height: 40, decoration: BoxDecoration(gradient: AegisColors.greenGradient, borderRadius: BorderRadius.circular(12), boxShadow: AegisColors.glowGreen), child: const Icon(Icons.map_outlined, color: Colors.white, size: 22)),
        const SizedBox(width: 14),
        const Text('Survivor Map', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.5)),
      ]),
      Row(children: [
        _hdrIcon(Icons.search_rounded), const SizedBox(width: 4), _hdrIcon(Icons.tune_rounded),
      ]),
    ]);
  }

  Widget _hdrIcon(IconData icon) => Container(width: 36, height: 36, decoration: BoxDecoration(color: AegisColors.surface2, borderRadius: BorderRadius.circular(10), border: Border.all(color: AegisColors.border1, width: 0.5)), child: Icon(icon, color: Colors.white, size: 18));

  Widget _legend() {
    return SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [
      _chip(AegisColors.neonGreen, 'Safe Zone'), const SizedBox(width: 8),
      _chip(AegisColors.sosRed, 'Danger'), const SizedBox(width: 8),
      _chip(AegisColors.violet, 'Shelter'), const SizedBox(width: 8),
      _chip(AegisColors.electricBlue, 'Medical'),
    ]));
  }

  Widget _chip(Color color, String label) {
    return Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7), decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(10), border: Border.all(color: color.withOpacity(0.2), width: 0.5)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 7, height: 7, decoration: BoxDecoration(color: color, shape: BoxShape.circle, boxShadow: [BoxShadow(color: color.withOpacity(0.4), blurRadius: 6, spreadRadius: 1)])),
        const SizedBox(width: 7),
        Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color.withOpacity(0.9))),
      ]));
  }

  Widget _map() {
    return AnimatedBuilder(
      animation: _pulseA,
      builder: (_, __) {
        return AspectRatio(
          aspectRatio: 1.05,
          child: Container(
            decoration: BoxDecoration(gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF111122), Color(0xFF0C0C16)]), borderRadius: BorderRadius.circular(24), border: Border.all(color: AegisColors.border1.withOpacity(0.4), width: 0.5), boxShadow: AegisColors.cardShadow),
            clipBehavior: Clip.antiAlias,
            child: LayoutBuilder(builder: (_, constraints) {
              final c = Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);
              final maxR = min(constraints.maxWidth, constraints.maxHeight) / 2 * 0.82;

              return Stack(children: [
                Positioned.fill(child: CustomPaint(painter: SurvivorMapPainter(nodes: _markers, pulseValue: _pulseA.value))),
                ..._markers.map((n) {
                  final nx = c.dx + n.dx * maxR, ny = c.dy + n.dy * maxR;
                  final s = (n.isUser ? 40.0 : 32.0);
                  final danger = n.label.contains('Danger');

                  return Positioned(left: nx - s / 2, top: ny - s / 2, child: GestureDetector(
                    onTap: () {
                      if (n.isUser) {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const IdentityScreen()));
                      } else {
                        showModalBottomSheet(context: context, backgroundColor: Colors.transparent, isScrollControlled: true,
                          builder: (_) => NodePopupCard(nodeId: n.label.startsWith('SIG-') ? n.label : 'SIG-4EBD',
                            onOpenChat: () { Navigator.of(context).pop(); Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChatConversationScreen(nodeId: n.label.startsWith('SIG-') ? n.label : 'SIG-4EBD'))); }));
                      }
                    },
                    child: danger ? _dangerNode(n, s) : n.isUser ? _userNode(n, s) : _mapNode(n, s),
                  ));
                }),
                Positioned(right: 14, bottom: 24, child: Container(width: 38, height: 38, decoration: BoxDecoration(color: AegisColors.surface2, borderRadius: BorderRadius.circular(10), border: Border.all(color: AegisColors.border2, width: 0.5)), child: const Center(child: Icon(Icons.gps_fixed_rounded, size: 18, color: AegisColors.textSecondary)))),
              ]);
            }),
          ),
        );
      },
    );
  }

  Widget _userNode(MapMarkerNode n, double s) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Container(width: s, height: s, decoration: BoxDecoration(gradient: AegisColors.primaryGradient, shape: BoxShape.circle, border: Border.all(color: Colors.white.withOpacity(0.9), width: 2.5), boxShadow: AegisColors.glowBlue), child: const Center(child: Icon(Icons.person_rounded, color: Colors.white, size: 20))),
      const SizedBox(height: 4),
      Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.white.withOpacity(0.15), width: 0.5)), child: const Text('YOU', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 1.0))),
    ]);
  }

  Widget _mapNode(MapMarkerNode n, double s) {
    return Container(width: s, height: s, decoration: BoxDecoration(gradient: LinearGradient(colors: [n.color.withOpacity(0.9), n.color.withOpacity(0.6)]), shape: BoxShape.circle, border: Border.all(color: Colors.white.withOpacity(0.3), width: 2), boxShadow: [BoxShadow(color: n.color.withOpacity(0.3), blurRadius: 10, spreadRadius: 2)]), child: Center(child: Icon(n.icon, color: Colors.white, size: 15)));
  }

  Widget _dangerNode(MapMarkerNode n, double s) {
    return AnimatedBuilder(
      animation: _pulseA,
      builder: (_, __) {
        return Container(width: s + 8, height: s + 8, decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: AegisColors.sosRed.withOpacity(0.2 + 0.15 * sin(_pulseA.value * pi * 2)), blurRadius: 16 + 8 * sin(_pulseA.value * pi * 2), spreadRadius: 3 + 3 * sin(_pulseA.value * pi * 2))]),
          child: Container(width: s, height: s, decoration: BoxDecoration(gradient: AegisColors.sosGradient, shape: BoxShape.circle, border: Border.all(color: AegisColors.sosRed.withOpacity(0.5), width: 2)), child: Center(child: Icon(n.icon, color: Colors.white, size: 15))));
      },
    );
  }

  Widget _infoCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AegisColors.cardBg, AegisColors.surface2]), borderRadius: BorderRadius.circular(20), border: Border.all(color: AegisColors.border1.withOpacity(0.4), width: 0.5), boxShadow: AegisColors.cardShadow),
      child: Row(children: [
        Container(width: 48, height: 48, decoration: BoxDecoration(color: AegisColors.neonGreen.withOpacity(0.12), shape: BoxShape.circle, border: Border.all(color: AegisColors.neonGreen.withOpacity(0.2), width: 1)), child: const Center(child: Icon(Icons.shield_outlined, color: AegisColors.neonGreen, size: 22))),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AegisColors.neonGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(4)), child: const Text('SAFE ZONE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AegisColors.neonGreen, letterSpacing: 0.5))),
          ]),
          const SizedBox(height: 6),
          const Text('Lake View Park', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: -0.2)),
          const SizedBox(height: 4),
          Text('12 km away • 15 people', style: TextStyle(fontSize: 12, color: AegisColors.textSecondary.withOpacity(0.8))),
        ])),
        Container(width: 32, height: 32, decoration: BoxDecoration(color: AegisColors.border1.withOpacity(0.3), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.chevron_right, color: AegisColors.textSecondary, size: 18)),
      ]),
    );
  }
}
