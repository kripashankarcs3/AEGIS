import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';
import 'login_join_screen.dart';
import 'splash_screen.dart'; // Import LogoShieldPainter

class OnboardingRingPainter extends CustomPainter {
  final double angleOffset;

  OnboardingRingPainter({required this.angleOffset});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final double rx = size.width * 0.44;
    final double ry = size.width * 0.16;

    // Draw main glowing elliptical orbit path
    final ringPaint = Paint()
      ..color = const Color(0xFF2563EB).withOpacity(0.2)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    
    canvas.drawOval(
      Rect.fromCenter(center: center, width: rx * 2, height: ry * 2),
      ringPaint,
    );

    // Draw outer elliptical orbit for 3D depth
    final outerRingPaint = Paint()
      ..color = const Color(0xFF2563EB).withOpacity(0.08)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    
    canvas.drawOval(
      Rect.fromCenter(center: center, width: rx * 2.3, height: ry * 2.3),
      outerRingPaint,
    );

    // Dynamic constellation chord links connecting the floating node spheres
    final double angle1 = -pi * 0.85 + angleOffset;
    final double angle2 = -pi * 0.5 + angleOffset;
    final double angle3 = -pi * 0.15 + angleOffset;
    final double angle4 = pi * 0.15 + angleOffset;
    final double angle5 = pi * 0.75 + angleOffset;

    final p1 = Offset(center.dx + rx * cos(angle1), center.dy + ry * sin(angle1));
    final p2 = Offset(center.dx + rx * cos(angle2), center.dy + ry * sin(angle2));
    final p3 = Offset(center.dx + rx * cos(angle3), center.dy + ry * sin(angle3));
    final p4 = Offset(center.dx + rx * cos(angle4), center.dy + ry * sin(angle4));
    final p5 = Offset(center.dx + rx * cos(angle5), center.dy + ry * sin(angle5));

    final linePaint = Paint()
      ..color = const Color(0xFF3B82F6).withOpacity(0.18)
      ..strokeWidth = 0.8;

    canvas.drawLine(p1, p2, linePaint);
    canvas.drawLine(p2, p3, linePaint);
    canvas.drawLine(p3, p4, linePaint);
    canvas.drawLine(p4, p5, linePaint);
    canvas.drawLine(p5, p1, linePaint);
    canvas.drawLine(p1, p3, linePaint);
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

  // Staggered list animations for list container
  late Animation<double> _containerFade;
  late Animation<Offset> _containerSlide;

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

    _breatheGlow = Tween<double>(begin: 0.05, end: 0.35).animate(
      CurvedAnimation(parent: _breatheController, curve: Curves.easeInOut),
    );

