import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';


class MeshStatsBar extends StatelessWidget {
  const MeshStatsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AegisColors.cardBg, AegisColors.surface2]),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AegisColors.border1.withOpacity(0.5), width: 0.5),
        boxShadow: AegisColors.cardShadow,
      ),
      child: IntrinsicHeight(
        child: Row(children: [
          _stat('8', 'NODES', 'Connected', AegisColors.neonGreen),
          _divider(),
          _stat('42ms', 'LATENCY', 'Excellent', AegisColors.neonGreen),
          _divider(),
          _stat('127', 'PACKETS', 'Relayed', AegisColors.electricBlue),
          _divider(),
          _stat('94%', 'COVERAGE', 'Good', AegisColors.neonGreen),
        ]),
      ),
    );
  }

  Widget _stat(String value, String label, String sub, Color subColor) {
    return Expanded(
      child: Padding(padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.5)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AegisColors.textMuted, letterSpacing: 0.8)),
        const SizedBox(height: 2),
        Text(sub, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: subColor, letterSpacing: 0.2)),
      ])),
    );
  }

  Widget _divider() {
    return Container(width: 1, margin: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, AegisColors.border1.withOpacity(0.5), Colors.transparent])));
  }
}
