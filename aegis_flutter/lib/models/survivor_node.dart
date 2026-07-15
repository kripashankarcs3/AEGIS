// Display/state model for a node on the radar — built from incoming
// 'status' packets. Not the same as identity_provider's peer list, this is
// specifically the survivor status layer on top of it.

class SurvivorNode {
  final String id; // SIG-XXXX
  final String status; // 'safe' | 'need_help' | 'have_resources'
  final double? lat;
  final double? lng;
  final List<String> resources;
  final String message;
  final int lastSeen;

  SurvivorNode({
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

  factory SurvivorNode.fromMap(Map<dynamic, dynamic> m) => SurvivorNode(
        id: m['id'],
        status: m['status'],
        lat: m['lat'],
        lng: m['lng'],
        resources: List<String>.from(m['resources'] ?? []),
        message: m['message'] ?? '',
        lastSeen: m['lastSeen'],
      );
}
