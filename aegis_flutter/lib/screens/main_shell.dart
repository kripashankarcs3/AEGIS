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

  final List<Widget> _screens = [
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
    _sosPulse =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);
    _sosScale = Tween<double>(begin: 0.92, end: 1.08).animate(
        CurvedAnimation(parent: _sosPulse, curve: Curves.easeInOutSine));
    _glowShift =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..repeat(reverse: true);
    _glowAnim = Tween<double>(begin: 0.3, end: 0.7).animate(
        CurvedAnimation(parent: _glowShift, curve: Curves.easeInOutSine));
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
          return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                  scale:
                      Tween<double>(begin: 0.95, end: 1.0).animate(animation),
                  child: child));
        },
        child: KeyedSubtree(
            key: ValueKey(_currentIndex), child: _screens[_currentIndex]),
      ),
      bottomNavigationBar: Container(
        height: 86,
        decoration: BoxDecoration(
          color: AegisColors.isLight ? Colors.white : AegisColors.cardBg,
          border: Border(
              top: BorderSide(
                  color: AegisColors.isLight
                      ? const Color(0xFFE5E7EB)
                      : AegisColors.border1,
                  width: 1)),
          boxShadow: [
            BoxShadow(
                color:
                    Colors.black.withOpacity(AegisColors.isLight ? 0.06 : 0.45),
                blurRadius: 22,
                offset: const Offset(0, -4)),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _navItem(0, Icons.radar_rounded, 'Radar'),
              _navItem(1, Icons.chat_bubble_outline_rounded, 'Chat'),
              _sosFab(),
              _navItem(3, Icons.inventory_2_outlined, 'Resources'),
              _navItem(4, Icons.map_outlined, 'Map'),
            ],
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
                width: 24,
                height: 24,
                child: sel
                    ? Icon(icon, color: AegisColors.electricBlue, size: 23)
                    : Icon(icon, color: AegisColors.textMuted, size: 22),
              ),
              SizedBox(height: 3),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 250),
                style: TextStyle(
                  color: sel ? AegisColors.electricBlue : AegisColors.textMuted,
                  fontSize: 10,
                  fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                  letterSpacing: 0,
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
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AegisColors.sosGradient,
                  boxShadow: [
                    BoxShadow(
                        color: AegisColors.sosRed
                            .withOpacity(_glowAnim.value * 0.35),
                        blurRadius: 14 + 8 * sin(_sosPulse.value * pi),
                        spreadRadius: 1 + sin(_sosPulse.value * pi)),
                  ],
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: Transform.scale(
                  scale: sel ? 1.0 : _sosScale.value,
                  child: Center(
                    child: Text('SOS',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                            letterSpacing: 0,
                            shadows: [
                              Shadow(
                                  color: Colors.white.withOpacity(0.3),
                                  blurRadius: 8)
                            ])),
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
