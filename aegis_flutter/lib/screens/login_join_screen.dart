import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';
import 'splash_screen.dart'; // Reuse MeshGlobePainter and StarsBackgroundPainter
import 'main_shell.dart';

class LoginJoinScreen extends StatefulWidget {
  const LoginJoinScreen({super.key});

  @override
  State<LoginJoinScreen> createState() => _LoginJoinScreenState();
}

class _LoginJoinScreenState extends State<LoginJoinScreen> with TickerProviderStateMixin {
  late AnimationController _globeController;
  late AnimationController _buttonsController;
  late AnimationController _twinkleController;

  // Staggered buttons animations
  late Animation<double> _btn1Fade;
  late Animation<Offset> _btn1Slide;
  late Animation<double> _btn2Fade;
  late Animation<Offset> _btn2Slide;
  late Animation<double> _btn3Fade;
  late Animation<Offset> _btn3Slide;

  @override
  void initState() {
    super.initState();

    // 1. Globe rotation controller
    _globeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // 2. Buttons entrance staggered controller
    _buttonsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Staggered timing configurations
    _btn1Fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _buttonsController, curve: const Interval(0.0, 0.45, curve: Curves.easeIn)),
    );
    _btn1Slide = Tween<Offset>(begin: const Offset(0.0, 0.25), end: Offset.zero).animate(
      CurvedAnimation(parent: _buttonsController, curve: const Interval(0.0, 0.45, curve: Curves.easeOut)),
    );

    _btn2Fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _buttonsController, curve: const Interval(0.3, 0.75, curve: Curves.easeIn)),
    );
    _btn2Slide = Tween<Offset>(begin: const Offset(0.0, 0.25), end: Offset.zero).animate(
      CurvedAnimation(parent: _buttonsController, curve: const Interval(0.3, 0.75, curve: Curves.easeOut)),
    );

    _btn3Fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _buttonsController, curve: const Interval(0.6, 1.0, curve: Curves.easeIn)),
    );
    _btn3Slide = Tween<Offset>(begin: const Offset(0.0, 0.25), end: Offset.zero).animate(
      CurvedAnimation(parent: _buttonsController, curve: const Interval(0.6, 1.0, curve: Curves.easeOut)),
    );

    _buttonsController.forward();

    // 3. Twinkle controller for stars
    _twinkleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _globeController.dispose();
    _buttonsController.dispose();
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
            // Twinkling Stars background
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

            // Earth Globe mesh bottom rotating graphic layout
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

            // Main UI Option Buttons Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 32.0),
                  // Title details
                  const Text(
                    'Join the Network',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  const Text(
                    'Choose a way to continue',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: AegisColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 48.0),

                  // Option Button 1: Continue with Phone (Fade + Slide)
                  FadeTransition(
                    opacity: _btn1Fade,
                    child: SlideTransition(
                      position: _btn1Slide,
                      child: Container(
                        width: double.infinity,
                        height: 46.0,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AegisColors.busyPurple,
                              AegisColors.primaryBlue,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: AegisColors.primaryBlue.withOpacity(0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () => _navigateToMainShell(context),
                          borderRadius: BorderRadius.circular(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.phone_outlined,
                                color: Colors.white,
                                size: 18.0,
                              ),
                              SizedBox(width: 10.0),
                              Text(
                                'Continue with Phone',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // Option Button 2: Scan QR Code (Fade + Slide)
                  FadeTransition(
                    opacity: _btn2Fade,
                    child: SlideTransition(
                      position: _btn2Slide,
                      child: _buildOutlineIconButton(
                        context: context,
                        icon: Icons.qr_code_scanner_rounded,
                        label: 'Scan QR Code',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // Option Button 3: Join as Guest (Fade + Slide)
                  FadeTransition(
                    opacity: _btn3Fade,
                    child: SlideTransition(
                      position: _btn3Slide,
                      child: _buildOutlineIconButton(
                        context: context,
                        icon: Icons.person_outline_rounded,
                        label: 'Join as Guest',
                      ),
                    ),
                  ),
                  const SizedBox(height: 44.0),

                  // Offline notice indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wifi_off_rounded,
                        color: AegisColors.textSecondary.withOpacity(0.8),
                        size: 16.0,
                      ),
                      const SizedBox(width: 10.0),
                      Text(
                        'No Internet? No problem.\nAEGIS works offline.',
                        style: TextStyle(
                          color: AegisColors.textSecondary.withOpacity(0.8),
                          fontSize: 11.5,
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToMainShell(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const MainShell(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
      (route) => false,
    );
  }

  Widget _buildOutlineIconButton({
    required BuildContext context,
    required IconData icon,
    required String label,
  }) {
    return Container(
      width: double.infinity,
      height: 46.0,
      decoration: BoxDecoration(
        color: const Color(0xFF0C1017),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: const Color(0xFF1E293B), width: 1.0),
      ),
      child: InkWell(
        onTap: () => _navigateToMainShell(context),
        borderRadius: BorderRadius.circular(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 18.0,
            ),
            const SizedBox(width: 10.0),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
