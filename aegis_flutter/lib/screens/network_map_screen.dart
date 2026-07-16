import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';
import '../constants/aegis_styles.dart';
import '../constants/aegis_animations.dart';
import 'identity_screen.dart';
import '../widgets/node_popup_card.dart';
import 'chat_conversation_screen.dart';

class MapNodeItem {
  final String id;
  final String subText;
  final Color color;
  final double dx;
  final double dy;
  final bool isUser;
  final bool isOnline;

  const MapNodeItem({
    required this.id,
    required this.subText,
    required this.color,
    required this.dx,
    required this.dy,
    this.isUser = false,
    this.isOnline = true,
  });
}

class SurvivorMapPainter extends CustomPainter {
  final double pulseValue;
  SurvivorMapPainter({this.pulseValue = 0.0});

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final maxR = min(size.width, size.height) / 2 * 0.82;

    _drawGrid(canvas, c, maxR);
    _drawConnections(canvas, c, maxR);
  }

  void _drawGrid(Canvas canvas, Offset c, double maxR) {
    final p = Paint()
      ..color = AegisColors.isLight ? Colors.black.withOpacity(0.06) : const Color(0xFF00E5FF).withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    // Rings
    for (final r in [maxR * 0.35, maxR * 0.68, maxR]) {
      canvas.drawCircle(c, r, p);
    }

    // Lines
    canvas.drawLine(Offset(c.dx - maxR, c.dy), Offset(c.dx + maxR, c.dy), p);
    canvas.drawLine(Offset(c.dx, c.dy - maxR), Offset(c.dx, c.dy + maxR), p);
  }

  void _drawConnections(Canvas canvas, Offset c, double maxR) {
    final center = c;
    final nodes = [
      {'dx': 0.08, 'dy': -0.58, 'status': 'strong'},
      {'dx': 0.58, 'dy': -0.22, 'status': 'weak'},
      {'dx': 0.45, 'dy': 0.38, 'status': 'offline'},
      {'dx': -0.08, 'dy': 0.58, 'status': 'strong'},
      {'dx': -0.58, 'dy': 0.22, 'status': 'weak'},
      {'dx': -0.48, 'dy': -0.38, 'status': 'strong'},
    ];

    for (final node in nodes) {
      final pos = Offset(c.dx + (node['dx'] as double) * maxR, c.dy + (node['dy'] as double) * maxR);
      final status = node['status'] as String;

      if (status == 'strong') {
        final paint = Paint()
          ..color = AegisColors.neonGreen.withOpacity(AegisColors.isLight ? 0.4 : 0.25)
          ..strokeWidth = 2.0;
        canvas.drawLine(center, pos, paint);
      } else if (status == 'weak') {
        final paint = Paint()
          ..color = AegisColors.orange.withOpacity(AegisColors.isLight ? 0.5 : 0.3)
          ..strokeWidth = 1.5;
        _drawDashedLine(canvas, center, pos, paint);
      } else {
        final paint = Paint()
          ..color = AegisColors.textMuted.withOpacity(AegisColors.isLight ? 0.3 : 0.15)
          ..strokeWidth = 1.0;
        _drawDottedLine(canvas, center, pos, paint);
      }
    }
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    final dx = p2.dx - p1.dx, dy = p2.dy - p1.dy;
    final dist = sqrt(dx * dx + dy * dy);
    const dl = 5.0, sl = 3.0;
    final cnt = (dist / (dl + sl)).floor();
    for (int i = 0; i < cnt; i++) {
      final s = i * (dl + sl) / dist;
      final e = (s + dl / dist).clamp(0.0, 1.0);
      canvas.drawLine(Offset(p1.dx + dx * s, p1.dy + dy * s), Offset(p1.dx + dx * e, p1.dy + dy * e), paint);
    }
  }

  void _drawDottedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    final dx = p2.dx - p1.dx, dy = p2.dy - p1.dy;
    final dist = sqrt(dx * dx + dy * dy);
    const dl = 2.0, sl = 4.0;
    final cnt = (dist / (dl + sl)).floor();
    for (int i = 0; i < cnt; i++) {
      final s = i * (dl + sl) / dist;
      canvas.drawCircle(Offset(p1.dx + dx * s, p1.dy + dy * s), 1.0, paint);
    }
  }

  @override
  bool shouldRepaint(covariant SurvivorMapPainter old) => false;
}

class NetworkMapScreen extends StatefulWidget {
  const NetworkMapScreen({super.key});

  @override
  State<NetworkMapScreen> createState() => _NetworkMapScreenState();
}

