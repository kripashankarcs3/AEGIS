import 'dart:math';
import 'package:flutter/material.dart';
import '../models/survivor_node.dart';
import '../constants/aegis_colors.dart';

class RadarBackgroundPainter extends CustomPainter {
  final List<SurvivorNode> nodes;
  final double pulseValue;

  RadarBackgroundPainter({required this.nodes, this.pulseValue = 0.0});

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final maxR = min(size.width, size.height) / 2 * 0.82;

    _drawBgGlow(canvas, c, maxR);
    _drawRings(canvas, c, maxR);
    _drawCrosshairs(canvas, c, maxR);
    _drawConnections(canvas, c, maxR);
  }

  void _drawBgGlow(Canvas canvas, Offset c, double maxR) {
    final g = Paint()..shader = RadialGradient(colors: [AegisColors.electricBlue.withOpacity(0.03 + 0.02 * sin(pulseValue * pi * 2)), Colors.transparent], stops: const [0.3, 1.0]).createShader(Rect.fromCircle(center: c, radius: maxR));
    canvas.drawCircle(c, maxR * 0.7, g);
  }

  void _drawRings(Canvas canvas, Offset c, double maxR) {
    for (int i = 0; i < 4; i++) {
      final r = maxR * (0.25 * (i + 1));
      final p = Paint()
        ..color = Color.lerp(const Color(0xFF00E5FF), const Color(0xFF0088FF), i / 3)!.withOpacity(0.06 + 0.04 * sin(pulseValue * pi * 2 + i * 1.2))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0 - i * 0.15;
      canvas.drawCircle(c, r, p);
      final gp = Paint()
        ..color = const Color(0xFF00E5FF).withOpacity(0.01 * (i + 1))
        ..style = PaintingStyle.fill;
      canvas.drawCircle(c, r, gp);
    }
  }

  void _drawCrosshairs(Canvas canvas, Offset c, double maxR) {
    final p = Paint()..color = const Color(0xFF00E5FF).withOpacity(0.06)..strokeWidth = 0.3;

    canvas.drawLine(Offset(c.dx - maxR, c.dy), Offset(c.dx + maxR, c.dy), p);
    canvas.drawLine(Offset(c.dx, c.dy - maxR), Offset(c.dx, c.dy + maxR), p);

    canvas.drawLine(Offset(c.dx - maxR * 0.707, c.dy - maxR * 0.707), Offset(c.dx + maxR * 0.707, c.dy + maxR * 0.707), p);
    canvas.drawLine(Offset(c.dx - maxR * 0.707, c.dy + maxR * 0.707), Offset(c.dx + maxR * 0.707, c.dy - maxR * 0.707), p);

    final dp = Paint()..color = const Color(0xFF00E5FF).withOpacity(0.03)..style = PaintingStyle.stroke..strokeWidth = 0.3;
    for (int i = 1; i <= 3; i++) {
      canvas.drawCircle(c, maxR * 0.25 * i * 1.1, dp);
    }
  }

  void _drawConnections(Canvas canvas, Offset c, double maxR) {
    final user = nodes.where((n) => n.isUser).firstOrNull;
    if (user == null) return;

    for (final node in nodes) {
      if (node.isUser) continue;
      final pos = Offset(c.dx + node.dx * maxR, c.dy + node.dy * maxR);

      if (node.status == NodeStatus.sos) {
        for (int i = 0; i < 3; i++) {
          final glow = Paint()..color = AegisColors.sosRed.withOpacity(0.06 + 0.04 * sin(pulseValue * pi * 2))..maskFilter = MaskFilter.blur(BlurStyle.normal, 8 + i * 4);
          canvas.drawLine(c, pos, glow);
        }
        for (int i = 0; i < 3; i++) {
          final pp = Paint()..color = AegisColors.sosRed.withOpacity(0.4 - i * 0.1)..strokeWidth = 2.0;
          final t = ((pulseValue * 3 + i * 0.33) % 1.0);
          canvas.drawCircle(Offset(c.dx + (pos.dx - c.dx) * t, c.dy + (pos.dy - c.dy) * t), 3.0 - i * 0.8, pp);
        }
      }

      final lc = node.color.withOpacity(node.status == NodeStatus.offline ? 0.06 : 0.12 + 0.06 * sin(pulseValue * pi * 2 + node.dx));
      final lp = Paint()..color = lc..strokeWidth = node.status == NodeStatus.relay ? 1.5 : 1.0;

      if (node.status == NodeStatus.offline) {
        _dashedLine(canvas, c, pos, lp);
      } else {
        canvas.drawLine(c, pos, lp);
        canvas.drawCircle(pos, 2.5, Paint()..color = node.color.withOpacity(0.25));
      }
    }

    for (int i = 0; i < nodes.length; i++) {
      for (int j = i + 1; j < nodes.length; j++) {
        final a = nodes[i], b = nodes[j];
        if (a.isUser || b.isUser) continue;
        if (a.status == NodeStatus.offline || b.status == NodeStatus.offline) continue;
        final ap = Offset(c.dx + a.dx * maxR, c.dy + a.dy * maxR);
        final bp = Offset(c.dx + b.dx * maxR, c.dy + b.dy * maxR);
        canvas.drawLine(ap, bp, Paint()..color = const Color(0xFF00E5FF).withOpacity(0.03)..strokeWidth = 0.3);
      }
    }
  }

  void _dashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    final dx = p2.dx - p1.dx, dy = p2.dy - p1.dy;
    final dist = sqrt(dx * dx + dy * dy);
    const dl = 3.0, sl = 3.0;
    final cnt = (dist / (dl + sl)).floor();
    for (int i = 0; i < cnt; i++) {
      final s = i * (dl + sl) / dist;
      final e = (s + dl / dist).clamp(0.0, 1.0);
      canvas.drawLine(Offset(p1.dx + dx * s, p1.dy + dy * s), Offset(p1.dx + dx * e, p1.dy + dy * e), paint);
    }
  }

  @override
  bool shouldRepaint(covariant RadarBackgroundPainter old) => true;
}

