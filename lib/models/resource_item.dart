import 'package:flutter/material.dart';

enum ResourceType {
  offered,
  requested
}

enum ResourceCategory {
  water,
  food,
  medical,
  battery,
  other
}

class ResourceItem {
  final String id;
  final ResourceCategory category;
  final String title;
  final String detail;
  final String nodeId;
  final int hops;
  final String timeAgo;
  final ResourceType type;

  const ResourceItem({
    required this.id,
    required this.category,
    required this.title,
    required this.detail,
    required this.nodeId,
    required this.hops,
    required this.timeAgo,
    required this.type,
  });

  IconData get icon {
    switch (category) {
      case ResourceCategory.water:
        return Icons.local_drink_rounded;
      case ResourceCategory.food:
        return Icons.restaurant_rounded;
      case ResourceCategory.medical:
        return Icons.medical_services_rounded;
      case ResourceCategory.battery:
        return Icons.battery_charging_full_rounded;
      case ResourceCategory.other:
        return Icons.help_outline_rounded;
    }
  }

  Color get color {
    switch (category) {
      case ResourceCategory.water:
        return const Color(0xFF10B981);
      case ResourceCategory.food:
        return const Color(0xFFF97316);
      case ResourceCategory.medical:
        return const Color(0xFFEF4444);
      case ResourceCategory.battery:
        return const Color(0xFF10B981);
      case ResourceCategory.other:
        return const Color(0xFF9CA3AF);
    }
  }
  
  Color get lightBgColor {
    switch (category) {
      case ResourceCategory.water:
        return const Color(0xFFECFDF5);
      case ResourceCategory.food:
        return const Color(0xFFFFF7ED);
      case ResourceCategory.medical:
        return const Color(0xFFFEF2F2);
      case ResourceCategory.battery:
        return const Color(0xFFECFDF5);
      case ResourceCategory.other:
        return const Color(0xFFF9FAFB);
    }
  }
}
