class SurvivorNodeModel {
  final String id;
  final String status;
  final double? lat;
  final double? lng;
  final List<String> resources;
  final String message;
  final int lastSeen;

  SurvivorNodeModel({
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
        id: m['id'],
        status: m['status'],
        lat: m['lat'],
        lng: m['lng'],
        resources: List<String>.from(m['resources'] ?? []),
        message: m['message'] ?? '',
        lastSeen: m['lastSeen'],
      );
}
