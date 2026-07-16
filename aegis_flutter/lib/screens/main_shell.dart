import 'dart:ui' as ui;
import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';
import 'radar_screen.dart';
import 'chat_screen.dart';
import 'sos_screen.dart';
import 'resource_feed_screen.dart';
import 'network_map_screen.dart';

class MainShell extends StatefulWidget {
  final int initialTab;
  const MainShell({super.key, this.initialTab = 0});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> with TickerProviderStateMixin {
  late int _currentIndex;
  late AnimationController _sosPulse;
  late AnimationController _glowShift;
  late Animation<double> _sosScale;
  late Animation<double> _glowAnim;

  final List<Widget> _screens = const [
    RadarScreen(),
    ChatScreen(),
    SosScreen(),
    ResourceFeedScreen(),
    NetworkMapScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
    _sosPulse = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _sosScale = Tween<double>(begin: 0.92, end: 1.08).animate(CurvedAnimation(parent: _sosPulse, curve: Curves.easeInOutSine));
    _glowShift = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat(reverse: true);
    _glowAnim = Tween<double>(begin: 0.3, end: 0.7).animate(CurvedAnimation(parent: _glowShift, curve: Curves.easeInOutSine));
  }

  @override
  void dispose() {
    _sosPulse.dispose();
    _glowShift.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AegisColors.background,
      extendBody: true,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: ScaleTransition(scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation), child: child));
        },
        child: KeyedSubtree(key: ValueKey(_currentIndex), child: _screens[_currentIndex]),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 40, offset: const Offset(0, 12), spreadRadius: -8),
            BoxShadow(color: AegisColors.electricBlue.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 4)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                  colors: [AegisColors.cardBg.withOpacity(0.92), AegisColors.surface1.withOpacity(0.92)],
                ),
                border: Border.all(color: AegisColors.glassBorder, width: 0.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _navItem(0, Icons.radar_rounded, 'Radar'),
                  _navItem(1, Icons.chat_bubble_outline_rounded, 'Chat'),
                  _sosFab(),
                  _navItem(3, Icons.library_books_outlined, 'Resources'),
                  _navItem(4, Icons.map_outlined, 'Map'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(int idx, IconData icon, String label) {
    final sel = _currentIndex == idx;
    return Expanded(
      child: InkWell(
        onTap: () => _onTabTapped(idx),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                width: 24, height: 24,
                child: sel
                    ? Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: AegisColors.electricBlue.withOpacity(0.15), blurRadius: 12, spreadRadius: 2)]),
                        child: Icon(icon, color: AegisColors.electricBlue, size: 22),
                      )
                    : Icon(icon, color: AegisColors.textMuted, size: 22),
              ),
              const SizedBox(height: 3),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 250),
                style: TextStyle(
                  color: sel ? AegisColors.electricCyan : AegisColors.textMuted,
                  fontSize: sel ? 10 : 9.5,
                  fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                  letterSpacing: 0.3,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sosFab() {
    final sel = _currentIndex == 2;
    return Expanded(
      child: Center(
        child: GestureDetector(
          onTap: () => _onTabTapped(2),
          child: AnimatedBuilder(
            animation: Listenable.merge([_sosPulse, _glowShift]),
            builder: (_, __) {
              return Container(
                width: 52, height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AegisColors.sosGradient,
                  boxShadow: [
                    BoxShadow(color: AegisColors.sosRed.withOpacity(_glowAnim.value * 0.5), blurRadius: 20 + 10 * sin(_sosPulse.value * pi), spreadRadius: 3 + 2 * sin(_sosPulse.value * pi)),
                    BoxShadow(color: AegisColors.sosRed.withOpacity(0.2), blurRadius: 40, spreadRadius: 6),
                  ],
                  border: sel ? Border.all(color: Colors.white.withOpacity(0.8), width: 2.5) : Border.all(color: Colors.white.withOpacity(0.15), width: 1),
                ),
                child: Transform.scale(
                  scale: sel ? 1.0 : _sosScale.value,
                  child: Center(
                    child: Text('SOS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 0.8, shadows: [Shadow(color: Colors.white.withOpacity(0.3), blurRadius: 8)])),
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
