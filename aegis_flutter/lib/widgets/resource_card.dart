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
        color: AegisColors.isLight ? item.lightBgColor : AegisColors.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border(
          left: BorderSide(color: item.color, width: 4),
          top: BorderSide(color: AegisColors.border1.withOpacity(0.4), width: 0.5),
          right: BorderSide(color: AegisColors.border1.withOpacity(0.4), width: 0.5),
          bottom: BorderSide(color: AegisColors.border1.withOpacity(0.4), width: 0.5),
        ),
        boxShadow: AegisColors.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(color: item.color.withOpacity(0.12), shape: BoxShape.circle, border: Border.all(color: item.color.withOpacity(0.2), width: 1)), child: Icon(item.icon, color: item.color, size: 20)),
          SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(item.title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AegisColors.textPrimary, letterSpacing: -0.2)),
            SizedBox(height: 2),
            Text(item.detail, style: TextStyle(fontSize: 12, color: AegisColors.textSecondary)),
            SizedBox(height: 6),
            Row(children: [
              Icon(Icons.sensors_rounded, size: 10, color: AegisColors.textMuted),
              SizedBox(width: 4),
              Text('${item.nodeId}', style: TextStyle(fontSize: 10, color: AegisColors.textMuted, fontWeight: FontWeight.w500)),
              SizedBox(width: 8),
              Text('${item.hops} hop${item.hops > 1 ? 's' : ''}', style: TextStyle(fontSize: 10, color: AegisColors.textMuted)),
            ]),
          ])),
          SizedBox(width: 8),
          GestureDetector(
            onTap: onReplyTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Reply", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: item.color)),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward_rounded, size: 14, color: item.color),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
