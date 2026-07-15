import 'package:hive_flutter/hive_flutter.dart';
import '../models/survivor_node.dart';
import '../models/resource_item.dart';

// One place for all Hive box access. Not using generated TypeAdapters —
// everything's stored as plain Maps, quicker to ship for a 48hr build and
// we're not storing anything that needs strict typing at the storage layer.
class StorageService {
  static const _chatBox = 'chat_messages';
  static const _sosBox = 'sos_log';
  static const _survivorBox = 'survivor_nodes';
  static const _resourceBox = 'resource_feed';
  static const _queueBox = 'message_queue';
  static const _settingsBox = 'settings';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Future.wait([
      Hive.openBox(_chatBox),
      Hive.openBox(_sosBox),
      Hive.openBox(_survivorBox),
      Hive.openBox(_resourceBox),
      Hive.openBox(_queueBox),
      Hive.openBox(_settingsBox),
    ]);
  }

  // ---- chat ----
  static List<Map<String, dynamic>> getChatHistory(String peerId) {
    final raw = Hive.box(_chatBox).get(peerId, defaultValue: []) as List;
    return raw.map((m) => Map<String, dynamic>.from(m)).toList();
  }

  static Future<void> saveChatHistory(String peerId, List<Map<String, dynamic>> messages) =>
      Hive.box(_chatBox).put(peerId, messages);

  // ---- sos ----
  static Future<List<Map<String, dynamic>>> getSosLog() async {
    final raw = Hive.box(_sosBox).get('alerts', defaultValue: []) as List;
    return raw.map((m) => Map<String, dynamic>.from(m)).toList();
  }

  static Future<void> saveSosLog(List<Map<String, dynamic>> alerts) =>
      Hive.box(_sosBox).put('alerts', alerts);

  // ---- survivors ----
  static Future<void> saveSurvivorNode(SurvivorNode node) async {
    await Hive.box(_survivorBox).put(node.id, node.toMap());
  }

  static Future<List<SurvivorNode>> getAllSurvivorNodes() async {
    final box = Hive.box(_survivorBox);
    return box.keys
        .map((k) => SurvivorNode.fromMap(Map<String, dynamic>.from(box.get(k))))
        .toList();
  }

  // ---- resources ----
  static Future<void> saveResourceItem(ResourceItem item) async {
    final raw = Hive.box(_resourceBox).get('posts', defaultValue: []) as List;
    final list = raw.map((m) => ResourceItem.fromMap(Map<String, dynamic>.from(m))).toList();
    if (list.any((p) => p.id == item.id)) return;
    list.add(item);
    await Hive.box(_resourceBox).put('posts', list.map((p) => p.toMap()).toList());
  }

  static Future<List<ResourceItem>> getResourceFeed() async {
    final raw = Hive.box(_resourceBox).get('posts', defaultValue: []) as List;
    final list = raw
        .map((m) => ResourceItem.fromMap(Map<String, dynamic>.from(m)))
        .where((p) => !p.isExpired)
        .toList();
    list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return list;
  }

  static Future<void> purgeExpiredResources() async {
    final raw = Hive.box(_resourceBox).get('posts', defaultValue: []) as List;
    final list = raw
        .map((m) => ResourceItem.fromMap(Map<String, dynamic>.from(m)))
        .where((p) => !p.isExpired)
        .toList();
    await Hive.box(_resourceBox).put('posts', list.map((p) => p.toMap()).toList());
  }

  // ---- offline queue ----
  static Future<List<Map<String, dynamic>>> getQueuedPackets() async {
    final raw = Hive.box(_queueBox).get('pending', defaultValue: []) as List;
    return raw.map((m) => Map<String, dynamic>.from(m)).toList();
  }

  static Future<void> saveQueuedPackets(List<Map<String, dynamic>> packets) =>
      Hive.box(_queueBox).put('pending', packets);

  // ---- generic settings (own status, prefs, etc) ----
  static dynamic getSetting(String key) => Hive.box(_settingsBox).get(key);
  static Future<void> setSetting(String key, dynamic value) => Hive.box(_settingsBox).put(key, value);
}
