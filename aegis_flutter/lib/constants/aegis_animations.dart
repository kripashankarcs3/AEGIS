import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'aegis_colors.dart';

class AegisAnim {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration med = Duration(milliseconds: 400);
  static const Duration slow = Duration(milliseconds: 600);
  static const Duration verySlow = Duration(milliseconds: 900);

  static const Curve easeOut = Curves.easeOutCubic;
  static const Curve easeInOut = Curves.easeInOutCubic;
  static const Curve spring = Curves.fastOutSlowIn;
  static const Curve bounce = Curves.elasticOut;

  static Tween<Offset> slideUp(double d) => Tween<Offset>(begin: Offset(0, d), end: Offset.zero);
  static Tween<Offset> slideRight(double d) => Tween<Offset>(begin: Offset(d, 0), end: Offset.zero);
}

class Breathing extends StatefulWidget {
  final Widget child;
  final double minScale;
  final double maxScale;
  final Duration duration;
  const Breathing({super.key, required this.child, this.minScale = 0.97, this.maxScale = 1.0, this.duration = const Duration(milliseconds: 2000)});

  @override State<Breathing> createState() => _BreathingState();
}
class _BreathingState extends State<Breathing> with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _a;
  @override void initState() { super.initState(); _c = AnimationController(vsync: this, duration: widget.duration)..repeat(reverse: true); _a = Tween<double>(begin: widget.minScale, end: widget.maxScale).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOutSine)); }
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => AnimatedBuilder(animation: _a, builder: (_, child) => Transform.scale(scale: _a.value, child: child), child: widget.child);
}

class PulseDot extends StatefulWidget {
  final Color color; final double size; final bool animate;
  const PulseDot({super.key, required this.color, this.size = 8, this.animate = true});
  @override State<PulseDot> createState() => _PulseDotState();
}
class _PulseDotState extends State<PulseDot> with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _a;
  @override void initState() { super.initState(); _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)); if (widget.animate) _c.repeat(reverse: true); else _c.value = 1.0; _a = Tween<double>(begin: 0.3, end: 1.0).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOutSine)); }
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => AnimatedBuilder(animation: _a, builder: (_, child) => Transform.scale(scale: _a.value, child: Container(width: widget.size, height: widget.size, decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle, boxShadow: [BoxShadow(color: widget.color.withValues(alpha: 0.5 * _a.value), blurRadius: 8, spreadRadius: 2)]))));
}

class StaggeredFadeIn extends StatefulWidget {
  final int index; final Widget child; final Duration delayPerItem;
  const StaggeredFadeIn({super.key, required this.index, required this.child, this.delayPerItem = const Duration(milliseconds: 70)});
  @override State<StaggeredFadeIn> createState() => _StaggeredFadeInState();
}
class _StaggeredFadeInState extends State<StaggeredFadeIn> with SingleTickerProviderStateMixin {
  late AnimationController _c; late Animation<double> _op; late Animation<Offset> _sl;
  @override void initState() { super.initState(); _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 400)); Future.delayed(widget.delayPerItem * widget.index, () { if (mounted) _c.forward(); }); _op = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _c, curve: Curves.easeOut)); _sl = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero).animate(CurvedAnimation(parent: _c, curve: Curves.easeOutCubic)); }
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => AnimatedBuilder(animation: _c, builder: (_, child) => Opacity(opacity: _op.value, child: Transform.translate(offset: Offset(0, _sl.value.dy * 30), child: child)), child: widget.child);
}

class RadarSweepPainter extends CustomPainter {
  final double sweepAngle; final Animation<double> progress;
  RadarSweepPainter({required this.sweepAngle, required this.progress});
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2); final r = min(size.width, size.height) / 2;
    final p = Paint()..shader = SweepGradient(center: Alignment.center, startAngle: progress.value, endAngle: progress.value + sweepAngle, colors: [AegisColors.electricCyan.withValues(alpha: 0), AegisColors.electricCyan.withValues(alpha: 0.12), AegisColors.electricBlue.withValues(alpha: 0.06), AegisColors.electricCyan.withValues(alpha: 0)]).createShader(Rect.fromCircle(center: c, radius: r));
    canvas.drawArc(Rect.fromCircle(center: c, radius: r), progress.value, sweepAngle, true, p);
  }
  @override bool shouldRepaint(covariant RadarSweepPainter old) => true;
}

class AnimatedRadarSweepWidget extends StatefulWidget {
  final Widget child; final double sweepAngle;
  const AnimatedRadarSweepWidget({super.key, required this.child, this.sweepAngle = 0.6});
  @override State<AnimatedRadarSweepWidget> createState() => _AnimatedRadarSweepWidgetState();
}
class _AnimatedRadarSweepWidgetState extends State<AnimatedRadarSweepWidget> with SingleTickerProviderStateMixin {
  late AnimationController _c; late Animation<double> _a;
  @override void initState() { super.initState(); _c = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(); _a = Tween<double>(begin: 0, end: 2 * pi).animate(_c); }
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => Stack(children: [widget.child, Positioned.fill(child: IgnorePointer(child: CustomPaint(painter: RadarSweepPainter(sweepAngle: widget.sweepAngle, progress: _a))))]);
}

class GlowContainer extends StatelessWidget {
  final Widget child; final Color color; final double blur; final double spread;
  const GlowContainer({super.key, required this.child, required this.color, this.blur = 20, this.spread = 2});
  @override Widget build(BuildContext context) => Container(decoration: BoxDecoration(boxShadow: [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: blur, spreadRadius: spread), BoxShadow(color: color.withValues(alpha: 0.1), blurRadius: blur * 2, spreadRadius: spread * 0.5)]), child: child);
}

class GlassCard extends StatelessWidget {
  final Widget child; final EdgeInsetsGeometry? padding; final double radius;
  const GlassCard({super.key, required this.child, this.padding, this.radius = 20});
  @override
  Widget build(BuildContext context) => ClipRRect(borderRadius: BorderRadius.circular(radius), child: BackdropFilter(filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20), child: Container(padding: padding ?? const EdgeInsets.all(16), decoration: BoxDecoration(gradient: AegisColors.glassGradient, borderRadius: BorderRadius.circular(radius), border: Border.all(color: AegisColors.glassBorder, width: 0.5)), child: child)));
}

class ScanningLinesPainter extends CustomPainter {
  final double progress;
  ScanningLinesPainter({this.progress = 0.0});
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, AegisColors.neonGreen.withValues(alpha: 0.06), Colors.transparent], stops: [(progress - 0.08).clamp(0.0, 1.0), progress.clamp(0.0, 1.0), (progress + 0.08).clamp(0.0, 1.0)]).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), p);
  }
  @override bool shouldRepaint(covariant ScanningLinesPainter old) => old.progress != progress;
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = AegisColors.border1.withValues(alpha: 0.12)..strokeWidth = 0.3;
    const step = 24.0;
    for (double x = 0; x <= size.width; x += step) canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    for (double y = 0; y <= size.height; y += step) canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
  }
  @override bool shouldRepaint(covariant CustomPainter old) => false;
}