class _NetworkMapScreenState extends State<NetworkMapScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulse;
  late Animation<double> _pulseA;

  static final _nodes = [
    MapNodeItem(id: 'SIG-7F3A', subText: 'You', color: AegisColors.electricBlue, dx: 0.0, dy: 0.0, isUser: true),
    MapNodeItem(id: 'SIG-8AF3', subText: '2 hops', color: AegisColors.neonGreen, dx: 0.08, dy: -0.58),
    MapNodeItem(id: 'SIG-B2C1', subText: '2 hops', color: AegisColors.orange, dx: 0.58, dy: -0.22),
    MapNodeItem(id: 'SIG-9E10', subText: 'Offline', color: AegisColors.textDim, dx: 0.45, dy: 0.38, isOnline: false),
    MapNodeItem(id: 'SIG-4D2F', subText: '1 hop', color: AegisColors.neonGreen, dx: -0.08, dy: 0.58),
    MapNodeItem(id: 'SIG-1D9A', subText: '3 hops', color: AegisColors.sosRed, dx: -0.58, dy: 0.22),
    MapNodeItem(id: 'SIG-C4E1', subText: '1 hop', color: AegisColors.neonGreen, dx: -0.48, dy: -0.38),
  ];

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
    _pulseA = Tween<double>(begin: 0.0, end: 1.0).animate(_pulse);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

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
              StaggeredFadeIn(index: 1, child: _mapWidget()),
              const SizedBox(height: 18),
              StaggeredFadeIn(index: 2, child: _legend()),
              const SizedBox(height: 24),
              StaggeredFadeIn(index: 3, child: _healthCard()),
              const SizedBox(height: 16),
              StaggeredFadeIn(index: 4, child: _statsCard()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Network Map', style: AegisStyles.h2),
            const SizedBox(height: 6),
            Row(
              children: [
                Text('• 8 Nodes Online', style: TextStyle(fontSize: 11, color: AegisColors.neonGreen, fontWeight: FontWeight.bold)),
                const SizedBox(width: 12),
                Text('• 127 Relayed', style: TextStyle(fontSize: 11, color: AegisColors.violet, fontWeight: FontWeight.bold)),
                const SizedBox(width: 12),
                Text('• Live', style: TextStyle(fontSize: 11, color: AegisColors.electricBlue, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        Row(
          children: [
            _hdrIcon(Icons.info_outline_rounded),
            const SizedBox(width: 6),
            _hdrIcon(Icons.tune_rounded),
          ],
        ),
      ],
    );
  }

  Widget _hdrIcon(IconData icon) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AegisColors.surface2,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AegisColors.border1, width: 0.5),
      ),
      child: Icon(icon, color: AegisColors.textPrimary, size: 18),
    );
  }

  Widget _legend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem(AegisColors.neonGreen, 'Strong', isDashed: false),
        const SizedBox(width: 24),
        _legendItem(AegisColors.orange, 'Weak', isDashed: true),
        const SizedBox(width: 24),
        _legendItem(AegisColors.textMuted, 'Offline', isDotted: true),
      ],
    );
  }

  Widget _legendItem(Color color, String label, {bool isDashed = false, bool isDotted = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isDashed)
          Text('---', style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: -1))
        else if (isDotted)
          Text('...', style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 0.5))
        else
          Text('—', style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 12)),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(fontSize: 12, color: AegisColors.textSecondary, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _mapWidget() {
    return AnimatedBuilder(
      animation: _pulseA,
      builder: (_, __) {
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
              final maxR = min(constraints.maxWidth, constraints.maxHeight) / 2 * 0.82;

              return Stack(
                children: [
                  Positioned.fill(child: CustomPaint(painter: SurvivorMapPainter(pulseValue: _pulseA.value))),
                  ..._nodes.map((n) {
                    final nx = c.dx + n.dx * maxR;
                    final ny = c.dy + n.dy * maxR;
                    final s = n.isUser ? 38.0 : 30.0;

                    return Positioned(
                      left: nx - 30,
                      top: ny - 30,
                      child: GestureDetector(
                        onTap: () {
                          if (n.isUser) {
                            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const IdentityScreen()));
                          } else {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              builder: (_) => NodePopupCard(
                                nodeId: n.id,
                                onOpenChat: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChatConversationScreen(nodeId: n.id)));
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
                                width: s,
                                height: s,
                                decoration: BoxDecoration(
                                  gradient: n.isUser
                                      ? AegisColors.primaryGradient
                                      : LinearGradient(colors: [n.color, n.color.withOpacity(0.8)]),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.9),
                                    width: n.isUser ? 2.5 : 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: n.color.withOpacity(0.25),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    )
                                  ],
                                ),
                                child: Center(
                                  child: Icon(
                                    n.isUser ? Icons.person_rounded : Icons.sensors_rounded,
                                    color: Colors.white,
                                    size: n.isUser ? 18 : 14,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                n.isUser ? 'You' : n.subText,
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
                  Positioned(
                    right: 14,
                    bottom: 24,
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AegisColors.surface2,
                        shape: BoxShape.circle,
                        border: Border.all(color: AegisColors.border2, width: 0.5),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.gps_fixed_rounded,
                          size: 17,
                          color: AegisColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        );
      },
    );
  }

  Widget _healthCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AegisColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AegisColors.border1, width: 0.5),
        boxShadow: AegisColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Network Health', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AegisColors.textSecondary)),
              Text('Good', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AegisColors.neonGreen)),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: 0.82,
              minHeight: 8,
              backgroundColor: AegisColors.isLight ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B),
              valueColor: AlwaysStoppedAnimation<Color>(AegisColors.neonGreen),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text('82%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AegisColors.textSecondary)),
          ),
        ],
      ),
    );
  }

  Widget _statsCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      decoration: BoxDecoration(
        color: AegisColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AegisColors.border1, width: 0.5),
        boxShadow: AegisColors.cardShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statCol('8', 'Nodes'),
          _dividerCol(),
          _statCol('127', 'Packets Relayed'),
          _dividerCol(),
          _statCol('42ms', 'Avg Latency'),
          _dividerCol(),
          _statCol('94%', 'Delivery'),
        ],
      ),
    );
  }

  Widget _statCol(String value, String label) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AegisColors.textPrimary, letterSpacing: -0.5)),
          const SizedBox(height: 4),
          Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: AegisColors.textSecondary, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _dividerCol() {
    return Container(
      width: 0.5,
      height: 32,
      color: AegisColors.border1.withOpacity(0.5),
    );
  }
}
