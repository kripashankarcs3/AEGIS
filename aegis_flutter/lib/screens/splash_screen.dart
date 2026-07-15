import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';
import 'onboarding_screen.dart';

class MeshGlobePainter extends CustomPainter {
  final double rotationAngle;

  MeshGlobePainter({required this.rotationAngle});

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

    // Draw longitudinal lines with rotation angle offset
    final double startAngle = -pi * 0.85;
    final double endAngle = -pi * 0.15;
    final int lineCount = 18;

    for (int i = 0; i <= lineCount; i++) {
      // Calculate fraction and wrap it around using rotationAngle to create sliding grid effect
      final double baseFraction = i / lineCount;
      // Add rotationAngle offset (scaled to fit slide cycle)
      final double fraction = (baseFraction + (rotationAngle / (2 * pi))) % 1.0;
      final double angle = startAngle + (endAngle - startAngle) * fraction;
      
      final Offset topPoint = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      
      canvas.drawLine(
        topPoint,
        Offset(center.dx + radius * 0.72 * cos(angle), center.dy + radius * 0.72 * sin(angle)),
        gridPaint,
      );
    }

    // Draw rotating mesh points
    final Random rand = Random(42);
    final List<Offset> points = [];
    final int pointCount = 28;

    for (int i = 0; i < pointCount; i++) {
      final double baseAngleFraction = rand.nextDouble();
      // Add rotation angle drift based on node offset
      final double angleFraction = (baseAngleFraction + (rotationAngle / (2 * pi))) % 1.0;
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
  bool shouldRepaint(covariant MeshGlobePainter oldDelegate) {
    return oldDelegate.rotationAngle != rotationAngle;
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _globeController;
  late AnimationController _logoController;
  late AnimationController _twinkleController;

  late Animation<double> _logoScale;
  late Animation<double> _logoFade;

  @override
  void initState() {
    super.initState();

    // 1. Globe rotation controller
    _globeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // 2. Logo entrance controller
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _logoScale = CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    );

    _logoFade = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeIn,
    );

    _logoController.forward();

    // 3. Twinkle controller
    _twinkleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    // Transition timer
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const OnboardingScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _globeController.dispose();
    _logoController.dispose();
    _twinkleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AegisColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Twinkling Stars Background
            AnimatedBuilder(
              animation: _twinkleController,
              builder: (context, child) {
                return Positioned.fill(
                  child: CustomPaint(
                    painter: StarsBackgroundPainter(twinkleValue: _twinkleController.value),
                  ),
                );
              },
            ),

            // Main Contents (Animated Logo, Title, Slogan)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40.0),
                  
                  // Pulse Scale Logo
                  ScaleTransition(
                    scale: _logoScale,
                    child: FadeTransition(
                      opacity: _logoFade,
                      child: Container(
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

            // 3D Rotating Earth Globe Mesh
            AnimatedBuilder(
              animation: _globeController,
              builder: (context, child) {
                return Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 150.0,
                  child: CustomPaint(
                    painter: MeshGlobePainter(rotationAngle: _globeController.value * 2 * pi),
                  ),
                );
              },
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
  final double twinkleValue;

  StarsBackgroundPainter({required this.twinkleValue});

  @override
  void paint(Canvas canvas, Size size) {
    final rand = Random(12);
    
    for (int i = 0; i < 45; i++) {
      final x = rand.nextDouble() * size.width;
      final y = rand.nextDouble() * size.height;
      final radius = rand.nextDouble() * 0.9;
      
      // Calculate individual star twinkle opacity offset
      final double twinkleOffset = rand.nextDouble();
      final double opacity = ((twinkleValue + twinkleOffset) % 1.0).clamp(0.15, 0.75);

      final Paint paint = Paint()..color = Colors.white.withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant StarsBackgroundPainter oldDelegate) {
    return oldDelegate.twinkleValue != twinkleValue;
  }
}
