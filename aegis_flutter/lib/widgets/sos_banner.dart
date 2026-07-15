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
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: const Color(0xFF0F121B), // Dark card surface
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: AegisColors.sosRed.withOpacity(0.3), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: AegisColors.sosRed.withOpacity(0.04),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Alert Row (Left aligned icon + Text column)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Red alarm siren icon badge
              Container(
                width: 38.0,
                height: 38.0,
                decoration: BoxDecoration(
                  color: AegisColors.sosRed.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.campaign_rounded,
                    color: AegisColors.sosRed,
                    size: 22.0,
                  ),
                ),
              ),
              const SizedBox(width: 14.0),
              // Text Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Send Emergency Alert',
                      style: TextStyle(
                        color: AegisColors.sosRed,
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 3.0),
                    Text(
                      'Broadcast your emergency to\nall nearby nodes instantly.',
                      style: TextStyle(
                        color: AegisColors.textSecondary,
                        fontSize: 11.0,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 28.0),

          // Central Glowing SOS Hold Button
          GestureDetector(
            onLongPress: onHoldComplete,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer Glow ring
                Container(
                  width: 138.0,
                  height: 138.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    border: Border.all(
                      color: AegisColors.sosRed.withOpacity(0.12),
                      width: 4.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AegisColors.sosRed.withOpacity(0.15),
                        blurRadius: 20,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                // Outer progress indicator
                SizedBox(
                  width: 130.0,
                  height: 130.0,
                  child: CircularProgressIndicator(
                    value: 0.75, // static arc progress matching mockup 9
                    strokeWidth: 4.0,
                    valueColor: const AlwaysStoppedAnimation<Color>(AegisColors.sosRed),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                // Inner button face
                Container(
                  width: 114.0,
                  height: 114.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AegisColors.sosRed,
                        Color(0xFF991B1B),
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
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2.0),
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
          const SizedBox(height: 20.0),

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
