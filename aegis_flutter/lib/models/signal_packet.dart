// The one packet shape that goes over the mesh, no matter what kind of
// message it is. Matches the schema in the plan doc — chat/ack/sos/status/
// resource all use this same wrapper, just with different fields filled in.

enum PacketType { chat, ack, sos, status, resource }

PacketType packetTypeFromString(String s) {
  return PacketType.values.firstWhere(
    (t) => t.name == s,
    orElse: () => PacketType.chat,
  );
}

class SignalPacket {
  final String id;
  final String from;
  final String to; // 'broadcast' for sos/status/resource
  final List<String> path;
  final int hopCount;
  final int ttl;
  final int timestamp;
  final PacketType type;

  // chat
  final String? payload; // encrypted/plain message body, Part 1's crypto handles encryption
  final String? signature;

  // sos + status share gps/alarm
  final double? lat;
  final double? lng;
  final bool alarm;

  // sos only
  final String? category;
  final String? message;

  // status only
  final String? status; // 'safe' | 'need_help' | 'have_resources'
  final List<String>? resources;

  // resource only
  final String? subtype; // 'offer' | 'request'
  final String? quantity;
  final int? expires;

  SignalPacket({
    required this.id,
    required this.from,
    required this.to,
    this.path = const [],
    this.hopCount = 0,
    this.ttl = 10,
    required this.timestamp,
    required this.type,
    this.payload,
    this.signature,
    this.lat,
    this.lng,
    this.alarm = false,
    this.category,
    this.message,
    this.status,
    this.resources,
    this.subtype,
    this.quantity,
    this.expires,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'id': id,
      'from': from,
      'to': to,
      'path': path,
      'hop_count': hopCount,
      'ttl': ttl,
      'timestamp': timestamp,
      'type': type.name,
    };
    if (payload != null) json['payload'] = payload;
    if (signature != null) json['signature'] = signature;
    if (lat != null || lng != null) json['gps'] = {'lat': lat, 'lng': lng};
    if (alarm) json['alarm'] = alarm;
    if (category != null) json['category'] = category;
    if (message != null) json['message'] = message;
    if (status != null) json['status'] = status;
    if (resources != null) json['resources'] = resources;
    if (subtype != null) json['subtype'] = subtype;
    if (quantity != null) json['quantity'] = quantity;
    if (expires != null) json['expires'] = expires;
    return json;
  }

  factory SignalPacket.fromJson(Map<String, dynamic> j) {
    final gps = j['gps'] as Map?;
    return SignalPacket(
      id: j['id'],
      from: j['from'],
      to: j['to'],
      path: j['path'] != null ? List<String>.from(j['path']) : const [],
      hopCount: j['hop_count'] ?? 0,
      ttl: j['ttl'] ?? 10,
      timestamp: j['timestamp'],
      type: packetTypeFromString(j['type']),
      payload: j['payload'],
      signature: j['signature'],
      lat: gps?['lat'],
      lng: gps?['lng'],
      alarm: j['alarm'] ?? false,
      category: j['category'],
      message: j['message'],
      status: j['status'],
      resources: j['resources'] != null ? List<String>.from(j['resources']) : null,
      subtype: j['subtype'],
      quantity: j['quantity'],
      expires: j['expires'],
    );
  }
}
