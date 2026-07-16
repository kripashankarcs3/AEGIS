import 'survivor_node.dart';

class SurvivorNodeModel {
  final String id;
  final String status;
  final double? lat;
  final double? lng;
  final List<String> resources;
  final String message;
  final int lastSeen;

  const SurvivorNodeModel({
    required this.id,
    required this.status,
    this.lat,
    this.lng,
    this.resources = const [],
    this.message = '',
    required this.lastSeen,
  });

  bool get isOffline => DateTime.now().millisecondsSinceEpoch - lastSeen > 60000;

  Map<String, dynamic> toMap() => {
        'id': id,
        'status': status,
        'lat': lat,
        'lng': lng,
        'resources': resources,
        'message': message,
        'lastSeen': lastSeen,
      };

  factory SurvivorNodeModel.fromMap(Map<dynamic, dynamic> m) => SurvivorNodeModel(
        id: m['id'] as String,
        status: m['status'] as String,
        lat: (m['lat'] as num?)?.toDouble(),
        lng: (m['lng'] as num?)?.toDouble(),
        resources: List<String>.from(m['resources'] ?? []),
        message: m['message'] as String? ?? '',
        lastSeen: (m['lastSeen'] as num).toInt(),
      );

  static const _statusMap = <String, NodeStatus>{
    'safe': NodeStatus.online,
    'need_help': NodeStatus.sos,
    'have_resources': NodeStatus.relay,
    'busy': NodeStatus.busy,
    'offline': NodeStatus.offline,
  };

  static const _reverseStatusMap = <NodeStatus, String>{
    NodeStatus.online: 'safe',
    NodeStatus.sos: 'need_help',
    NodeStatus.relay: 'have_resources',
    NodeStatus.busy: 'busy',
    NodeStatus.offline: 'offline',
  };

  SurvivorNode toSurvivorNode({double dx = 0.0, double dy = 0.0, int hops = 0, bool isUser = false}) {
    return SurvivorNode(
      id: id,
      hops: hops,
      status: _statusMap[status] ?? NodeStatus.offline,
      isUser: isUser,
      dx: dx,
      dy: dy,
    );
  }

  factory SurvivorNodeModel.fromSurvivorNode(SurvivorNode node, {double? lat, double? lng, List<String>? resources, String? message, int? lastSeen}) {
    return SurvivorNodeModel(
      id: node.id,
      status: _reverseStatusMap[node.status] ?? 'offline',
      lat: lat,
      lng: lng,
      resources: resources ?? [],
      message: message ?? '',
      lastSeen: lastSeen ?? DateTime.now().millisecondsSinceEpoch,
    );
  }
}
