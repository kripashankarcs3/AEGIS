import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/aegis_colors.dart';
import '../providers/survivor_provider.dart';
import '../providers/identity_provider.dart';
import 'main_shell.dart';

class NetworkScanPainter extends CustomPainter {
  final double pulseValue;
  final int peerCount;

  NetworkScanPainter({required this.pulseValue, this.peerCount = 0});

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final maxR = min(size.width, size.height) / 2 * 0.75;

    _drawGlow(canvas, c, maxR);
    _drawRings(canvas, c, maxR);
    _drawSweep(canvas, c, maxR);
    _drawDots(canvas, c, maxR);
  }

  void _drawGlow(Canvas canvas, Offset c, double maxR) {
    final g = Paint()
      ..shader = RadialGradient(
        colors: [
          AegisColors.electricBlue.withValues(alpha: 0.04 + 0.02 * sin(pulseValue * pi * 2)),
          AegisColors.violet.withValues(alpha: 0.02 * sin(pulseValue * pi * 2 + 1)),
          Colors.transparent,
        ],
        stops: [0.2, 0.6, 1.0],
      ).createShader(Rect.fromCircle(center: c, radius: maxR));
    canvas.drawCircle(c, maxR, g);
  }

  void _drawRings(Canvas canvas, Offset c, double maxR) {
    for (int i = 0; i < 3; i++) {
      final r = maxR * (0.33 * (i + 1));
      final p = Paint()
        ..color = AegisColors.electricBlue.withValues(alpha: 0.06 + 0.03 * sin(pulseValue * pi * 2 + i * 1.5))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2 - i * 0.3;
      canvas.drawCircle(c, r, p);
    }
  }

  void _drawSweep(Canvas canvas, Offset c, double maxR) {
    final angle = pulseValue * 2 * pi;
    final sweepPaint = Paint()
      ..shader = SweepGradient(
        center: Alignment.center,
        startAngle: angle - 0.4,
        endAngle: angle + 0.4,
        colors: [
          Colors.transparent,
          AegisColors.electricBlue.withValues(alpha: 0.12),
          AegisColors.violet.withValues(alpha: 0.18),
          AegisColors.electricBlue.withValues(alpha: 0.12),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: c, radius: maxR));
    canvas.drawCircle(c, maxR, sweepPaint);

    final linePaint = Paint()
      ..color = AegisColors.electricBlue.withValues(alpha: 0.15 + 0.08 * sin(pulseValue * pi * 2))
      ..strokeWidth = 2.0
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawLine(c, Offset(c.dx + cos(angle) * maxR, c.dy + sin(angle) * maxR), linePaint);
  }

  void _drawDots(Canvas canvas, Offset c, double maxR) {
    if (peerCount == 0) return;
    for (int i = 0; i < peerCount; i++) {
      final a = (2 * pi * i) / peerCount + 0.3 * sin(pulseValue * pi * 2 + i);
      final d = 0.4 + 0.2 * sin(pulseValue * pi * 2 + i * 2);
      final pos = Offset(c.dx + cos(a) * maxR * d, c.dy + sin(a) * maxR * d);
      final dotPulse = 0.5 + 0.5 * sin(pulseValue * pi * 2 + i * 3);
      canvas.drawCircle(pos, 3 + dotPulse * 2, Paint()..color = AegisColors.neonGreen.withValues(alpha: 0.3 + 0.7 * dotPulse));
      canvas.drawCircle(pos, 5 + dotPulse * 3, Paint()..color = AegisColors.neonGreen.withValues(alpha: 0.1 * dotPulse)..maskFilter = MaskFilter.blur(BlurStyle.normal, 4));
    }
  }

  @override
  bool shouldRepaint(covariant NetworkScanPainter old) => true;
}

class NetworkScanScreen extends ConsumerStatefulWidget {
  const NetworkScanScreen({super.key});

  @override
  ConsumerState<NetworkScanScreen> createState() => _NetworkScanScreenState();
}

class _NetworkScanScreenState extends ConsumerState<NetworkScanScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _goToMainShell() {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const MainShell(),
        transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: a, child: child),
        transitionDuration: const Duration(milliseconds: 600),
      ),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final survivors = ref.watch(survivorProvider);
    final myId = ref.watch(sigIdProvider);
    final peers = survivors.values.where((n) => n.id != myId).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF070B11),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Text(
                'Scanning Network',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              AnimatedBuilder(
                animation: _pulseController,
                builder: (_, __) => Text(
                  peers.isEmpty ? 'Searching for nearby AEGIS devices...' : '${peers.length} device${peers.length == 1 ? '' : 's'} found',
                  style: TextStyle(
                    fontSize: 13,
                    color: AegisColors.textSecondary.withValues(alpha: 0.6 + 0.4 * sin(_pulseAnimation.value * pi * 2)),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (_, __) => CustomPaint(
                    painter: NetworkScanPainter(
                      pulseValue: _pulseAnimation.value,
                      peerCount: peers.length,
                    ),
                    size: Size.infinite,
                  ),
                ),
              ),
              if (peers.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AegisColors.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AegisColors.border1, width: 0.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DISCOVERED DEVICES',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AegisColors.textMuted,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...peers.map((peer) => Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: AegisColors.surface2,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AegisColors.border1, width: 0.5),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: AegisColors.neonGreen.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.sensors_rounded, color: AegisColors.neonGreen, size: 16),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(peer.id, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                                  const SizedBox(height: 2),
                                  Text(
                                    peer.status == 'safe' ? 'Online' : 'Need help',
                                    style: TextStyle(fontSize: 11, color: peer.status == 'safe' ? AegisColors.neonGreen : AegisColors.sosRed),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: AegisColors.neonGreen,
                                shape: BoxShape.circle,
                                boxShadow: [BoxShadow(color: AegisColors.neonGreen.withValues(alpha: 0.5), blurRadius: 6)],
                              ),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              _buildActionButton(peers.isNotEmpty),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(bool hasPeers) {
    if (hasPeers) {
      return GestureDetector(
        onTap: _goToMainShell,
        child: Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            gradient: AegisColors.primaryGradient,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: AegisColors.electricBlue.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6))],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Text('ENTER MESH NETWORK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15, letterSpacing: 0.5)),
            ],
          ),
        ),
      );
    }
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: _goToMainShell,
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFF161A22),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF374151), width: 1),
              ),
              child: Center(
                child: Text('SKIP', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14, letterSpacing: 0.5)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
