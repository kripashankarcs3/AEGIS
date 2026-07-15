// Display model for a single card in ResourceFeedScreen.

class ResourceItem {
  final String id;
  final String from;
  final String subtype; // 'offer' | 'request'
  final String category; // water | food | medicine | shelter | tools | people
  final String quantity;
  final String message;
  final double? lat;
  final double? lng;
  final int timestamp;
  final int expires;
  final bool isMine;

  ResourceItem({
    required this.id,
    required this.from,
    required this.subtype,
    required this.category,
    required this.quantity,
    required this.message,
    this.lat,
    this.lng,
    required this.timestamp,
    required this.expires,
    this.isMine = false,
  });

  bool get isExpired => DateTime.now().millisecondsSinceEpoch > expires;

  Map<String, dynamic> toMap() => {
        'id': id,
        'from': from,
        'subtype': subtype,
        'category': category,
        'quantity': quantity,
        'message': message,
        'lat': lat,
        'lng': lng,
        'timestamp': timestamp,
        'expires': expires,
        'isMine': isMine,
      };

  factory ResourceItem.fromMap(Map<dynamic, dynamic> m) => ResourceItem(
        id: m['id'],
        from: m['from'],
        subtype: m['subtype'],
        category: m['category'],
        quantity: m['quantity'] ?? '',
        message: m['message'] ?? '',
        lat: m['lat'],
        lng: m['lng'],
        timestamp: m['timestamp'],
        expires: m['expires'],
        isMine: m['isMine'] ?? false,
      );
}
