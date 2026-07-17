import 'survivor_node.dart';

class SurvivorNodeModel {
  final String id;
  final String status;
  final double? lat;
  final double? lng;
  final List<String> resources;
  final String message;
  final int lastSeen;
  final int batteryLevel;
  final int signalStrength;
  final String deviceName;
  final String platform;
  final String appVersion;
  final String? profileImageBase64;

  const SurvivorNodeModel({
    required this.id,
    required this.status,
    this.lat,
    this.lng,
    this.resources = const [],
    this.message = '',
    required this.lastSeen,
    this.batteryLevel = -1,
    this.signalStrength = 0,
    this.deviceName = '',
    this.platform = '',
    this.appVersion = '',
    this.profileImageBase64,
  });

  bool get hasBattery => batteryLevel >= 0;
  bool get isOffline =>
      DateTime.now().millisecondsSinceEpoch - lastSeen > 60000;

  Map<String, dynamic> toMap() => {
        'id': id,
        'status': status,
        'lat': lat,
        'lng': lng,
        'resources': resources,
        'message': message,
        'lastSeen': lastSeen,
        'batteryLevel': batteryLevel,
        'signalStrength': signalStrength,
        'deviceName': deviceName,
        'platform': platform,
        'appVersion': appVersion,
        'profileImageBase64': profileImageBase64,
      };

  SurvivorNodeModel copyWith({
    String? id,
    String? status,
    double? lat,
    double? lng,
    List<String>? resources,
    String? message,
    int? lastSeen,
    int? batteryLevel,
    int? signalStrength,
    String? deviceName,
    String? platform,
    String? appVersion,
    String? profileImageBase64,
  }) =>
      SurvivorNodeModel(
        id: id ?? this.id,
        status: status ?? this.status,
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
        resources: resources ?? this.resources,
        message: message ?? this.message,
        lastSeen: lastSeen ?? this.lastSeen,
        batteryLevel: batteryLevel ?? this.batteryLevel,
        signalStrength: signalStrength ?? this.signalStrength,
        deviceName: deviceName ?? this.deviceName,
        platform: platform ?? this.platform,
        appVersion: appVersion ?? this.appVersion,
        profileImageBase64: profileImageBase64 ?? this.profileImageBase64,
      );

  factory SurvivorNodeModel.fromMap(Map<dynamic, dynamic> m) =>
      SurvivorNodeModel(
        id: m['id'] as String,
        status: m['status'] as String,
        lat: (m['lat'] as num?)?.toDouble(),
        lng: (m['lng'] as num?)?.toDouble(),
        resources: List<String>.from(m['resources'] ?? []),
        message: m['message'] as String? ?? '',
        lastSeen: (m['lastSeen'] as num).toInt(),
        batteryLevel: (m['batteryLevel'] as num?)?.toInt() ?? -1,
        signalStrength: (m['signalStrength'] as num?)?.toInt() ?? 0,
        deviceName: m['deviceName'] as String? ?? '',
        platform: m['platform'] as String? ?? '',
        appVersion: m['appVersion'] as String? ?? '',
        profileImageBase64: m['profileImageBase64'] as String?,
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

  SurvivorNode toSurvivorNode(
      {double dx = 0.0, double dy = 0.0, int hops = 0, bool isUser = false}) {
    return SurvivorNode(
      id: id,
      hops: hops,
      status: _statusMap[status] ?? NodeStatus.offline,
      isUser: isUser,
      dx: dx,
      dy: dy,
    );
  }

  factory SurvivorNodeModel.fromSurvivorNode(SurvivorNode node,
      {double? lat,
      double? lng,
      List<String>? resources,
      String? message,
      int? lastSeen,
      String? profileImageBase64}) {
    return SurvivorNodeModel(
      id: node.id,
      status: _reverseStatusMap[node.status] ?? 'offline',
      lat: lat,
      lng: lng,
      resources: resources ?? [],
      message: message ?? '',
      lastSeen: lastSeen ?? DateTime.now().millisecondsSinceEpoch,
      profileImageBase64: profileImageBase64,
    );
  }
}