class RadarVisualization extends StatefulWidget {
  final List<SurvivorNode> nodes;
  final VoidCallback? onLocateTap;
  final ValueChanged<SurvivorNode>? onNodeTap;

  const RadarVisualization({super.key, required this.nodes, this.onLocateTap, this.onNodeTap});

  @override
  State<RadarVisualization> createState() => _RadarVisualizationState();
}

class _RadarVisualizationState extends State<RadarVisualization> with TickerProviderStateMixin {
  late AnimationController _pulse;
  late Animation<double> _pulseA;
  late List<AnimationController> _floatCtrls;
  late List<Animation<double>> _floatAnims;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
    _pulseA = Tween<double>(begin: 0.0, end: 1.0).animate(_pulse);

    _floatCtrls = widget.nodes.map((n) => AnimationController(vsync: this, duration: Duration(milliseconds: 2000 + (n.dx * 800).abs().toInt()))..repeat(reverse: true)).toList();
    _floatAnims = _floatCtrls.map((c) => Tween<double>(begin: -4.0, end: 4.0).animate(CurvedAnimation(parent: c, curve: Curves.easeInOutSine))).toList();
  }

  @override
  void dispose() {
    _pulse.dispose();
    for (final c in _floatCtrls) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (_, __) {
        return AspectRatio(
          aspectRatio: 1.15,
          child: LayoutBuilder(builder: (context, constraints) {
            final c = Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);
            final maxR = min(constraints.maxWidth, constraints.maxHeight) / 2 * 0.82;

            return Stack(
              clipBehavior: Clip.none,
              children: [
                CustomPaint(painter: RadarBackgroundPainter(nodes: widget.nodes, pulseValue: _pulseA.value)),
                ...widget.nodes.asMap().entries.map((e) {
                  final i = e.key, node = e.value;
                  final floatY = _floatAnims.length > i ? _floatAnims[i].value : 0.0;
                  final nx = c.dx + node.dx * maxR;
                  final ny = c.dy + node.dy * maxR + floatY;
                  final size = node.isUser ? 42.0 : 34.0;
                  final isSos = node.status == NodeStatus.sos;

                  return Positioned(
                    left: nx - size / 2, top: ny - size / 2,
                    child: GestureDetector(
                      onTap: () => widget.onNodeTap?.call(node),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Stack(alignment: Alignment.center, children: [
                          if (isSos) ...[
                            Container(width: size + 18, height: size + 18, decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: AegisColors.sosRed.withOpacity(0.2 + 0.15 * sin(_pulseA.value * pi * 2)), blurRadius: 24 + 12 * sin(_pulseA.value * pi * 2), spreadRadius: 6 + 6 * sin(_pulseA.value * pi * 2))])),
                            Container(width: size + 12, height: size + 12, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AegisColors.sosRed.withOpacity(0.3 + 0.2 * sin(_pulseA.value * pi * 2)), width: 2.5))),
                          ],
                          if (node.isUser)
                            Container(width: size, height: size, decoration: BoxDecoration(gradient: AegisColors.primaryGradient, shape: BoxShape.circle, border: Border.all(color: Colors.white.withOpacity(0.9), width: 2.5), boxShadow: AegisColors.glowBlue), child: Center(child: Icon(Icons.person_rounded, color: Colors.white, size: 22)))
                          else
                            Container(width: size, height: size, decoration: BoxDecoration(color: node.color, shape: BoxShape.circle, border: Border.all(color: isSos ? AegisColors.sosRed : AegisColors.border2, width: 2), boxShadow: [BoxShadow(color: node.color.withOpacity(isSos ? 0.5 : 0.25), blurRadius: isSos ? 16 : 10, spreadRadius: isSos ? 4 : 2)]), child: Center(child: Icon(isSos ? Icons.warning_amber_rounded : Icons.sensors_rounded, color: Colors.white, size: 16))),
                        ]),
                        if (node.isUser) ...[
                          const SizedBox(height: 6),
                          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.white.withOpacity(0.15), width: 0.5)), child: const Text('YOU', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 1.0))),
                        ],
                      ]),
                    ),
                  );
                }),
                Positioned(right: 14, bottom: 24, child: GestureDetector(onTap: widget.onLocateTap, child: Container(width: 38, height: 38, decoration: BoxDecoration(color: AegisColors.surface2, shape: BoxShape.circle, border: Border.all(color: AegisColors.border2, width: 0.5)), child: const Center(child: Icon(Icons.gps_fixed_rounded, size: 17, color: AegisColors.textSecondary))))),
                if (widget.nodes.length == 1)
                  Positioned(left: c.dx - 100, top: c.dy + maxR * 0.3, child: SizedBox(width: 200, child: Column(mainAxisSize: MainAxisSize.min, children: [Text('Scanning for survivors...', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white.withOpacity(0.6), letterSpacing: 0.5)), const SizedBox(height: 16), SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation<Color>(AegisColors.neonGreen.withOpacity(0.6))))]))),
              ],
            );
          }),
        );
      },
    );
  }
}
