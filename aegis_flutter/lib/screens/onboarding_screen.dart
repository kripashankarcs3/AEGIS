import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'login_join_screen.dart';
import 'splash_screen.dart'; // Import LogoShieldPainter and StarsBackgroundPainter

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _graphicFloatController;
  late AnimationController _glowPulseController;
  late AnimationController _networkPulseController;
  late AnimationController _iconRotateController;
  late AnimationController _backgroundController;

  // Staggered entrance animations
  late Animation<double> _line1Fade;
  late Animation<double> _line1Slide;
  late Animation<double> _line2Fade;
  late Animation<double> _line2Slide;
  late Animation<double> _subtitleFade;
  late Animation<double> _subtitleSlide;
  late Animation<double> _graphicFade;
  late Animation<double> _graphicSlide;
  late Animation<double> _cardFade;
  late Animation<double> _cardSlide;
  late Animation<double> _buttonFade;
  late Animation<double> _buttonSlide;

  // Network connection data pulse tracking
  int _activeConnectionIndex = 0;

  @override
  void initState() {
    super.initState();

    // 1. Entrance staggered animation timeline (1400ms)
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // Heading Line 1: Welcome to (0ms to 500ms => Interval(0.0, 0.35))
    _line1Fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.0, 0.35, curve: Curves.easeOutCubic)),
    );
    _line1Slide = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.0, 0.35, curve: Curves.easeOutCubic)),
    );

    // Heading Line 2: AEGIS (120ms to 620ms => 120/1400 = 0.08 to 620/1400 = 0.44)
    _line2Fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.08, 0.44, curve: Curves.easeOutCubic)),
    );
    _line2Slide = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.08, 0.44, curve: Curves.easeOutCubic)),
    );

    // Subtitle: Stay connected (320ms to 820ms => 320/1400 = 0.22 to 820/1400 = 0.58)
    _subtitleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.22, 0.58, curve: Curves.easeOutCubic)),
    );
    _subtitleSlide = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.22, 0.58, curve: Curves.easeOutCubic)),
    );

    // Center Graphic (350ms to 850ms => 350/1400 = 0.25 to 850/1400 = 0.61)
    _graphicFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.25, 0.61, curve: Curves.easeOutCubic)),
    );
    _graphicSlide = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.25, 0.61, curve: Curves.easeOutCubic)),
    );

    // Feature Card (500ms to 1000ms => 500/1400 = 0.35 to 1000/1400 = 0.71)
    _cardFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.35, 0.71, curve: Curves.easeOutCubic)),
    );
    _cardSlide = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.35, 0.71, curve: Curves.easeOutCubic)),
    );

    // Button (700ms to 1200ms => 700/1400 = 0.50 to 1200/1400 = 0.85)
    _buttonFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.50, 0.85, curve: Curves.easeOutCubic)),
    );
    _buttonSlide = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.50, 0.85, curve: Curves.easeOutCubic)),
    );

    _entranceController.forward();

    // 2. Graphic floating and animation controllers
    _graphicFloatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    )..repeat();

    _glowPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);

    _networkPulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    
    _networkPulseController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          setState(() {
            _activeConnectionIndex = (_activeConnectionIndex + 1) % 6;
          });
          _networkPulseController.forward(from: 0.0);
        }
      }
    });
    _networkPulseController.forward();

    // 3. Feature Icons slow rotation (6 seconds)
    _iconRotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    // 4. Background floating stars (8 seconds)
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _graphicFloatController.dispose();
    _glowPulseController.dispose();
    _networkPulseController.dispose();
    _iconRotateController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Rotation angle for feature icons
    final double featureRotateAngle = (_iconRotateController.value * 4 - 2) * pi / 180;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF02040A), // Almost black top
              Color(0xFF040814), // Deep navy blue
            ],
          ),
        ),
        child: SafeArea(
          top: false,
          bottom: true,
          child: Stack(
            children: [
              // 1. Moving Stars Background (extremely subtle 8% opacity)
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

              // 2. Scrollable Body containing layout
              SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                 padding: const EdgeInsets.only(top: 48.0, left: 28.0, right: 28.0, bottom: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // A. Header Text Block (Welcome to AEGIS)
                    Column(
                      children: [
                        FadeTransition(
                          opacity: _line1Fade,
                          child: AnimatedBuilder(
                            animation: _line1Slide,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(0, _line1Slide.value),
                                  child: const Text(
                                    'Welcome to',
                                    style: TextStyle(
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontFamily: 'SF Pro Display',
                                    ),
                                  ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        FadeTransition(
                          opacity: _line2Fade,
                          child: AnimatedBuilder(
                            animation: _line2Slide,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(0, _line2Slide.value),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Slight glow layer behind title
                                    ShaderMask(
                                      shaderCallback: (bounds) => const LinearGradient(
                                        colors: [
                                          Color(0xFF7B3EFF), // Purple
                                          Color(0xFF256DFF), // Blue
                                          Color(0xFF27D8FF), // Cyan
                                        ],
                                      ).createShader(bounds),
                                      child: Text(
                                        'AEGIS',
                                        style: TextStyle(
                                          fontSize: 42.0,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white.withOpacity(0.2),
                                          fontFamily: 'SF Pro Display',
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                    // Sharp front text
                                    ShaderMask(
                                      shaderCallback: (bounds) => const LinearGradient(
                                        colors: [
                                          Color(0xFF7B3EFF),
                                          Color(0xFF256DFF),
                                          Color(0xFF27D8FF),
                                        ],
                                      ).createShader(bounds),
                                      child: const Text(
                                        'AEGIS',
                                        style: TextStyle(
                                          fontSize: 42.0,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                          fontFamily: 'SF Pro Display',
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6.0),

                    // B. Subtitle Block
                    FadeTransition(
                      opacity: _subtitleFade,
                      child: AnimatedBuilder(
                        animation: _subtitleSlide,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _subtitleSlide.value),
                            child: Column(
                              children: const [
                                Text(
                                  'Stay connected.',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFA8B3C7),
                                    fontFamily: 'SF Pro Display',
                                    height: 1.3,
                                  ),
                                ),
                                SizedBox(height: 2.0),
                                Text(
                                  'Stay informed.',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFA8B3C7),
                                    fontFamily: 'SF Pro Display',
                                    height: 1.3,
                                  ),
                                ),
                                SizedBox(height: 2.0),
                                Text(
                                  'Stay alive.',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF7B3EFF), // Purple text
                                    fontFamily: 'SF Pro Display',
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    // C. HERO Center Orbital Graphic (occupies ~72% of width)
                    FadeTransition(
                      opacity: _graphicFade,
                      child: AnimatedBuilder(
                        animation: _graphicSlide,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _graphicSlide.value),
                            child: child,
                          );
                        },
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final double width = constraints.maxWidth * 0.55;
                            return SizedBox(
                              width: width,
                              height: width * 0.65,
                              child: FuturisticOrbitalGraphic(
                                width: width,
                                floatValue: _graphicFloatController.value,
                                glowScaleValue: _glowPulseController.value,
                                networkPulseValue: _networkPulseController.value,
                                activeConnectionIndex: _activeConnectionIndex,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),

                    // D. Premium Feature List Card
                    FadeTransition(
                      opacity: _cardFade,
                      child: AnimatedBuilder(
                        animation: _cardSlide,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _cardSlide.value),
                            child: child,
                          );
                        },
                        child: _buildFeatureCard(featureRotateAngle),
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    // E. Action Navigation Button
                    FuturisticButton(
                      text: 'Get Started',
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => const LoginJoinScreen(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
                              return FadeTransition(
                                opacity: curved,
                                child: ScaleTransition(
                                  scale: Tween<double>(begin: 0.97, end: 1.0).animate(curved),
                                  child: child,
                                ),
                              );
                            },
                            transitionDuration: const Duration(milliseconds: 550),
                          ),
                        );
                      },
                      entranceFade: _buttonFade,
                      entranceSlide: _buttonSlide,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(double rotationAngle) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF09111F),
        borderRadius: BorderRadius.circular(28.0),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF256DFF).withOpacity(0.12),
            blurRadius: 40.0,
            spreadRadius: -2.0,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildFeatureItem(
            icon: Icons.hub_rounded,
            title: 'Mesh Communication',
            subtitle: 'Connect nearby devices',
            rotationAngle: rotationAngle,
          ),
          _buildDivider(),
          _buildFeatureItem(
            icon: Icons.psychology_rounded,
            title: 'AI Emergency Assistant',
            subtitle: 'Smart help in critical moments',
            rotationAngle: rotationAngle,
          ),
          _buildDivider(),
          _buildFeatureItem(
            icon: Icons.groups_rounded,
            title: 'Resources & Community',
            subtitle: 'Share & help others survive',
            rotationAngle: rotationAngle,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required double rotationAngle,
  }) {
    return Row(
      children: [
        Transform.rotate(
          angle: rotationAngle,
            child: Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: const Color(0xFF09111F),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF7B3EFF).withOpacity(0.5), // Purple outline
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7B3EFF).withOpacity(0.2),
                  blurRadius: 10.0,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                icon,
                color: Colors.white,
                  size: 18.0,
              ),
            ),
          ),
        ),
            const SizedBox(width: 14.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontFamily: 'SF Pro Display',
                ),
              ),
              const SizedBox(height: 2.0),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFA8B3C7),
                  fontFamily: 'SF Pro Display',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      child: Divider(
        color: Colors.white.withOpacity(0.06), // Opacity 6%
        height: 1.0,
        thickness: 1.0,
        indent: 62.0, // align with text start
      ),
    );
  }
}

class FuturisticOrbitalGraphic extends StatefulWidget {
  final double width;
  final double floatValue;
  final double glowScaleValue;
  final double networkPulseValue;
  final int activeConnectionIndex;

  const FuturisticOrbitalGraphic({
    super.key,
    required this.width,
    required this.floatValue,
    required this.glowScaleValue,
    required this.networkPulseValue,
    required this.activeConnectionIndex,
  });

  @override
  State<FuturisticOrbitalGraphic> createState() => _FuturisticOrbitalGraphicState();
}

class _FuturisticOrbitalGraphicState extends State<FuturisticOrbitalGraphic> with SingleTickerProviderStateMixin {
  late AnimationController _shieldFloatController;

  // Symmetrical nodes setup
  final int totalNodes = 6;
  final List<IconData> nodeIcons = [
    Icons.chat_bubble_rounded, // Chat
    Icons.person_rounded,      // Person
    Icons.phone_rounded,       // Phone
    Icons.lock_rounded,        // Security
    Icons.volunteer_activism_rounded, // Resources
    Icons.sensors_rounded,     // Signal
  ];

  // Random float speeds & phase offsets to keep floating movements independent
  final List<double> floatSpeeds = [0.85, 1.15, 0.95, 1.25, 0.75, 1.05];
  final List<double> floatPhases = [0.0, 1.3, 2.6, 3.9, 4.8, 5.7];

  @override
  void initState() {
    super.initState();
    // Shield float controller (4 seconds infinite)
    _shieldFloatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _shieldFloatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double centerDx = widget.width / 2;
    final double centerDy = widget.width * 0.36;
    final double rx = widget.width * 0.44;
    final double ry = widget.width * 0.20;

    // Calculate node base angles around the orbital path
    final List<double> angles = List.generate(totalNodes, (index) => index * pi / 3);

    // Compute coordinates of the floating nodes
    final List<Offset> nodePositions = [];
    for (int i = 0; i < totalNodes; i++) {
      final double angle = angles[i];
      final double bx = centerDx + rx * cos(angle);
      final double by = centerDy + ry * sin(angle);

      // Independent vertical/horizontal float logic based on speed & phase parameters
      final double floatAngle = widget.floatValue * 2 * pi * floatSpeeds[i] + floatPhases[i];
      final double dx = sin(floatAngle) * 3.0;
      final double dy = cos(floatAngle) * 6.0; // vertical amplitude 6px

      nodePositions.add(Offset(bx + dx, by + dy));
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Concentric elliptical rings and network curves background painter
        Positioned.fill(
          child: CustomPaint(
            painter: OrbitalBackdropPainter(
              nodePositions: nodePositions,
              pulseValue: widget.networkPulseValue,
              activeConnectionIndex: widget.activeConnectionIndex,
            ),
          ),
        ),

        // Centered Shield Logo with custom Hero transition
        Positioned(
          left: centerDx - 22.0,
          top: centerDy - 25.0,
          child: AnimatedBuilder(
            animation: _shieldFloatController,
            builder: (context, child) {
              // Floating -5px to +5px
              final double dy = sin(_shieldFloatController.value * 2 * pi) * 5.0;
              // Very subtle rotation (-1 degree to +1 degree => -0.017 to +0.017 rad)
              final double rotation = sin(_shieldFloatController.value * 2 * pi) * (1.0 * pi / 180.0);

              return Transform.translate(
                offset: Offset(0, dy),
                child: Transform.rotate(
                  angle: rotation,
                  child: Hero(
                    tag: 'aegis_logo',
                    child: SizedBox(
                      width: 44.0,
                      height: 50.0,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned.fill(
                            child: CustomPaint(
                              painter: LogoShieldPainter(glowFactor: 1.0),
                            ),
                          ),
                          const Positioned(
                            top: 8.0,
                            child: Text(
                              'A',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'SF Pro Display',
                              ),
                            ),
                          ),
                          const Positioned(
                            bottom: 8.0,
                            child: Icon(
                              Icons.wifi,
                              color: Color(0xFF27D8FF),
                              size: 9.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Symmetrical floating glass card node bubbles
        ...List.generate(totalNodes, (index) {
          final Offset pos = nodePositions[index];
          final IconData icon = nodeIcons[index];

          return Positioned(
            left: pos.dx - 26.0,
            top: pos.dy - 26.0,
            child: Container(
              width: 52.0,
              height: 52.0,
              decoration: BoxDecoration(
                color: const Color(0xFF09111F).withOpacity(0.85), // Glass card container
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF256DFF).withOpacity(0.4),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF256DFF).withOpacity(0.20 * widget.glowScaleValue),
                    blurRadius: 14.0 * widget.glowScaleValue,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 26.0,
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class OrbitalBackdropPainter extends CustomPainter {
  final List<Offset> nodePositions;
  final double pulseValue;
  final int activeConnectionIndex;

  OrbitalBackdropPainter({
    required this.nodePositions,
    required this.pulseValue,
    required this.activeConnectionIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final double rx = size.width * 0.44;
    final double ry = size.width * 0.20;

    // 1. Draw 3 concentric elliptical rings (gradient blue -> transparent, 12% opacity)
    for (double f in [1.0, 0.82, 0.64]) {
      final rect = Rect.fromCenter(
        center: center,
        width: rx * 2 * f,
        height: ry * 2 * f,
      );
      final ringPaint = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF256DFF),
            Colors.transparent,
          ],
        ).createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = const Color(0xFF256DFF).withOpacity(0.12);
      
      canvas.drawOval(rect, ringPaint);
    }

    // 2. Draw curved network connection lines
    if (nodePositions.length < 6) return;

    final linePaint = Paint()
      ..color = const Color(0xFF256DFF).withOpacity(0.35)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final List<Path> connectionPaths = [];

    for (int i = 0; i < 6; i++) {
      final p1 = nodePositions[i];
      final p2 = nodePositions[(i + 1) % 6];

      final Offset mid = (p1 + p2) / 2;
      // Bend curve slightly towards center
      final Offset control = mid + (center - mid) * 0.20;

      final path = Path();
      path.moveTo(p1.dx, p1.dy);
      path.quadraticBezierTo(control.dx, control.dy, p2.dx, p2.dy);
      
      canvas.drawPath(path, linePaint);
      connectionPaths.add(path);
    }

    // Draw active traveling light pulse (4px cyan dot)
    if (activeConnectionIndex < connectionPaths.length) {
      final Path activePath = connectionPaths[activeConnectionIndex];
      final List<PathMetric> metrics = activePath.computeMetrics().toList();
      if (metrics.isNotEmpty) {
        final PathMetric metric = metrics.first;
        final double length = metric.length;
        final Tangent? tangent = metric.getTangentForOffset(length * pulseValue);
        if (tangent != null) {
          final pulsePaint = Paint()
            ..color = const Color(0xFF27D8FF)
            ..style = PaintingStyle.fill;
          
          final glowPaint = Paint()
            ..color = const Color(0xFF27D8FF).withOpacity(0.6)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5.0);
          
          canvas.drawCircle(tangent.position, 6.0, glowPaint);
          canvas.drawCircle(tangent.position, 4.0, pulsePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant OrbitalBackdropPainter oldDelegate) {
    return oldDelegate.pulseValue != pulseValue ||
        oldDelegate.activeConnectionIndex != activeConnectionIndex ||
        oldDelegate.nodePositions != nodePositions;
  }
}

class FuturisticButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final Animation<double> entranceFade;
  final Animation<double> entranceSlide;

  const FuturisticButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.entranceFade,
    required this.entranceSlide,
  });

  @override
  State<FuturisticButton> createState() => _FuturisticButtonState();
}

class _FuturisticButtonState extends State<FuturisticButton> with TickerProviderStateMixin {
  late AnimationController _pressController;
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.97,
      upperBound: 1.0,
      value: 1.0,
    );

    // Glow starts after 500ms, pulses 100% -> 112% -> 100% every 3s
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _glowController.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _pressController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: widget.entranceFade,
      child: AnimatedBuilder(
        animation: widget.entranceSlide,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, widget.entranceSlide.value),
            child: child,
          );
        },
        child: GestureDetector(
          onTapDown: (_) => _pressController.animateTo(0.97, curve: Curves.easeIn),
          onTapUp: (_) {
            _pressController.animateTo(1.0, curve: Curves.easeOut);
            widget.onTap();
          },
          onTapCancel: () => _pressController.animateTo(1.0),
          child: AnimatedBuilder(
            animation: Listenable.merge([_pressController, _glowController]),
            builder: (context, child) {
              final double scale = _pressController.value;
              final double glowScale = 1.0 + (_glowController.value * 0.12);

              return Transform.scale(
                scale: scale,
                child: Container(
                  width: double.infinity,
                  height: 52.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18.0),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF7B3EFF), // Purple
                        Color(0xFF256DFF), // Blue
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF256DFF).withOpacity(0.25 * glowScale),
                                        blurRadius: 30.0 * glowScale,
                        spreadRadius: 1.0,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Glossy highlight at top edge
                      Positioned(
                        top: 1,
                        left: 12,
                        right: 12,
                        child: Container(
                          height: 1.0,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.0),
                                Colors.white.withOpacity(0.35),
                                Colors.white.withOpacity(0.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          widget.text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            fontFamily: 'SF Pro Display',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
