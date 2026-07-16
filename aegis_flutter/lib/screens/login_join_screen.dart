import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';
import 'splash_screen.dart'; // Reuse MeshGlobePainter and StarsBackgroundPainter
import 'main_shell.dart';
import 'qr_scanner_screen.dart';

class LoginJoinScreen extends StatefulWidget {
  const LoginJoinScreen({super.key});

  @override
  State<LoginJoinScreen> createState() => _LoginJoinScreenState();
}

class _LoginJoinScreenState extends State<LoginJoinScreen> with TickerProviderStateMixin {
  late AnimationController _globeController;
  late AnimationController _sweepController;
  late AnimationController _entranceController;
  late AnimationController _glowBreatheController;
  late AnimationController _backgroundController;

  // Staggered entrance animations
  late Animation<double> _titleFade;
  late Animation<double> _titleSlide;
  late Animation<double> _subtitleFade;
  late Animation<double> _subtitleSlide;
  
  late Animation<double> _phoneFade;
  late Animation<double> _phoneScale;
  late Animation<double> _qrFade;
  late Animation<double> _qrScale;
  late Animation<double> _guestFade;
  late Animation<double> _guestScale;
  
  late Animation<double> _offlineFade;
  late Animation<double> _offlineSlide;

  @override
  void initState() {
    super.initState();

    // 1. Globe rotation (infinite rotation)
    _globeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    )..repeat();

    // 2. Horizon energy sweep (8 seconds cycle)
    _sweepController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    // 3. Staggered entrance timeline (1200ms)
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Title (0ms to 500ms => Interval(0.0, 0.42))
    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.0, 0.42, curve: Curves.easeOutCubic)),
    );
    _titleSlide = Tween<double>(begin: 18.0, end: 0.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.0, 0.42, curve: Curves.easeOutCubic)),
    );

    // Subtitle (120ms to 620ms => 120/1200 = 0.10 to 620/1200 = 0.52)
    _subtitleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.10, 0.52, curve: Curves.easeOutCubic)),
    );
    _subtitleSlide = Tween<double>(begin: 18.0, end: 0.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.10, 0.52, curve: Curves.easeOutCubic)),
    );

    // Phone Button (250ms to 700ms => 250/1200 = 0.21 to 700/1200 = 0.58)
    _phoneFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.21, 0.58, curve: Curves.easeOutCubic)),
    );
    _phoneScale = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.21, 0.58, curve: Curves.easeOutCubic)),
    );

    // QR Button (370ms to 820ms => 370/1200 = 0.31 to 820/1200 = 0.68)
    _qrFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.31, 0.68, curve: Curves.easeOutCubic)),
    );
    _qrScale = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.31, 0.68, curve: Curves.easeOutCubic)),
    );

    // Guest Button (490ms to 940ms => 490/1200 = 0.41 to 940/1200 = 0.78)
    _guestFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.41, 0.78, curve: Curves.easeOutCubic)),
    );
    _guestScale = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.41, 0.78, curve: Curves.easeOutCubic)),
    );

    // Offline Section (600ms to 1050ms => 600/1200 = 0.50 to 1050/1200 = 0.88)
    _offlineFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.50, 0.88, curve: Curves.easeOutCubic)),
    );
    _offlineSlide = Tween<double>(begin: 18.0, end: 0.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.50, 0.88, curve: Curves.easeOutCubic)),
    );

    _entranceController.forward();

    // 4. Primary Button glow breathe (pulsing 100% -> 112% -> 100% every 3s)
    _glowBreatheController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    
    // Start breathing after 500ms
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _glowBreatheController.repeat(reverse: true);
      }
    });

    // 5. Background stars animation (8s duration)
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _globeController.dispose();
    _sweepController.dispose();
    _entranceController.dispose();
    _glowBreatheController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
