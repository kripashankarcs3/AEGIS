import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';

class SosBroadcastCard extends StatelessWidget {
  final String countdownText;
  final VoidCallback? onHoldComplete;

  const SosBroadcastCard({
    super.key,
    this.countdownText = '05:00',
    this.onHoldComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: AegisColors.sosRed.withOpacity(0.4), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: AegisColors.sosRed.withOpacity(0.08),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Alert Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.campaign_rounded,
                color: AegisColors.sosRed,
                size: 24.0,
              ),
              const SizedBox(width: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'EMERGENCY ALERT',
                    style: TextStyle(
                      color: AegisColors.sosRed,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    'Broadcast to all nodes in range',
                    style: TextStyle(
                      color: AegisColors.textSecondary,
                      fontSize: 10.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24.0),

          // Central Glowing SOS Hold Button
          GestureDetector(
            onLongPress: onHoldComplete,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer Glow ring
                Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    border: Border.all(
                      color: AegisColors.sosRed.withOpacity(0.15),
                      width: 4.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AegisColors.sosRed.withOpacity(0.2),
                        blurRadius: 24,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
                // Outer progress line
                SizedBox(
                  width: 132.0,
                  height: 132.0,
                  child: CircularProgressIndicator(
                    value: 0.75, // static arc progress matching mockup
                    strokeWidth: 4.0,
                    valueColor: const AlwaysStoppedAnimation<Color>(AegisColors.sosRed),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                // Inner button face
                Container(
                  width: 116.0,
                  height: 116.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AegisColors.sosRed,
                        const Color(0xFF991B1B),
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'HOLD TO SEND',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        countdownText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),

          // Instruction Text
          const Text(
            'Hold for 5 seconds to send',
            style: TextStyle(
              color: AegisColors.textSecondary,
              fontSize: 11.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
