import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';
import 'onboarding_screen.dart';

class LogoShieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    
    // Create gradient shader from top-left to bottom-right
    final Paint paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF8B5CF6), // Purple
          Color(0xFF2563EB), // Blue
        ],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final w = size.width;
    final h = size.height;
    
    final path = Path();
    path.moveTo(w / 2, 0); // Top center
    path.lineTo(w * 0.88, 0); // Top right shoulder
    path.quadraticBezierTo(w, h * 0.25, w * 0.94, h * 0.45); // Right side curve
    path.quadraticBezierTo(w * 0.88, h * 0.82, w / 2, h); // Bottom right curve to point
    path.quadraticBezierTo(w * 0.12, h * 0.82, w * 0.06, h * 0.45); // Bottom left curve from point
    path.quadraticBezierTo(0, h * 0.25, w * 0.12, 0); // Left side curve to shoulder
    path.close();

    // Draw shadow glow path
    final shadowPaint = Paint()
      ..color = const Color(0xFF3B82F6).withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10.0);
    canvas.drawPath(path, shadowPaint);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MeshGlobePainter extends CustomPainter {
  final double rotationAngle;

  MeshGlobePainter({required this.rotationAngle});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height + 35.0);
    final double radius = size.width * 0.95;

    // Draw glow backdrop behind the globe horizon
    final glowPaint = Paint()
      ..color = const Color(0xFF1D4ED8).withOpacity(0.18)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 35.0);
    canvas.drawCircle(center, radius, glowPaint);

    // Draw the main glowing arc outline (planet horizon)
    final arcPaint = Paint()
      ..color = const Color(0xFF3B82F6).withOpacity(0.55)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    
    canvas.drawCircle(center, radius, arcPaint);

    // Draw inner concentric earth grid arches (latitude curves)
    final gridPaint = Paint()
      ..color = const Color(0xFF2563EB).withOpacity(0.15)
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
      final double baseFraction = i / lineCount;
      final double fraction = (baseFraction + (rotationAngle / (2 * pi))) % 1.0;
      final double angle = startAngle + (endAngle - startAngle) * fraction;
      
      final Offset topPoint = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      
      canvas.drawLine(
        topPoint,
        Offset(center.dx + radius * 0.75 * cos(angle), center.dy + radius * 0.75 * sin(angle)),
        gridPaint,
      );
    }

    // Draw rotating mesh points
    final Random rand = Random(42);
    final List<Offset> points = [];
    final int pointCount = 30;

    for (int i = 0; i < pointCount; i++) {
      final double baseAngleFraction = rand.nextDouble();
      final double angleFraction = (baseAngleFraction + (rotationAngle / (2 * pi))) % 1.0;
      final double angle = startAngle + (endAngle - startAngle) * angleFraction;
      final double radFraction = 0.84 + rand.nextDouble() * 0.15;
      final double r = radius * radFraction;

      points.add(Offset(
        center.dx + r * cos(angle),
        center.dy + r * sin(angle),
      ));
    }

    // Draw connecting lines between close points to form the mesh grid network
    final lineConnPaint = Paint()
      ..color = const Color(0xFF3B82F6).withOpacity(0.25)
      ..strokeWidth = 0.8;

    for (int i = 0; i < points.length; i++) {
      for (int j = i + 1; j < points.length; j++) {
        final double dist = (points[i] - points[j]).distance;
        if (dist < 60.0) {
          canvas.drawLine(points[i], points[j], lineConnPaint);
        }
      }
    }

    // Draw shining node dots (blue, orange, white)
    for (int i = 0; i < points.length; i++) {
      final double size = i % 5 == 0 ? 3.0 : 1.5;
      final Color color = i % 3 == 0 
          ? const Color(0xFFF97316) // Warning Orange
          : (i % 2 == 0 ? const Color(0xFF60A5FA) : Colors.white);

      final Paint dotPaint = Paint()..color = color.withOpacity(0.85);
      canvas.drawCircle(points[i], size, dotPaint);
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

    // 3. Twinkle controller for stars
    _twinkleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    // Transition to onboarding after 3.5 seconds
    Timer(const Duration(milliseconds: 3500), () {
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

            // Main Contents (Animated Logo, Title, Subtitle)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20.0),
                  
                  // Premium Custom Painted Shield Logo
                  ScaleTransition(
                    scale: _logoScale,
                    child: FadeTransition(
                      opacity: _logoFade,
                      child: SizedBox(
                        width: 90.0,
                        height: 104.0,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Custom Shield Painter
                            Positioned.fill(
                              child: CustomPaint(
                                painter: LogoShieldPainter(),
                              ),
                            ),
                            // Shield inner 'A' text
                            const Positioned(
                              top: 20.0,
                              child: Text(
                                'A',
                                style: TextStyle(
                                  fontSize: 38.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'sans-serif',
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            // WiFi Waves inside bottom of Shield
                            const Positioned(
                              bottom: 18.0,
                              child: Icon(
                                Icons.wifi,
                                color: Color(0xFF2563EB),
                                size: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28.0),

                  // Slogan Title text (matches mockup 1)
                  const Text(
                    'AEGIS',
                    style: TextStyle(
                      fontSize: 34.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 3.0,
                    ),
                  ),
                  const SizedBox(height: 14.0),
                  const Text(
                    'The Autonomous\nHuman Communication\nNetwork',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      height: 1.45,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 140.0),
                ],
              ),
            ),

            // 3D Rotating Earth Globe Mesh (Horizon style)
            AnimatedBuilder(
              animation: _globeController,
              builder: (context, child) {
                return Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 160.0,
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
              bottom: 24.0,
              child: const Text(
                'When the Internet dies,\nhumanity still speaks.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AegisColors.textSecondary,
                  fontSize: 11.5,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
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
    
    for (int i = 0; i < 50; i++) {
      final x = rand.nextDouble() * size.width;
      final y = rand.nextDouble() * size.height;
      final radius = rand.nextDouble() * 0.95;
      
      final double twinkleOffset = rand.nextDouble();
      final double opacity = ((twinkleValue + twinkleOffset) % 1.0).clamp(0.12, 0.8);

      final Paint paint = Paint()..color = Colors.white.withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant StarsBackgroundPainter oldDelegate) {
    return oldDelegate.twinkleValue != twinkleValue;
  }
}
