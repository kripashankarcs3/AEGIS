import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';
import 'login_join_screen.dart';

class OnboardingRingPainter extends CustomPainter {
  final double angleOffset;

  OnboardingRingPainter({required this.angleOffset});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final double radius = size.width * 0.36;

    // Draw main ring
    final ringPaint = Paint()
      ..color = AegisColors.primaryBlue.withOpacity(0.18)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, ringPaint);

    // Draw secondary rings
    final outerRingPaint = Paint()
      ..color = AegisColors.primaryBlue.withOpacity(0.08)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius * 1.25, outerRingPaint);

    // Connecting chords between revolving outer nodes
    final double baseAngle1 = -pi * 0.85;
    final double baseAngle2 = -pi * 0.5;
    final double baseAngle3 = -pi * 0.15;
    final double baseAngle4 = -pi * 0.02;
    final double baseAngle5 = -pi * 0.98;

    final p1 = Offset(center.dx + radius * cos(baseAngle1 + angleOffset), center.dy + radius * sin(baseAngle1 + angleOffset));
    final p2 = Offset(center.dx + radius * cos(baseAngle2 + angleOffset), center.dy + radius * sin(baseAngle2 + angleOffset));
    final p3 = Offset(center.dx + radius * cos(baseAngle3 + angleOffset), center.dy + radius * sin(baseAngle3 + angleOffset));
    final p4 = Offset(center.dx + radius * cos(baseAngle4 + angleOffset), center.dy + radius * sin(baseAngle4 + angleOffset));
    final p5 = Offset(center.dx + radius * cos(baseAngle5 + angleOffset), center.dy + radius * sin(baseAngle5 + angleOffset));

    final chordPaint = Paint()
      ..color = AegisColors.primaryBlue.withOpacity(0.15)
      ..strokeWidth = 0.8;

    canvas.drawLine(p1, p2, chordPaint);
    canvas.drawLine(p2, p3, chordPaint);
    canvas.drawLine(p3, p4, chordPaint);
    canvas.drawLine(p1, p5, chordPaint);
  }

  @override
  bool shouldRepaint(covariant OnboardingRingPainter oldDelegate) {
    return oldDelegate.angleOffset != angleOffset;
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with TickerProviderStateMixin {
  late AnimationController _ringController;
  late AnimationController _breatheController;
  late AnimationController _listController;

  late Animation<double> _breatheScale;
  late Animation<double> _breatheGlow;

  // Staggered list animations
  late Animation<double> _feature1Fade;
  late Animation<Offset> _feature1Slide;
  late Animation<double> _feature2Fade;
  late Animation<Offset> _feature2Slide;
  late Animation<double> _feature3Fade;
  late Animation<Offset> _feature3Slide;

  @override
  void initState() {
    super.initState();

    // 1. Orbital revolving ring controller
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    )..repeat();

    // 2. Logo breathing controller
    _breatheController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _breatheScale = Tween<double>(begin: 0.94, end: 1.06).animate(
      CurvedAnimation(parent: _breatheController, curve: Curves.easeInOut),
    );

    _breatheGlow = Tween<double>(begin: 0.08, end: 0.22).animate(
      CurvedAnimation(parent: _breatheController, curve: Curves.easeInOut),
    );

    // 3. Staggered list entrance controller
    _listController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // Feature 1 staggered interval
    _feature1Fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _listController, curve: const Interval(0.0, 0.4, curve: Curves.easeIn)),
    );
    _feature1Slide = Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero).animate(
      CurvedAnimation(parent: _listController, curve: const Interval(0.0, 0.4, curve: Curves.easeOut)),
    );

    // Feature 2 staggered interval
    _feature2Fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _listController, curve: const Interval(0.3, 0.7, curve: Curves.easeIn)),
    );
    _feature2Slide = Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero).animate(
      CurvedAnimation(parent: _listController, curve: const Interval(0.3, 0.7, curve: Curves.easeOut)),
    );

    // Feature 3 staggered interval
    _feature3Fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _listController, curve: const Interval(0.6, 1.0, curve: Curves.easeIn)),
    );
    _feature3Slide = Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero).animate(
      CurvedAnimation(parent: _listController, curve: const Interval(0.6, 1.0, curve: Curves.easeOut)),
    );

    _listController.forward();
  }

  @override
  void dispose() {
    _ringController.dispose();
    _breatheController.dispose();
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AegisColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 12.0),
                // 1. Welcome to AEGIS Header
                const Text(
                  'Welcome to',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4.0),
                const Text(
                  'AEGIS',
                  style: TextStyle(
                    fontSize: 26.0,
                    fontWeight: FontWeight.w900,
                    color: AegisColors.busyPurple,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Stay connected. Stay informed. ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Stay alive.',
                      style: TextStyle(
                        color: AegisColors.sosRed,
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),

                // 2. Animated Node ring connection orbital graphic
                AnimatedBuilder(
                  animation: _ringController,
                  builder: (context, child) {
                    final double orbitalAngle = _ringController.value * 2 * pi;

                    return AspectRatio(
                      aspectRatio: 1.6,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final center = Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);
                          final double radius = constraints.maxWidth * 0.36;

                          // Compute dynamically moving node locations
                          final double baseAngleLeftTop = -pi * 0.85;
                          final double baseAngleCenterTop = -pi * 0.5;
                          final double baseAngleRightTop = -pi * 0.15;
                          final double baseAngleRightBottom = -pi * 0.02;
                          final double baseAngleLeftBottom = -pi * 0.98;

                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              // Ring connecting lines
                              Positioned.fill(
                                child: CustomPaint(
                                  painter: OnboardingRingPainter(angleOffset: orbitalAngle),
                                ),
                              ),
                              
                              // Breathing center logo badge shield
                              Positioned(
                                left: center.dx - 22.0,
                                top: center.dy - 22.0,
                                child: ScaleTransition(
                                  scale: _breatheScale,
                                  child: AnimatedBuilder(
                                    animation: _breatheController,
                                    builder: (context, child) {
                                      return Container(
                                        width: 44.0,
                                        height: 44.0,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF0F172A),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AegisColors.primaryBlue.withOpacity(0.4),
                                            width: 1.5,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AegisColors.primaryBlue.withOpacity(_breatheGlow.value),
                                              blurRadius: 12,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.shield_outlined,
                                            color: AegisColors.primaryBlue,
                                            size: 24.0,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),

                              // Outer node orbits
                              _buildRingBubble(center, radius, baseAngleLeftTop + orbitalAngle, AegisColors.busyPurple),
                              _buildRingBubble(center, radius, baseAngleCenterTop + orbitalAngle, AegisColors.primaryBlue),
                              _buildRingBubble(center, radius, baseAngleRightTop + orbitalAngle, AegisColors.activeGreen),
                              _buildRingBubble(center, radius, baseAngleRightBottom + orbitalAngle, AegisColors.warningOrange),
                              _buildRingBubble(center, radius, baseAngleLeftBottom + orbitalAngle, AegisColors.sosRed),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 28.0),

                // 3. Staggered slide in features list
                Column(
                  children: [
                    FadeTransition(
                      opacity: _feature1Fade,
                      child: SlideTransition(
                        position: _feature1Slide,
                        child: _buildFeatureRow(
                          icon: Icons.share_rounded,
                          color: AegisColors.primaryBlue,
                          title: 'Mesh Communication',
                          description: 'Connect with nearby devices',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    FadeTransition(
                      opacity: _feature2Fade,
                      child: SlideTransition(
                        position: _feature2Slide,
                        child: _buildFeatureRow(
                          icon: Icons.psychology_rounded,
                          color: AegisColors.sosRed,
                          title: 'AI Emergency Assistant',
                          description: 'Get smart help in critical moments',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    FadeTransition(
                      opacity: _feature3Fade,
                      child: SlideTransition(
                        position: _feature3Slide,
                        child: _buildFeatureRow(
                          icon: Icons.medical_services_rounded,
                          color: AegisColors.busyPurple,
                          title: 'Resources & Community',
                          description: 'Share, help and survive together',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32.0),

                // 4. Bottom action gradient button (Get Started)
                Container(
                  width: double.infinity,
                  height: 46.0,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AegisColors.busyPurple,
                        AegisColors.primaryBlue,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(6.0),
                    boxShadow: [
                      BoxShadow(
                        color: AegisColors.primaryBlue.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => const LoginJoinScreen(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.easeInOut;
                            final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                            return SlideTransition(position: animation.drive(tween), child: child);
                          },
                          transitionDuration: const Duration(milliseconds: 500),
                        ),
                      );
                    },
                    child: const Center(
                      child: Text(
                        'Get Started',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRingBubble(Offset center, double radius, double angle, Color color) {
    final x = center.dx + radius * cos(angle);
    final y = center.dy + radius * sin(angle);
    const size = 26.0;

    return Positioned(
      left: x - size / 2,
      top: y - size / 2,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 8,
            ),
          ],
        ),
        child: const Center(
          child: Icon(
            Icons.person_rounded,
            color: Colors.white,
            size: 14.0,
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: AegisColors.cardBackground,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: AegisColors.border, width: 1.0),
      ),
      child: Row(
        children: [
          Container(
            width: 32.0,
            height: 32.0,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 16.0,
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
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: AegisColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
