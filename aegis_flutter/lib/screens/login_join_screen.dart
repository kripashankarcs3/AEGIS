import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';
import 'splash_screen.dart';
import 'main_shell.dart';

class LoginJoinScreen extends StatefulWidget {
  const LoginJoinScreen({super.key});

  @override
  State<LoginJoinScreen> createState() => _LoginJoinScreenState();
}

class _LoginJoinScreenState extends State<LoginJoinScreen> with TickerProviderStateMixin {
  late AnimationController _globeCtrl;
  late AnimationController _btnsCtrl;
  late AnimationController _twinkleCtrl;

  late Animation<double> _b1F, _b2F, _b3F;
  late Animation<Offset> _b1S, _b2S, _b3S;

  @override
  void initState() {
    super.initState();
    _globeCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 20))..repeat();
    _btnsCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));

    _b1F = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _btnsCtrl, curve: const Interval(0.0, 0.45, curve: Curves.easeIn)));
    _b1S = Tween<Offset>(begin: const Offset(0.0, 0.2), end: Offset.zero).animate(CurvedAnimation(parent: _btnsCtrl, curve: const Interval(0.0, 0.45, curve: Curves.easeOut)));
    _b2F = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _btnsCtrl, curve: const Interval(0.3, 0.75, curve: Curves.easeIn)));
    _b2S = Tween<Offset>(begin: const Offset(0.0, 0.2), end: Offset.zero).animate(CurvedAnimation(parent: _btnsCtrl, curve: const Interval(0.3, 0.75, curve: Curves.easeOut)));
    _b3F = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _btnsCtrl, curve: const Interval(0.6, 1.0, curve: Curves.easeIn)));
    _b3S = Tween<Offset>(begin: const Offset(0.0, 0.2), end: Offset.zero).animate(CurvedAnimation(parent: _btnsCtrl, curve: const Interval(0.6, 1.0, curve: Curves.easeOut)));
    _btnsCtrl.forward();

    _twinkleCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);
  }

  @override
  void dispose() { _globeCtrl.dispose(); _btnsCtrl.dispose(); _twinkleCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AegisColors.background,
      body: SafeArea(
        child: Stack(children: [
          AnimatedBuilder(animation: _twinkleCtrl, builder: (_, __) => Positioned.fill(child: CustomPaint(painter: _StarsBgPainter(twinkleValue: _twinkleCtrl.value)))),
          AnimatedBuilder(animation: _globeCtrl, builder: (_, __) => Positioned(left: 0, right: 0, bottom: 0, height: 160, child: CustomPaint(painter: _MeshGlobePainter(rotation: _globeCtrl.value * 2 * pi)))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              const SizedBox(height: 48),
              const Text('Join the Network', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.5)),
              const SizedBox(height: 8),
              Text('Choose a way to continue', style: TextStyle(fontSize: 13, color: AegisColors.textSecondary.withOpacity(0.8))),
              const SizedBox(height: 56),
              FadeTransition(opacity: _b1F, child: SlideTransition(position: _b1S, child: GestureDetector(
                onTap: () => _nav(context),
                child: Container(width: double.infinity, height: 54, decoration: BoxDecoration(gradient: AegisColors.purpleGradient, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: AegisColors.violet.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 6))]),
                  child: Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Icon(Icons.phone_rounded, color: Colors.white, size: 20),
                    const SizedBox(width: 12),
                    const Text('Continue with Phone', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15, letterSpacing: -0.2)),
                  ]))),
              ))),
              const SizedBox(height: 16),
              FadeTransition(opacity: _b2F, child: SlideTransition(position: _b2S, child: _outlineBtn(context, Icons.qr_code_scanner_rounded, 'Scan QR Code'))),
              const SizedBox(height: 16),
              FadeTransition(opacity: _b3F, child: SlideTransition(position: _b3S, child: _outlineBtn(context, Icons.person_outline_rounded, 'Join as Guest'))),
              const SizedBox(height: 48),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.portable_wifi_off_rounded, color: AegisColors.textSecondary.withOpacity(0.6), size: 20),
                const SizedBox(width: 12),
                Text('No Internet? No problem.\nAEGIS works offline.', textAlign: TextAlign.left, style: TextStyle(color: AegisColors.textSecondary.withOpacity(0.8), fontSize: 12, height: 1.4, fontWeight: FontWeight.w500)),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }

  void _nav(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(PageRouteBuilder(pageBuilder: (_, a, __) => const MainShell(), transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: a, child: child), transitionDuration: const Duration(milliseconds: 600)), (r) => false);
  }

  Widget _outlineBtn(BuildContext context, IconData icon, String label) {
    return GestureDetector(
      onTap: () => _nav(context),
      child: Container(width: double.infinity, height: 54, decoration: BoxDecoration(color: AegisColors.surface2.withOpacity(0.8), borderRadius: BorderRadius.circular(16), border: Border.all(color: AegisColors.border1.withOpacity(0.6), width: 0.5)),
        child: Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15, letterSpacing: -0.2)),
        ]))),
    );
  }
}

class _StarsBgPainter extends CustomPainter {
  final double twinkleValue;
  _StarsBgPainter({this.twinkleValue = 0.0});

  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(42);
    for (int i = 0; i < 60; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height * 0.6;
      final r = rng.nextDouble() * 1.5 + 0.3;
      final a = (0.1 + 0.4 * (rng.nextDouble() + twinkleValue) / 2).clamp(0.0, 0.5);
      canvas.drawCircle(Offset(x, y), r, Paint()..color = Colors.white.withOpacity(a));
    }
  }

  @override bool shouldRepaint(covariant _StarsBgPainter old) => old.twinkleValue != twinkleValue;
}

class _MeshGlobePainter extends CustomPainter {
  final double rotation;
  _MeshGlobePainter({this.rotation = 0.0});

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final maxR = min(size.width, size.height) * 0.45;

    final g = Paint()..shader = RadialGradient(colors: [AegisColors.electricBlue.withOpacity(0.08), Colors.transparent]).createShader(Rect.fromCircle(center: c, radius: maxR));
    canvas.drawCircle(c, maxR, g);

    final lp = Paint()..color = AegisColors.electricBlue.withOpacity(0.08)..strokeWidth = 0.5;
    for (int i = 0; i < 8; i++) {
      final a = rotation + (i * pi / 4);
      final dx = cos(a) * maxR, dy = sin(a) * maxR;
      canvas.drawLine(Offset(c.dx - dx, c.dy - dy), Offset(c.dx + dx, c.dy + dy), lp);
    }

    for (int i = 0; i < 4; i++) {
      canvas.drawCircle(c, maxR * (i + 1) / 4, lp);
    }
  }

  @override bool shouldRepaint(covariant _MeshGlobePainter old) => old.rotation != rotation;
}
