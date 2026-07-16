import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';
import 'onboarding_screen.dart';

class LogoShieldPainter extends CustomPainter {
  final double glowFactor;
  LogoShieldPainter({this.glowFactor = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final rect = Offset.zero & size;

    final path = Path();
    path.moveTo(w / 2, 0); // Top center
    path.lineTo(w * 0.88, 0); // Top right shoulder
    path.quadraticBezierTo(w, h * 0.25, w * 0.94, h * 0.45); // Right side curve
    path.quadraticBezierTo(w * 0.88, h * 0.82, w / 2, h); // Bottom right curve to point
    path.quadraticBezierTo(w * 0.12, h * 0.82, w * 0.06, h * 0.45); // Bottom left curve from point
    path.quadraticBezierTo(0, h * 0.25, w * 0.12, 0); // Left side curve to shoulder
    path.close();

    // 1. Outer blue bloom (glowing shadow) - Opacity 20%, Blue #256DFF
    final bloomPaint = Paint()
      ..color = const Color(0xFF256DFF).withOpacity(0.20)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0 * glowFactor
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12.0 * glowFactor);
    canvas.drawPath(path, bloomPaint);

    // 2. Glossy Glass fill (semi-transparent dark surface with radial glow)
    final fillPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment.center,
        radius: 0.8,
        colors: [
          Color(0xFF09111F), // Surface
          Color(0xFF040814), // Dark
        ],
      ).createShader(rect)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // Subtle glossy specular layer inside shield
    final specularPaint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, specularPaint);

    // 3. Gradient Outline (Purple #7B3EFF -> Blue #256DFF -> Cyan #27D8FF)
    final outlinePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF7B3EFF), // Purple
          Color(0xFF256DFF), // Blue
          Color(0xFF27D8FF), // Cyan
        ],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawPath(path, outlinePaint);

    // 4. Inner highlight: Thin white/cyan reflection at top-left edge
    final highlightPath = Path();
    highlightPath.moveTo(w * 0.20, 2.0);
    highlightPath.lineTo(w * 0.5, 2.0);
    highlightPath.moveTo(w * 0.15, 6.0);
    highlightPath.quadraticBezierTo(w * 0.08, h * 0.25, w * 0.11, h * 0.40);
    
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawPath(highlightPath, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant LogoShieldPainter oldDelegate) {
    return oldDelegate.glowFactor != glowFactor;
  }
}

class MeshGlobePainter extends CustomPainter {
  final double rotationAngle;
  final double sweepValue; // from 0.0 to 1.0
  final double pulseValue; // from 0.0 to 1.0

  MeshGlobePainter({
    required this.rotationAngle,
    required this.sweepValue,
    required this.pulseValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height + 40.0);
    final double radius = size.width * 0.95;

    // 1. Double ambient glow layers behind horizon
    final glowPaint1 = Paint()
      ..color = const Color(0xFF256DFF).withOpacity(0.22)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 35.0);
    canvas.drawCircle(center, radius, glowPaint1);

