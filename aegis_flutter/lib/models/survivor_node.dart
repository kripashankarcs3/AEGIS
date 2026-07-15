import 'package:flutter/material.dart';

enum NodeStatus {
  online,
  relay,
  busy,
  offline,
  sos
}

class SurvivorNode {
  final String id;
  final int hops;
  final NodeStatus status;
  final bool isUser;
  // Position from center (-1.0 to 1.0)
  final double dx;
  final double dy;

  const SurvivorNode({
    required this.id,
    required this.hops,
    required this.status,
    this.isUser = false,
    required this.dx,
    required this.dy,
  });

  Color get color {
    if (isUser) return const Color(0xFF3B82F6); // Royal Blue
    switch (status) {
      case NodeStatus.online:
        return const Color(0xFF10B981); // Green
      case NodeStatus.relay:
        return const Color(0xFFF59E0B); // Yellow
      case NodeStatus.busy:
        return const Color(0xFF8B5CF6); // Purple
      case NodeStatus.offline:
        return const Color(0xFF4B5563); // Grey
      case NodeStatus.sos:
        return const Color(0xFFEF4444); // Red
    }
  }

  String get statusLabel {
    switch (status) {
      case NodeStatus.online:
        return 'Online';
      case NodeStatus.relay:
        return 'Relay';
      case NodeStatus.busy:
        return 'Busy';
      case NodeStatus.offline:
        return 'Offline';
      case NodeStatus.sos:
        return 'SOS';
    }
  }
}