colors: [
              AegisColors.background,
              AegisColors.surface0,
            ],
          ),
        ),
        child: SafeArea(
          top: false,
          bottom: true,
          child: Stack(
            children: [
              // 1. Moving Stars Background (subtle 8% opacity)
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

              // 2. Upper Hemisphere Earth Globe horizon at the bottom (Opacity 85%)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 240.0,
                child: Opacity(
                  opacity: 0.85,
                  child: AnimatedBuilder(
                    animation: Listenable.merge([_globeController, _sweepController]),
                    builder: (context, child) {
                      return CustomPaint(
                        painter: MeshGlobePainter(
                          rotationAngle: _globeController.value * 2 * pi,
                          sweepValue: _sweepController.value,
                          pulseValue: _sweepController.value,
                        ),
                      );
                    },
                  ),
                ),
              ),

              // 3. Scrollable Main Layout
              SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.only(top: 60.0, left: 28.0, right: 28.0, bottom: 34.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // A. Header Text Block (around 100px from top)
                    SizedBox(height: 40.0),
                    FadeTransition(
                      opacity: _titleFade,
                      child: AnimatedBuilder(
                        animation: _titleSlide,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _titleSlide.value),
                            child: Text(
                              'Join the Network',
                              style: TextStyle(
                                fontSize: 40.0,
                                fontWeight: FontWeight.bold,
                                color: AegisColors.textPrimary,
                                fontFamily: 'SF Pro Display',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 14.0), // Spacing 14px below title
                    FadeTransition(
                      opacity: _subtitleFade,
                      child: AnimatedBuilder(
                        animation: _subtitleSlide,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _subtitleSlide.value),
                            child: Text(
                              'Choose a way to continue',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: AegisColors.textSecondary,
                                fontFamily: 'SF Pro Display',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 52.0),

                    // B. Reusable Buttons Block
                    // Primary Hero Button (Continue with Phone)
                    FadeTransition(
                      opacity: _phoneFade,
                      child: AnimatedBuilder(
                        animation: _phoneScale,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _phoneScale.value,
                            child: child,
                          );
                        },
                        child: FuturisticGradientButton(
                          label: 'Continue with Phone',
                          icon: Icons.phone_outlined,
                          glowBreathe: _glowBreatheController,
                          onTap: () => _navigateToMainShell(context),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.0), // Spacing 24px between Phone & QR buttons

                    // Secondary Glass Button (Scan QR Code)
                    FadeTransition(
                      opacity: _qrFade,
                      child: AnimatedBuilder(
                        animation: _qrScale,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _qrScale.value,
                            child: child,
                          );
                        },
                        child: FuturisticGlassButton(
                          label: 'Scan QR Code',
                          icon: Icons.qr_code_scanner_rounded,
                          hasGlow: true,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const QrScannerScreen()),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0), // Spacing 20px between QR & Guest buttons

                    // Tertiary Glass Button (Join as Guest)
                    FadeTransition(
                      opacity: _guestFade,
                      child: AnimatedBuilder(
                        animation: _guestScale,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _guestScale.value,
                            child: child,
                          );
                        },
                        child: FuturisticGlassButton(
                          label: 'Join as Guest',
                          icon: Icons.person_outline_rounded,
                          hasGlow: false,
                          onTap: () => _navigateToMainShell(context),
                        ),
                      ),
                    ),
                    SizedBox(height: 48.0),

                    // C. Offline Warning Notice (placed near lower third)
                    FadeTransition(
                      opacity: _offlineFade,
                      child: AnimatedBuilder(
                        animation: _offlineSlide,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _offlineSlide.value),
                            child: Column(
                              children: [
                                Opacity(
                                  opacity: 0.70,
                                  child: Icon(
                                    Icons.portable_wifi_off_rounded,
                                    color: AegisColors.textSecondary,
                                    size: 26.0,
                                  ),
                                ),
                                SizedBox(height: 12.0),
                                Opacity(
                                  opacity: 0.78,
                                  child: Text(
                                    'No Internet? No problem.\nAEGIS works offline.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AegisColors.textSecondary,
                                      fontSize: 14.5,
                                      height: 1.45,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'SF Pro Display',
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
              ),
            ],
          ),
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
}

class FuturisticGradientButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Animation<double> glowBreathe;
  final VoidCallback onTap;

  const FuturisticGradientButton({
    super.key,
    required this.label,
    required this.icon,
    required this.glowBreathe,
    required this.onTap,
  });

  @override
  State<FuturisticGradientButton> createState() => _FuturisticGradientButtonState();
}

class _FuturisticGradientButtonState extends State<FuturisticGradientButton> with SingleTickerProviderStateMixin {
  late AnimationController _pressController;

  @override
  void initState() {
    super.initState();
    // Press scale animation (140ms duration)
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
      lowerBound: 0.97,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _pressController.animateTo(0.97, curve: Curves.easeIn),
      onTapUp: (_) {
        _pressController.animateTo(1.0, curve: Curves.easeOut);
        widget.onTap();
      },
      onTapCancel: () => _pressController.animateTo(1.0),
      child: AnimatedBuilder(
        animation: Listenable.merge([_pressController, widget.glowBreathe]),
        builder: (context, child) {
          final double scale = _pressController.value;
          final double breatheScale = 1.0 + (widget.glowBreathe.value * 0.12); // breathe 100% -> 112% -> 100%

          return Transform.scale(
            scale: scale,
            child: Container(
              width: double.infinity,
              height: 60.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.0),
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF7B3EFF), // Left Purple
                    Color(0xFF256DFF), // Right Blue
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF256DFF).withOpacity(0.24 * breatheScale),
                    blurRadius: 55.0 * breatheScale,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Very subtle top edge glossy highlight
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
                  // Outlined white 22px phone icon at left padding 22px
                  Positioned(
                    left: 22.0,
                    child: Icon(
                      widget.icon,
                      color: Colors.white,
                      size: 22.0,
                    ),
                  ),
                  // Centered label with tracking 0.2
                  Center(
                    child: Text(
                      widget.label,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
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
    );
  }
}

class FuturisticGlassButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool hasGlow;

  const FuturisticGlassButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.hasGlow = false,
  });

  @override
  State<FuturisticGlassButton> createState() => _FuturisticGlassButtonState();
}

class _FuturisticGlassButtonState extends State<FuturisticGlassButton> with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    // Press scale 0.985
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
      lowerBound: 0.985,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _pressController.animateTo(0.985, curve: Curves.easeIn),
      onTapUp: (_) {
        _pressController.animateTo(1.0, curve: Curves.easeOut);
        widget.onTap();
      },
      onTapCancel: () => _pressController.animateTo(1.0),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedBuilder(
          animation: _pressController,
          builder: (context, child) {
            return Transform.scale(
              scale: _pressController.value,
              child: Container(
                width: double.infinity,
                height: 60.0,
                decoration: BoxDecoration(
                  color: _pressController.value < 1.0
                      ? AegisColors.surface0
                      : AegisColors.cardBg,
                  borderRadius: BorderRadius.circular(18.0),
                  border: Border.all(
                    color: AegisColors.border1, // default rgba(255,255,255,.08)
                    width: 1.0,
                  ),
                  boxShadow: widget.hasGlow
                      ? [
                          BoxShadow(
                            color: const Color(0xFF256DFF).withOpacity(_isHovered ? 0.08 : 0.05), // soft glow
                            blurRadius: 25.0,
                            spreadRadius: 1.0,
                          ),
                        ]
                      : null,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outlined white 20px icon at left padding 22px (perfect alignment)
                    Positioned(
                      left: 22.0,
                      child: Icon(
                        widget.icon,
                        color: AegisColors.textPrimary,
                        size: 20.0,
                      ),
                    ),
                    // Centered label with tracking 0.2
                    Center(
                      child: Text(
                        widget.label,
                        style: TextStyle(
                          color: AegisColors.textPrimary,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
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
    );
  }
}