    final glowPaint2 = Paint()
      ..color = const Color(0xFF27D8FF).withOpacity(0.12)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12.0);
    canvas.drawCircle(center, radius, glowPaint2);

    // 2. Horizon energy sweep (moves left to right)
    final double startAngle = -pi * 0.85;
    final double endAngle = -pi * 0.15;
    final double sweepAngle = startAngle + (endAngle - startAngle) * sweepValue;

    final sweepPaint = Paint()
      ..color = const Color(0xFF27D8FF).withOpacity(0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14.0);
    
    final Offset sweepPoint = Offset(
      center.dx + radius * cos(sweepAngle),
      center.dy + radius * sin(sweepAngle),
    );
    canvas.drawCircle(sweepPoint, 26.0, sweepPaint);

    // 3. Main glowing arc outline (planet horizon)
    final arcPaint = Paint()
      ..color = const Color(0xFF256DFF).withOpacity(0.65)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, arcPaint);

    // Specular highlight outline
    final arcHighlight = Paint()
      ..color = const Color(0xFF27D8FF).withOpacity(0.8)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius - 0.5, arcHighlight);

    // 4. Latitude concentric curves
    final gridPaint = Paint()
      ..color = const Color(0xFF256DFF).withOpacity(0.12 + (pulseValue * 0.05)) // Soft pulsing
      ..strokeWidth = 0.9
      ..style = PaintingStyle.stroke;

    for (double r = radius * 0.80; r < radius * 0.99; r += 14.0) {
      canvas.drawCircle(center, r, gridPaint);
    }

    // 5. Longitude lines
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
        Offset(center.dx + radius * 0.74 * cos(angle), center.dy + radius * 0.74 * sin(angle)),
        gridPaint,
      );
    }

    // 6. Network points
    final Random rand = Random(42);
    final List<Offset> points = [];
    final int pointCount = 30;

    for (int i = 0; i < pointCount; i++) {
      final double baseAngleFraction = rand.nextDouble();
      final double angleFraction = (baseAngleFraction + (rotationAngle / (2 * pi))) % 1.0;
      final double angle = startAngle + (endAngle - startAngle) * angleFraction;
      final double radFraction = 0.82 + rand.nextDouble() * 0.17;
      final double r = radius * radFraction;

      points.add(Offset(
        center.dx + r * cos(angle),
        center.dy + r * sin(angle),
      ));
    }

    // Draw connecting lines between close points
    final lineConnPaint = Paint()
      ..color = const Color(0xFF256DFF).withOpacity(0.18 + (pulseValue * 0.06))
      ..strokeWidth = 0.7;

    for (int i = 0; i < points.length; i++) {
      for (int j = i + 1; j < points.length; j++) {
        final double dist = (points[i] - points[j]).distance;
        if (dist < 60.0) {
          canvas.drawLine(points[i], points[j], lineConnPaint);
        }
      }
    }

    // Draw shining/blinking nodes
    for (int i = 0; i < points.length; i++) {
      final double blinkFactor = (sin(pulseValue * 2 * pi + i) + 1.0) / 2.0; // 0 to 1
      final double size = i % 5 == 0 ? 3.0 : 1.5;
      
      final Color color = i % 4 == 0 
          ? const Color(0xFFF97316) // Random orange point
          : (i % 2 == 0 ? const Color(0xFF27D8FF) : Colors.white); // Cyan and White

      final Paint dotPaint = Paint()..color = color.withOpacity(0.4 + (blinkFactor * 0.5));
      canvas.drawCircle(points[i], size, dotPaint);

      // Add a tiny halo glow around orange and cyan points
      if (i % 3 == 0) {
        final Paint haloPaint = Paint()
          ..color = color.withOpacity(0.15 * blinkFactor)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);
        canvas.drawCircle(points[i], size * 3.5, haloPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant MeshGlobePainter oldDelegate) {
    return oldDelegate.rotationAngle != rotationAngle ||
        oldDelegate.sweepValue != sweepValue ||
        oldDelegate.pulseValue != pulseValue;
  }
}

class StarsBackgroundPainter extends CustomPainter {
  final double animationValue;

  StarsBackgroundPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final rand = Random(2026);
    final rect = Offset.zero & size;

