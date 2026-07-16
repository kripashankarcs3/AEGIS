// AegisMessage Model - Universal packet structure
// Used for all mesh communications
// Includes routing metadata + encrypted payload
// Note: HiveObject inheritance kept for future adapter; part directive removed
// since storage layer uses plain Maps (no code generation needed).

// ignore: depend_on_referenced_packages
import 'package:hive/hive.dart';

class AegisMessage extends HiveObject {
  String id; // UUID - unique message identifier
  String from; // Sender SIG-XXXX
  String? to; // Recipient SIG-XXXX (null = broadcast)
  List<String> path; // Routing path: [SIG-7F3A, SIG-B291, SIG-C4E1]
  int hopCount; // Number of hops so far
  int ttl; // Time-to-live (max hops allowed)
  int timestamp; // Unix milliseconds
  String type; // "chat" | "ack" | "broadcast" | "sos" | "status"
  String? encryptedPayload; // AES-256 encrypted content
  String? signature; // ECDSA signature
  String? status; // "queued" | "sent" | "delivered"
  Map<String, double>? gps; // {lat, lng}
  String? category; // For SOS: "medical" | "fire" | "water" | "trapped"

  AegisMessage({
    required this.id,
    required this.from,
    this.to,
    required this.path,
    required this.hopCount,
    required this.ttl,
    required this.timestamp,
    required this.type,
    this.encryptedPayload,
    this.signature,
    this.status,
    this.gps,
    this.category,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'from': from,
        'to': to,
        'path': path,
        'hopCount': hopCount,
        'ttl': ttl,
        'timestamp': timestamp,
        'type': type,
        'encryptedPayload': encryptedPayload,
        'signature': signature,
        'status': status,
        'gps': gps,
        'category': category,
      };

  factory AegisMessage.fromJson(Map<String, dynamic> json) => AegisMessage(
        id: json['id'] as String,
        from: json['from'] as String,
        to: json['to'] as String?,
        path: List<String>.from(json['path'] ?? []),
        hopCount: json['hopCount'] as int,
        ttl: json['ttl'] as int,
        timestamp: json['timestamp'] as int,
        type: json['type'] as String,
        encryptedPayload: json['encryptedPayload'] as String?,
        signature: json['signature'] as String?,
        status: json['status'] as String?,
        gps: json['gps'] != null ? Map<String, double>.from(json['gps']) : null,
        category: json['category'] as String?,
      );

  AegisMessage copyWith({
    String? id,
    String? from,
    String? to,
    List<String>? path,
    int? hopCount,
    int? ttl,
    int? timestamp,
    String? type,
    String? encryptedPayload,
    String? signature,
    String? status,
    Map<String, double>? gps,
    String? category,
  }) =>
      AegisMessage(
        id: id ?? this.id,
        from: from ?? this.from,
        to: to ?? this.to,
        path: path ?? this.path,
        hopCount: hopCount ?? this.hopCount,
        ttl: ttl ?? this.ttl,
        timestamp: timestamp ?? this.timestamp,
        type: type ?? this.type,
        encryptedPayload: encryptedPayload ?? this.encryptedPayload,
        signature: signature ?? this.signature,
        status: status ?? this.status,
        gps: gps ?? this.gps,
        category: category ?? this.category,
      );

  @override
  String toString() =>
      'AegisMessage{id: $id, from: $from, to: $to, hops: $hopCount, type: $type}';
}