    // 3. Staggered entrance controller
    _listController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _containerFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _listController, curve: const Interval(0.2, 0.8, curve: Curves.easeIn)),
    );
    _containerSlide = Tween<Offset>(begin: const Offset(0.0, 0.15), end: Offset.zero).animate(
      CurvedAnimation(parent: _listController, curve: const Interval(0.2, 0.8, curve: Curves.easeOut)),
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12.0),
              
              // 1. App Header Title and Subtitles
              const Text(
                'Welcome to',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4.0),
              // Gradient AEGIS Title
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Color(0xFF8B5CF6), // Purple
                    Color(0xFF2563EB), // Blue
                  ],
                ).createShader(bounds),
                child: const Text(
                  'AEGIS',
                  style: TextStyle(
                    fontSize: 34.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Stay connected. Stay informed. ',
                    style: TextStyle(
                      color: AegisColors.textSecondary,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Stay alive.',
                    style: TextStyle(
                      color: Color(0xFF8B5CF6),
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              // 2. Animated Node ring connection orbital graphic (ellipse 3D style)
              AnimatedBuilder(
                animation: _ringController,
                builder: (context, child) {
                  final double orbitalAngle = _ringController.value * 2 * pi;

                  return AspectRatio(
                    aspectRatio: 1.5,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final center = Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);
                        final double rx = constraints.maxWidth * 0.44;
                        final double ry = constraints.maxWidth * 0.16;

                        // Compute dynamic elliptical coordinates
                        final double baseAngle1 = -pi * 0.85 + orbitalAngle;
                        final double baseAngle2 = -pi * 0.5 + orbitalAngle;
                        final double baseAngle3 = -pi * 0.15 + orbitalAngle;
                        final double baseAngle4 = pi * 0.15 + orbitalAngle;
                        final double baseAngle5 = pi * 0.75 + orbitalAngle;

                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // Glowing Ellipse Painter
                            Positioned.fill(
                              child: CustomPaint(
                                painter: OnboardingRingPainter(angleOffset: orbitalAngle),
                              ),
                            ),
                            
                            // Central Breathing Shield Logo
                            Positioned(
                              left: center.dx - 22.0,
                              top: center.dy - 25.0,
                              child: ScaleTransition(
                                scale: _breatheScale,
                                child: AnimatedBuilder(
                                  animation: _breatheController,
                                  builder: (context, child) {
                                    return SizedBox(
                                      width: 44.0,
                                      height: 50.0,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Positioned.fill(
                                            child: CustomPaint(
                                              painter: LogoShieldPainter(),
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
                                              ),
                                            ),
                                          ),
                                          const Positioned(
                                            bottom: 8.0,
                                            child: Icon(
                                              Icons.wifi,
                                              color: Color(0xFF2563EB),
                                              size: 9.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),

                            // Floating node bubbles on elliptical orbit path
                            _buildRingBubble(center, rx, ry, baseAngle1, const Color(0xFF38BDF8), Icons.person_rounded),
                            _buildRingBubble(center, rx, ry, baseAngle2, const Color(0xFF38BDF8), Icons.chat_bubble_rounded),
                            _buildRingBubble(center, rx, ry, baseAngle3, const Color(0xFF38BDF8), Icons.vpn_key_rounded),
                            _buildRingBubble(center, rx, ry, baseAngle4, const Color(0xFF38BDF8), Icons.settings_input_antenna),
                            _buildRingBubble(center, rx, ry, baseAngle5, const Color(0xFF38BDF8), Icons.map_rounded),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 16.0),

              // 3. Features list grouped in a single premium card container
              FadeTransition(
                opacity: _containerFade,
                child: SlideTransition(
                  position: _containerSlide,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F131A),
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: AegisColors.border1, width: 1.0),
                    ),
                    child: Column(
                      children: [
                        _buildFeatureRow(
                          icon: Icons.share_rounded,
                          color: const Color(0xFF2563EB),
                          title: 'Mesh Communication',
                          description: 'Connect with nearby devices',
                        ),
                        _buildDivider(),
                        _buildFeatureRow(
                          icon: Icons.psychology_rounded,
                          color: const Color(0xFF8B5CF6),
                          title: 'AI Emergency Assistant',
                          description: 'Get smart help in critical moments',
                        ),
                        _buildDivider(),
                        _buildFeatureRow(
                          icon: Icons.medical_services_rounded,
                          color: const Color(0xFFEC4899),
                          title: 'Resources & Community',
                          description: 'Share, help and survive together',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28.0),

              // 4. Bottom action gradient button (Get Started)
              Container(
                width: double.infinity,
                height: 48.0,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF8B5CF6), // Purple
                      Color(0xFF2563EB), // Blue
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withOpacity(0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LoginJoinScreen(),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(8.0),
                    child: const Center(
                      child: Text(
                        'Get Started',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.5,
                          letterSpacing: 0.5,
                        ),
                      ),
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

  Widget _buildRingBubble(Offset center, double rx, double ry, double angle, Color color, IconData icon) {
    final double x = center.dx + rx * cos(angle);
    final double y = center.dy + ry * sin(angle);

    return Positioned(
      left: x - 13.0,
      top: y - 13.0,
      child: Container(
        width: 26.0,
        height: 26.0,
        decoration: BoxDecoration(
          color: const Color(0xFF0F131A),
          shape: BoxShape.circle,
          border: Border.all(color: color.withOpacity(0.85), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.35),
              blurRadius: 6,
              spreadRadius: 0.5,
            ),
          ],
        ),
        child: Center(
          child: Icon(
            icon,
            color: Colors.white,
            size: 11.5,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          // Circular icon container
          Container(
            width: 38.0,
            height: 38.0,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.25), width: 1.0),
            ),
            child: Center(
              child: Icon(
                icon,
                color: color,
                size: 18.0,
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
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 3.0),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 11.0,
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

  Widget _buildDivider() {
    return const Divider(
      color: Color(0xFF1E293B),
      height: 1.0,
      thickness: 0.5,
      indent: 68.0, // align with start of text
    );
  }
}
