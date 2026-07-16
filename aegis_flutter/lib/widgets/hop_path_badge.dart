// HopPathBadge — iOS-style pill badge showing hop count and path.
// Example: "via 2 hops: SIG-A → SIG-B"

import 'package:flutter/material.dart';

class HopPathBadge extends StatelessWidget {
  /// List of node IDs forming the delivery path (including source).
  final List<String> path;

  /// Colour used for the pill background and text. Defaults to blue.
  final Color color;

  const HopPathBadge({
    super.key,
    required this.path,
    this.color = const Color(0xFF2F9BFF),
  });

  @override
  Widget build(BuildContext context) {
    final hops = path.length > 1 ? path.length - 1 : 0;
    final label = _buildLabel(hops);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.alt_route_rounded, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  String _buildLabel(int hops) {
    if (path.isEmpty) return 'direct';
    if (hops == 0) return 'direct';

    final shortPath =
        path.map((id) => id.length > 8 ? id.substring(id.length - 6) : id);
    return 'via $hops ${hops == 1 ? 'hop' : 'hops'}: ${shortPath.join(' → ')}';
  }
}