    // 1. Draw extremely subtle radial background glows (opacity under 8%)
    final Paint glowPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment.center,
        radius: 0.8,
        colors: [
          Color(0xFF256DFF), // Tinted Blue
          Colors.transparent,
        ],
      ).createShader(rect)
      ..color = const Color(0xFF256DFF).withOpacity(0.04);
    canvas.drawRect(rect, glowPaint);

    // 2. Draw tiny blue particles & very small stars with floating animation
    for (int i = 0; i < 60; i++) {
      // Base positions
      final double rx = rand.nextDouble() * size.width;
      final double ry = rand.nextDouble() * size.height;

      // Add float animation offset (parallax movement)
      final double speed = 5.0 + rand.nextDouble() * 15.0;
      final double direction = rand.nextBool() ? 1.0 : -1.0;
      
      // Calculate floating position
      final double x = (rx + (animationValue * speed * direction)) % size.width;
      final double y = (ry - (animationValue * speed * 2.0)) % size.height; // Float upwards

      final double radius = rand.nextDouble() * 0.95;
      final double baseOpacity = 0.10 + rand.nextDouble() * 0.45;
      
      // Star twinkle animation
      final double twinkle = (sin(animationValue * 2 * pi * (i % 3 + 1)) + 1.0) / 2.0;
      final double opacity = (baseOpacity * (0.3 + twinkle * 0.7)).clamp(0.05, 0.70);

      // Star Color (white, cyan, blue)
      final Color color = i % 4 == 0 
          ? const Color(0xFF27D8FF) // Blue/cyan particles
          : Colors.white;

      final Paint paint = Paint()..color = color.withOpacity(opacity * 0.08); // Ensure overall opacity is under 8%!
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant StarsBackgroundPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _globeController;
  late AnimationController _sweepController;
  late AnimationController _logoController;
  late AnimationController _breatheController;
  late AnimationController _backgroundController;

  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _subtitleFade;
  late Animation<double> _quoteFade;

  @override
  void initState() {
    super.initState();

    // 1. Globe rotation controller (infinite rotation)
    _globeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    )..repeat();

    // 2. Horizon energy sweep controller (moves left to right along horizon every 8s)
    _sweepController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    // 3. Staggered entrance controller (Total duration 1500ms)
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // - Logo scale 0.88 -> 1.0 (Duration 700ms => 0.0 to 0.46 in a 1500ms timeline)
    _logoScale = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.46, curve: Curves.easeOutCubic),
      ),
    );

    // - Logo opacity 0 -> 100% (Duration 700ms => 0.0 to 0.46 in a 1500ms timeline)
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.46, curve: Curves.easeOutCubic),
      ),
    );

    // - Subtitle fade (starts 250ms after logo, duration 450ms => 250/1500 = 0.16 to 700/1500 = 0.46)
    _subtitleFade = Tween<double>(begin: 0.0, end: 0.85).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.16, 0.46, curve: Curves.easeOutCubic),
      ),
    );

    // - Quote fade (appears 500ms after subtitle, i.e., at 750ms, duration 450ms => 750/1500 = 0.50 to 1200/1500 = 0.80)
    _quoteFade = Tween<double>(begin: 0.0, end: 0.80).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.50, 0.80, curve: Curves.easeOutCubic),
      ),
    );

    _logoController.forward().then((_) {
      // Glow breathing begins after entrance animation completes
      _breatheController.repeat(reverse: true);
    });

    // 4. Glow breathing controller (100% -> 115% -> 100%, 3.2s)
    _breatheController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );

    // 5. Background animated stars (6-10s duration)
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    // Transition to onboarding after 3.0 seconds
    Timer(const Duration(milliseconds: 3000), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const OnboardingScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 700),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _globeController.dispose();
    _sweepController.dispose();
    _logoController.dispose();
    _breatheController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Screen width of the device
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF02040A), // Almost black top
              Color(0xFF040814), // Deep navy blue background
            ],
          ),
        ),
        child: SafeArea(
          top: false, // Respect status bar but let background gradient cover full height
          bottom: true,
          child: Stack(
            children: [
              // 1. Moving Stars Background
              AnimatedBuilder(
                animation: _backgroundController,
                builder: (context, child) {
                  return Positioned.fill(
                    child: CustomPaint(
                      painter: StarsBackgroundPainter(animationValue: _backgroundController.value),
                    ),
                  );
                },
              ),

              // 2. Main Contents (Animated Logo, Title, Subtitle)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10.0),
                    
                    // Glossy custom shield logo (occupies ~32% of screen width)
                    ScaleTransition(
                      scale: _logoScale,
                      child: FadeTransition(
                        opacity: _logoFade,
                        child: AnimatedBuilder(
                          animation: _breatheController,
                          builder: (context, child) {
                            // Calculate breathing glow scale value (1.0 to 1.15)
                            final double breatheVal = _breatheController.isAnimating
                                ? 1.0 + (_breatheController.value * 0.15)
                                : 1.0;

                            return SizedBox(
                              width: screenWidth * 0.32,
                              height: (screenWidth * 0.32) * 1.16, // proportional height
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Shield base custom paint with breathing glow
                                  Positioned.fill(
                                    child: CustomPaint(
                                      painter: LogoShieldPainter(glowFactor: breatheVal),
                                    ),
                                  ),
                                  // Bold white 'A' letter centered inside the shield
                                  Positioned(
                                    top: (screenWidth * 0.32) * 0.22,
                                    child: Text(
                                      'A',
                                      style: TextStyle(
                                        fontSize: (screenWidth * 0.32) * 0.42,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontFamily: 'SF Pro Display',
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  // WiFi waves icon centered inside bottom of the shield
                                  Positioned(
                                    bottom: (screenWidth * 0.32) * 0.16,
                                    child: Icon(
                                      Icons.wifi,
                                      color: const Color(0xFF27D8FF), // Accent Cyan
                                      size: (screenWidth * 0.32) * 0.18,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 28.0), // Placed approx 28px below logo

                    // Center-aligned white bold title
                    const Text(
                      'AEGIS',
                      style: TextStyle(
                        fontSize: 38.0,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -1.0, // Tighter tracking
                        fontFamily: 'SF Pro Display',
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    // Subtitle fade staggered entry (starts 250ms after logo/title)
                    FadeTransition(
                      opacity: _subtitleFade,
                      child: const Text(
                        'The Autonomous\nHuman Communication\nNetwork',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          height: 1.5,
                          letterSpacing: 0.2,
                          fontFamily: 'SF Pro Display',
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),

              // 3. Network Globe Horizon at the bottom of the screen (Upper hemisphere)
              AnimatedBuilder(
                animation: Listenable.merge([_globeController, _sweepController]),
                builder: (context, child) {
                  return Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 240.0, // Height is taller to render hemisphere without clipping
                    child: CustomPaint(
                      painter: MeshGlobePainter(
                        rotationAngle: _globeController.value * 2 * pi,
                        sweepValue: _sweepController.value,
                        pulseValue: _sweepController.value, // Merge pulsing cycle with sweep
                      ),
                    ),
                  );
                },
              ),

              // 4. Bottom tagline quote centered (Appears 500ms after subtitle)
              Positioned(
                left: 24.0,
                right: 24.0,
                bottom: 28.0,
                child: FadeTransition(
                  opacity: _quoteFade,
                  child: const Text(
                    'When the Internet dies,\nhumanity still speaks.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                      height: 1.45,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'SF Pro Display',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
