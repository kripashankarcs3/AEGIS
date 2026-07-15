import 'package:flutter/material.dart';
import 'dart:math';
import '../constants/aegis_colors.dart';
import 'login_join_screen.dart';

class OnboardingRingPainter extends CustomPainter {
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

    // Connecting chords between outer nodes
    final double angle1 = -pi * 0.85;
    final double angle2 = -pi * 0.5;
    final double angle3 = -pi * 0.15;
    final double angle4 = -pi * 0.02;
    final double angle5 = -pi * 0.98;

    final p1 = Offset(center.dx + radius * cos(angle1), center.dy + radius * sin(angle1));
    final p2 = Offset(center.dx + radius * cos(angle2), center.dy + radius * sin(angle2));
    final p3 = Offset(center.dx + radius * cos(angle3), center.dy + radius * sin(angle3));
    final p4 = Offset(center.dx + radius * cos(angle4), center.dy + radius * sin(angle4));
    final p5 = Offset(center.dx + radius * cos(angle5), center.dy + radius * sin(angle5));

    final chordPaint = Paint()
      ..color = AegisColors.primaryBlue.withOpacity(0.15)
      ..strokeWidth = 0.8;

    canvas.drawLine(p1, p2, chordPaint);
    canvas.drawLine(p2, p3, chordPaint);
    canvas.drawLine(p3, p4, chordPaint);
    canvas.drawLine(p1, p5, chordPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

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
  
                // 2. Node ring connection graphic
                AspectRatio(
                  aspectRatio: 1.6,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final center = Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);
                      final double radius = constraints.maxWidth * 0.36;
  
                      // Compute node locations
                      final double angleLeftTop = -pi * 0.85;
                      final double angleCenterTop = -pi * 0.5;
                      final double angleRightTop = -pi * 0.15;
                      final double angleRightBottom = -pi * 0.02;
                      final double angleLeftBottom = -pi * 0.98;
  
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Ring painters
                          Positioned.fill(
                            child: CustomPaint(
                              painter: OnboardingRingPainter(),
                            ),
                          ),
                          // Center logo badge shield
                          Positioned(
                            left: center.dx - 22.0,
                            top: center.dy - 22.0,
                            child: Container(
                              width: 44.0,
                              height: 44.0,
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F172A),
                                shape: BoxShape.circle,
                                border: Border.all(color: AegisColors.primaryBlue.withOpacity(0.4), width: 1.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: AegisColors.primaryBlue.withOpacity(0.2),
                                    blurRadius: 10,
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
                            ),
                          ),
  
                          // Node Bubbles surrounding the circle ring
                          _buildRingBubble(center, radius, angleLeftTop, Icons.person_rounded, AegisColors.busyPurple),
                          _buildRingBubble(center, radius, angleCenterTop, Icons.medical_services_rounded, AegisColors.primaryBlue),
                          _buildRingBubble(center, radius, angleRightTop, Icons.roofing_rounded, AegisColors.activeGreen),
                          _buildRingBubble(center, radius, angleRightBottom, Icons.restaurant_rounded, AegisColors.warningOrange),
                          _buildRingBubble(center, radius, angleLeftBottom, Icons.wifi_tethering_rounded, AegisColors.sosRed),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 28.0),
  
                // 3. Features list layout
                Column(
                  children: [
                    _buildFeatureRow(
                      icon: Icons.share_rounded,
                      color: AegisColors.primaryBlue,
                      title: 'Mesh Communication',
                      description: 'Connect with nearby devices',
                    ),
                    const SizedBox(height: 16.0),
                    _buildFeatureRow(
                      icon: Icons.psychology_rounded,
                      color: AegisColors.sosRed,
                      title: 'AI Emergency Assistant',
                      description: 'Get smart help in critical moments',
                    ),
                    const SizedBox(height: 16.0),
                    _buildFeatureRow(
                      icon: Icons.medical_services_rounded,
                      color: AegisColors.busyPurple,
                      title: 'Resources & Community',
                      description: 'Share, help and survive together',
                    ),
                  ],
                ),

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
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginJoinScreen(),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(6.0),
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
    ));
  }

  Widget _buildRingBubble(Offset center, double radius, double angle, IconData icon, Color color) {
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
            Icons.person_rounded, // Generic avatar to match mockup nodes shape
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
