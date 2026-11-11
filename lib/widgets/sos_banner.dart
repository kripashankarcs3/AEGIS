import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';

class SosBroadcastCard extends StatefulWidget {
  final VoidCallback? onHoldComplete;

  const SosBroadcastCard({super.key, this.onHoldComplete});

  @override
  State<SosBroadcastCard> createState() => _SosBroadcastCardState();
}

class _SosBroadcastCardState extends State<SosBroadcastCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _glow;
  late Animation<double> _glowA;

  Timer? _holdTimer;
  double _holdProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _glow = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat(reverse: true);
    _glowA = Tween<double>(begin: 0.2, end: 0.7)
        .animate(CurvedAnimation(parent: _glow, curve: Curves.easeInOutSine));
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    _glow.dispose();
    super.dispose();
  }

  void _startHold() {
    setState(() {
      _holdProgress = 0.0;
    });
    _holdTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _holdProgress += 0.02;
      });
      if (_holdProgress >= 1.0) {
        timer.cancel();
        _holdTimer = null;
        setState(() {
          _holdProgress = 1.0;
        });
        widget.onHoldComplete?.call();
        setState(() {
          _holdProgress = 0.0;
        });
      }
    });
  }

  void _cancelHold() {
    _holdTimer?.cancel();
    _holdTimer = null;
    setState(() {
      _holdProgress = 0.0;
    });
  }

  String get _countdownText {
    final remaining = ((1.0 - _holdProgress) * 3).ceil();
    return '0$remaining:00';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glow,
      builder: (_, __) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: AegisColors.isLight
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFFF5F5), Color(0xFFFFF8F8)])
                : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1A0A0A), Color(0xFF0F121B)]),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
                color:
                    AegisColors.sosRed.withValues(alpha: 0.2 + 0.15 * _glowA.value),
                width: 1),
            boxShadow: [
              BoxShadow(
                  color: AegisColors.sosRed
                      .withValues(alpha: 0.04 + 0.06 * _glowA.value),
                  blurRadius: 32,
                  spreadRadius: 8)
            ],
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                      color: AegisColors.sosRed.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: AegisColors.sosRed.withValues(alpha: 0.25),
                          width: 1)),
                  child: const Center(
                      child: Icon(Icons.campaign_rounded,
                          color: AegisColors.sosRed, size: 24))),
              const SizedBox(width: 16),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    const Text('Send Emergency Alert',
                        style: TextStyle(
                            color: AegisColors.sosRed,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2)),
                    const SizedBox(height: 4),
                    Text(
                        'Broadcast your emergency to\nall nearby nodes instantly.',
                        style: TextStyle(
                            color: AegisColors.textSecondary,
                            fontSize: 12,
                            height: 1.4)),
                  ])),
            ]),
            const SizedBox(height: 32),
            GestureDetector(
              onLongPressStart: (_) => _startHold(),
              onLongPressEnd: (_) => _cancelHold(),
              onLongPressCancel: () => _cancelHold(),
              child: Stack(alignment: Alignment.center, children: [
                Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AegisColors.sosRed
                                .withValues(alpha: _glowA.value * 0.5),
                            width: 4),
                        boxShadow: [
                          BoxShadow(
                              color: AegisColors.sosRed
                                  .withValues(alpha: 0.1 + 0.1 * _glowA.value),
                              blurRadius: 40,
                              spreadRadius: 4)
                        ])),
                SizedBox(
                    width: 148,
                    height: 148,
                    child: CircularProgressIndicator(
                        value: _holdProgress,
                        strokeWidth: 4,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AegisColors.sosRed.withValues(alpha: 0.6)),
                        backgroundColor: Colors.transparent)),
                Container(
                  width: 128,
                  height: 128,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const RadialGradient(
                          colors: [AegisColors.sosRed, Color(0xFF7F1D1D)],
                          stops: [0.6, 1.0]),
                      boxShadow: [
                        BoxShadow(
                            color: AegisColors.sosRed.withValues(alpha: 0.3),
                            blurRadius: 24,
                            spreadRadius: 4)
                      ]),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('HOLD TO\nSEND',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                                height: 1.3)),
                        const SizedBox(height: 4),
                        Text(_countdownText,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1)),
                      ]),
                ),
              ]),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                  color: AegisColors.sosRed
                      .withValues(alpha: AegisColors.isLight ? 0.04 : 0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: AegisColors.sosRed.withValues(alpha: 0.15), width: 0.5)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.lock_outline_rounded,
                    color: AegisColors.textSecondary, size: 13),
                const SizedBox(width: 8),
                Text('Hold for 3 seconds to send',
                    style: TextStyle(
                        color: AegisColors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w500)),
              ]),
            ),
          ]),
        );
      },
    );
  }
}
