enum PacketType {
  chat,
  ack,
  sos,
  status,
  resource,
}

class SignalPacket {
  final String id;
  final String from;
  final String to;
  final PacketType type;

  final String payload;

  final int ttl;
  final int hopCount;

  final List<String> path;

  final DateTime timestamp;

  final String? signature;

  final double? latitude;
  final double? longitude;

  final String? category;

  const SignalPacket({
    required this.id,
    required this.from,
    required this.to,
    required this.type,
    required this.payload,
    required this.ttl,
    required this.hopCount,
    required this.path,
    required this.timestamp,
    this.signature,
    this.latitude,
    this.longitude,
    this.category,
  });

  SignalPacket copyWith({
    String? id,
    String? from,
    String? to,
    PacketType? type,
    String? payload,
    int? ttl,
    int? hopCount,
    List<String>? path,
    DateTime? timestamp,
    String? signature,
    double? latitude,
    double? longitude,
    String? category,
  }) {
    return SignalPacket(
      id: id ?? this.id,
      from: from ?? this.from,
      to: to ?? this.to,
      type: type ?? this.type,
      payload: payload ?? this.payload,
      ttl: ttl ?? this.ttl,
      hopCount: hopCount ?? this.hopCount,
      path: path ?? this.path,
      timestamp: timestamp ?? this.timestamp,
      signature: signature ?? this.signature,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'from': from,
      'to': to,
      'type': type.name,
      'payload': payload,
      'ttl': ttl,
      'hopCount': hopCount,
      'path': path,
      'timestamp': timestamp.toIso8601String(),
      'signature': signature,
      'latitude': latitude,
      'longitude': longitude,
      'category': category,
    };
  }

  factory SignalPacket.fromJson(Map<String, dynamic> json) {
    return SignalPacket(
      id: json['id'],
      from: json['from'],
      to: json['to'],
      type: PacketType.values.firstWhere(
        (e) => e.name == json['type'],
      ),
      payload: json['payload'],
      ttl: json['ttl'],
      hopCount: json['hopCount'],
      path: List<String>.from(json['path']),
      timestamp: DateTime.parse(json['timestamp']),
      signature: json['signature'],
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      category: json['category'],
    );
  }
}
