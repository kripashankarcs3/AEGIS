import 'resource_item.dart';

class ResourceModel {
  final String id;
  final String from;
  final String subtype;
  final String category;
  final int quantity;
  final String message;
  final double? lat;
  final double? lng;
  final int timestamp;
  final int expires;
  final bool isMine;

  const ResourceModel({
    required this.id,
    required this.from,
    required this.subtype,
    required this.category,
    this.quantity = 0,
    this.message = '',
    this.lat,
    this.lng,
    required this.timestamp,
    required this.expires,
    this.isMine = false,
  });

  Map<String, dynamic> toMap() {
    return {
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
  }

  factory ResourceModel.fromMap(Map<String, dynamic> map) {
    return ResourceModel(
      id: map['id'] as String,
      from: map['from'] as String,
      subtype: map['subtype'] as String,
      category: map['category'] as String,
      quantity: (map['quantity'] as num?)?.toInt() ?? 0,
      message: (map['message'] as String?) ?? '',
      lat: (map['lat'] as num?)?.toDouble(),
      lng: (map['lng'] as num?)?.toDouble(),
      timestamp: (map['timestamp'] as num).toInt(),
      expires: (map['expires'] as num).toInt(),
      isMine: (map['isMine'] as bool?) ?? false,
    );
  }

  factory ResourceModel.fromResourceItem(ResourceItem item) {
    final catMap = <ResourceCategory, String>{
      ResourceCategory.water: 'water',
      ResourceCategory.food: 'food',
      ResourceCategory.medical: 'medical',
      ResourceCategory.battery: 'battery',
      ResourceCategory.other: 'other',
    };

    return ResourceModel(
      id: item.id,
      from: item.nodeId,
      subtype: item.type == ResourceType.offered ? 'offered' : 'requested',
      category: catMap[item.category] ?? 'other',
      quantity: _parseQuantity(item.detail),
      message: item.detail,
      lat: null,
      lng: null,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      expires: DateTime.now().millisecondsSinceEpoch + 86400000,
      isMine: item.type == ResourceType.offered,
    );
  }

  ResourceItem toResourceItem() {
    final catMap = <String, ResourceCategory>{
      'water': ResourceCategory.water,
      'food': ResourceCategory.food,
      'medical': ResourceCategory.medical,
      'battery': ResourceCategory.battery,
      'other': ResourceCategory.other,
    };

    return ResourceItem(
      id: id,
      category: catMap[category] ?? ResourceCategory.other,
      title: _deriveTitle(),
      detail: quantity > 0 ? '$quantity available' : message,
      nodeId: from,
      hops: 0,
      timeAgo: _formatTimestamp(timestamp),
      type: subtype == 'offered' ? ResourceType.offered : ResourceType.requested,
    );
  }

  String _deriveTitle() {
    final labels = <String, String>{
      'water': 'Water',
      'food': 'Food',
      'medical': 'Medicine',
      'battery': 'Power Bank',
      'other': 'Supplies',
    };
    final base = labels[category] ?? 'Supplies';
    return subtype == 'offered' ? base : '$base Needed';
  }

  String _formatTimestamp(int ts) {
    final diff = DateTime.now().millisecondsSinceEpoch - ts;
    final minutes = diff ~/ 60000;
    if (minutes < 1) return 'Just now';
    if (minutes < 60) return '$minutes min ago';
    final hours = minutes ~/ 60;
    if (hours < 24) return '$hours h ago';
    final days = hours ~/ 24;
    return '$days d ago';
  }

  static int _parseQuantity(String detail) {
    final match = RegExp(r'(\d+)').firstMatch(detail);
    if (match != null) return int.tryParse(match.group(1) ?? '0') ?? 0;
    return 0;
  }
}
