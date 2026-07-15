import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';
import 'onboarding_screen.dart';

class MeshGlobePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height + 40.0);
    final double radius = size.width * 0.95;

    // Draw the main glowing arc outline
    final arcPaint = Paint()
      ..color = AegisColors.primaryBlue.withOpacity(0.4)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    
    canvas.drawCircle(center, radius, arcPaint);

    // Draw inner concentric earth grid arches
    final gridPaint = Paint()
      ..color = AegisColors.primaryBlue.withOpacity(0.12)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    for (double r = radius * 0.82; r < radius * 0.99; r += 12.0) {
      canvas.drawCircle(center, r, gridPaint);
    }

    // Draw longitudinal lines starting from top of curve spreading down
    final double startAngle = -pi * 0.85;
    final double endAngle = -pi * 0.15;
    final int lineCount = 18;

    for (int i = 0; i <= lineCount; i++) {
      final double fraction = i / lineCount;
      final double angle = startAngle + (endAngle - startAngle) * fraction;
      
      final Offset topPoint = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      
      // Draw intersecting grid line extending towards center
      canvas.drawLine(
        topPoint,
        Offset(center.dx + radius * 0.72 * cos(angle), center.dy + radius * 0.72 * sin(angle)),
        gridPaint,
      );
    }

    // Draw mesh connection network lines between points
    final Random rand = Random(42);
    final List<Offset> points = [];

    // Generate random nodes near surface
    for (int i = 0; i < 28; i++) {
      final double angleFraction = rand.nextDouble();
      final double angle = startAngle + (endAngle - startAngle) * angleFraction;
      final double radFraction = 0.85 + rand.nextDouble() * 0.14;
      final double r = radius * radFraction;

      points.add(Offset(
        center.dx + r * cos(angle),
        center.dy + r * sin(angle),
      ));
    }

    // Draw connecting lines between close points
    final lineConnPaint = Paint()
      ..color = AegisColors.primaryBlue.withOpacity(0.18)
      ..strokeWidth = 0.8;

    for (int i = 0; i < points.length; i++) {
      for (int j = i + 1; j < points.length; j++) {
        final double dist = (points[i] - points[j]).distance;
        if (dist < 55.0) {
          canvas.drawLine(points[i], points[j], lineConnPaint);
        }
      }
    }

    // Draw shining node dots
    for (int i = 0; i < points.length; i++) {
      final double size = i % 4 == 0 ? 3.0 : 1.5;
      final Color color = i % 3 == 0 
          ? AegisColors.warningOrange 
          : (i % 2 == 0 ? AegisColors.primaryBlue : Colors.white);

      final Paint dotPaint = Paint()..color = color.withOpacity(0.8);
      canvas.drawCircle(points[i], size, dotPaint);

      // Glowing aura for larger dots
      if (i % 4 == 0) {
        final Paint glowPaint = Paint()..color = color.withOpacity(0.18);
        canvas.drawCircle(points[i], size * 3.0, glowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const OnboardingScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AegisColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Stars background details
            Positioned.fill(
              child: CustomPaint(
                painter: StarsBackgroundPainter(),
              ),
            ),

            // Main Contents (Logo, Title, Slogan)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40.0),
                  // Shield gradient logo
                  Container(
                    width: 104.0,
                    height: 104.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AegisColors.primaryBlue.withOpacity(0.12),
                          blurRadius: 28,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.shield_outlined,
                            size: 96.0,
                            color: AegisColors.primaryBlue,
                          ),
                          const Positioned(
                            top: 26.0,
                            child: Text(
                              'A',
                              style: TextStyle(
                                fontSize: 32.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Monospace',
                              ),
                            ),
                          ),
                          const Positioned(
                            bottom: 24.0,
                            child: Icon(
                              Icons.wifi_tethering_rounded,
                              color: AegisColors.primaryBlue,
                              size: 18.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),

                  // Slogan Title text
                  const Text(
                    'AEGIS',
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  const Text(
                    'The Autonomous\nHuman Communication\nNetwork',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      height: 1.5,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 100.0),
                ],
              ),
            ),

            // Earth Globe mesh bottom canvas layout
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 150.0,
              child: CustomPaint(
                painter: MeshGlobePainter(),
              ),
            ),

            // Footer tagline
            Positioned(
              left: 24.0,
              right: 24.0,
              bottom: 28.0,
              child: const Text(
                'When the Internet dies,\nhumanity still speaks.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AegisColors.textSecondary,
                  fontSize: 12.0,
                  height: 1.4,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StarsBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rand = Random(12);
    final paint = Paint()..color = Colors.white.withOpacity(0.35);

    for (int i = 0; i < 45; i++) {
      final x = rand.nextDouble() * size.width;
      final y = rand.nextDouble() * size.height;
      final radius = rand.nextDouble() * 0.9;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
