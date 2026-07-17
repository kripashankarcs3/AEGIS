import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/aegis_colors.dart';
import '../providers/mesh_provider.dart';

class MeshStatsBar extends ConsumerWidget {
  const MeshStatsBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final peerCount = ref.watch(meshPeerCountProvider);
    final packetsRelayed = ref.watch(meshPacketsRelayedProvider);
    final avgLatency = ref.watch(meshAvgLatencyProvider);
    final coverage = ref.watch(meshCoverageProvider);

    final latencyStr = avgLatency > 0 ? '${avgLatency}ms' : '--';
    final coverageStr = coverage > 0 ? '${(coverage * 100).round()}%' : '--';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AegisColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AegisColors.border1, width: 0.5),
        boxShadow: AegisColors.cardShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statCol('$peerCount', 'Nodes'),
          _dividerCol(),
          _statCol('$packetsRelayed', 'Relayed'),
          _dividerCol(),
          _statCol(latencyStr, 'Avg Latency'),
          _dividerCol(),
          _statCol(coverageStr, 'Coverage'),
        ],
      ),
    );
  }

  Widget _statCol(String value, String label) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AegisColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: AegisColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dividerCol() {
    return Container(
      width: 0.5,
      height: 32,
      color: AegisColors.border1.withValues(alpha: 0.5),
    );
  }
}
