import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/mesh_provider.dart';
import 'onboarding_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 0.92, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();

    // Start mesh stack in background while splash is visible
    _startMeshAndNavigate();
  }

  Future<void> _startMeshAndNavigate() async {
    // Start mesh (identity + transport + services)
    await ref.read(meshProvider.notifier).start();

    // Wait for splash animation minimum duration
    await Future.delayed(const Duration(milliseconds: 2200));

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const OnboardingScreen(),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFF5F3FF),
                      border: Border.all(color: const Color(0xFFEDE9FE)),
                    ),
                    child: const Center(
                      child: Text('A',
                          style: TextStyle(
                              color: Color(0xFF7C3AED),
                              fontSize: 46,
                              fontWeight: FontWeight.w900)),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text('AEGIS',
                      style: TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5)),
                  const SizedBox(height: 8),
                  const Text('Mesh Network',
                      style: TextStyle(
                          color: Color(0xFF7C3AED),
                          fontSize: 13,
                          fontWeight: FontWeight.w800)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
