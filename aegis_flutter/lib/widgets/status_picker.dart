// StatusPicker — iOS-style segmented picker for survivor status.
// Options: Safe / Need Help / Have Resources

import 'package:flutter/material.dart';

enum SurvivorStatus { safe, needHelp, haveResources }

class StatusPicker extends StatelessWidget {
  final SurvivorStatus selected;
  final ValueChanged<SurvivorStatus> onChanged;

  const StatusPicker({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  static const _segments = [
    _SegmentData(SurvivorStatus.safe, '✅  Safe', Color(0xFF10B981)),
    _SegmentData(SurvivorStatus.needHelp, '🆘  Need Help', Color(0xFFEF4444)),
    _SegmentData(
        SurvivorStatus.haveResources, '📦  Have Resources', Color(0xFFF97316)),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        children: _segments.map((seg) {
          final isSelected = selected == seg.value;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(seg.value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(11),
                  boxShadow: isSelected
                      ? const [
                          BoxShadow(
                            color: Color(0x1A000000),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          )
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    seg.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isSelected ? seg.color : const Color(0xFF6B7280),
                      fontSize: 11,
                      fontWeight:
                          isSelected ? FontWeight.w800 : FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SegmentData {
  final SurvivorStatus value;
  final String label;
  final Color color;

  const _SegmentData(this.value, this.label, this.color);
}
