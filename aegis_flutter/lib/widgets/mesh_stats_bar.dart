import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';

class MeshStatsBar extends StatelessWidget {
  const MeshStatsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AegisColors.cardBackground,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: AegisColors.border, width: 1.0),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Nodes
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 6.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '8',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 3.0),
                    const Text(
                      'NODES',
                      style: TextStyle(
                        fontSize: 9.0,
                        fontWeight: FontWeight.bold,
                        color: AegisColors.textMuted,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const Text(
                      'Connected',
                      style: TextStyle(
                        fontSize: 9.0,
                        color: AegisColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildDivider(),
            // Latency
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 6.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '42ms',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 3.0),
                    const Text(
                      'LATENCY',
                      style: TextStyle(
                        fontSize: 9.0,
                        fontWeight: FontWeight.bold,
                        color: AegisColors.textMuted,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const Text(
                      'Excellent',
                      style: TextStyle(
                        fontSize: 9.0,
                        color: AegisColors.activeGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildDivider(),
            // Packets
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 6.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '127',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 3.0),
                    const Text(
                      'PACKETS',
                      style: TextStyle(
                        fontSize: 9.0,
                        fontWeight: FontWeight.bold,
                        color: AegisColors.textMuted,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const Text(
                      'Relayed',
                      style: TextStyle(
                        fontSize: 9.0,
                        color: AegisColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildDivider(),
            // Coverage
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 6.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '94%',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 3.0),
                    const Text(
                      'COVERAGE',
                      style: TextStyle(
                        fontSize: 9.0,
                        fontWeight: FontWeight.bold,
                        color: AegisColors.textMuted,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const Text(
                      'Good',
                      style: TextStyle(
                        fontSize: 9.0,
                        color: AegisColors.activeGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const VerticalDivider(
      color: AegisColors.border,
      width: 1.0,
      thickness: 1.0,
    );
  }
}
