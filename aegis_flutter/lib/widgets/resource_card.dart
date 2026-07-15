import 'package:flutter/material.dart';
import '../models/resource_item.dart';
import '../constants/aegis_colors.dart';

class ResourceCard extends StatelessWidget {
  final ResourceItem item;
  final String actionLabel;
  final VoidCallback? onReplyTap;

  const ResourceCard({
    super.key,
    required this.item,
    this.actionLabel = 'Reply',
    this.onReplyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: AegisColors.cardBackground,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: AegisColors.border, width: 1.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon Badge Circle
            Container(
              width: 38.0,
              height: 38.0,
              decoration: BoxDecoration(
                color: item.lightBgColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                item.icon,
                color: item.color,
                size: 18.0,
              ),
            ),
            const SizedBox(width: 12.0),
            // Text Detail Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    item.detail,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AegisColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    '${item.nodeId}  •  ${item.hops} hop${item.hops > 1 ? 's' : ''}  •  ${item.timeAgo}',
                    style: const TextStyle(
                      fontSize: 9.5,
                      color: AegisColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            // Green Action Button
            GestureDetector(
              onTap: onReplyTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF042F1A).withOpacity(0.4),
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(
                    color: AegisColors.activeGreen.withOpacity(0.4),
                    width: 1.0,
                  ),
                ),
                child: Text(
                  actionLabel,
                  style: const TextStyle(
                    fontSize: 11.0,
                    fontWeight: FontWeight.bold,
                    color: AegisColors.activeGreen,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
