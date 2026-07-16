import 'package:flutter/material.dart';
import '../models/resource_item.dart';
import '../constants/aegis_colors.dart';
class ResourceCard extends StatelessWidget {
  final ResourceItem item;
  final String actionLabel;
  final VoidCallback? onReplyTap;

  const ResourceCard({super.key, required this.item, this.actionLabel = 'Reply', this.onReplyTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AegisColors.cardBg, AegisColors.surface2]),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AegisColors.border1.withOpacity(0.4), width: 0.5),
        boxShadow: AegisColors.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(color: item.color.withOpacity(0.12), shape: BoxShape.circle, border: Border.all(color: item.color.withOpacity(0.2), width: 1)), child: Icon(item.icon, color: item.color, size: 20)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(item.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: -0.2)),
            const SizedBox(height: 2),
            Text(item.detail, style: const TextStyle(fontSize: 12, color: AegisColors.textSecondary)),
            const SizedBox(height: 6),
            Row(children: [
              const Icon(Icons.sensors_rounded, size: 10, color: AegisColors.textMuted),
              const SizedBox(width: 4),
              Text('${item.nodeId}', style: const TextStyle(fontSize: 10, color: AegisColors.textMuted, fontWeight: FontWeight.w500)),
              const SizedBox(width: 8),
              Text('${item.hops} hop${item.hops > 1 ? 's' : ''}', style: const TextStyle(fontSize: 10, color: AegisColors.textMuted)),
            ]),
          ])),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onReplyTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(color: AegisColors.neonGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(10), border: Border.all(color: AegisColors.neonGreen.withOpacity(0.25), width: 0.5)),
              child: Text(actionLabel, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AegisColors.neonGreen)),
            ),
          ),
        ]),
      ),
    );
  }
}
