import 'package:hive_flutter/hive_flutter.dart';
import '../models/survivor_node_model.dart';
import '../models/resource_model.dart';
import '../models/peer_address.dart';

class StorageService {
  static const _chatBox = 'chat_messages';
  static const _sosBox = 'sos_log';
  static const _survivorBox = 'survivor_nodes';
  static const _resourceBox = 'resource_feed';
  static const _queueBox = 'message_queue';
  static const _settingsBox = 'settings';
  static const _directPeersBox = 'direct_peers';
  static const _profileImageKey = 'profile_image_path';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Future.wait([
      Hive.openBox(_chatBox),
      Hive.openBox(_sosBox),
      Hive.openBox(_survivorBox),
      Hive.openBox(_resourceBox),
      Hive.openBox(_queueBox),
      Hive.openBox(_settingsBox),
      Hive.openBox(_directPeersBox),
    ]);
  }

  // ---- profile ----
  static String? getProfileImagePath() {
    try {
      return Hive.box(_settingsBox).get(_profileImageKey) as String?;
    } catch (e) {
      return null;
    }
  }

  static Future<void> setProfileImagePath(String? path) async {
    if (path == null) {
      await Hive.box(_settingsBox).delete(_profileImageKey);
    } else {
      await Hive.box(_settingsBox).put(_profileImageKey, path);
    }
  }

  // ---- chat ----
  static List<Map<String, dynamic>> getChatHistory(String peerId) {
    final raw = Hive.box(_chatBox).get(peerId, defaultValue: []) as List;
    return raw.map((m) => Map<String, dynamic>.from(m)).toList();
  }

  static Future<void> saveChatHistory(String peerId, List<Map<String, dynamic>> messages) =>
      Hive.box(_chatBox).put(peerId, messages);

  static Future<void> clearChatHistory(String peerId) async {
    await Hive.box(_chatBox).put(peerId, []);
  }

  static Future<void> deleteChatHistory(String peerId) async {
    await Hive.box(_chatBox).delete(peerId);
  }

  // ---- sos ----
  static Future<List<Map<String, dynamic>>> getSosLog() async {
    final raw = Hive.box(_sosBox).get('alerts', defaultValue: []) as List;
    return raw.map((m) => Map<String, dynamic>.from(m)).toList();
  }

  static Future<void> saveSosLog(List<Map<String, dynamic>> alerts) =>
      Hive.box(_sosBox).put('alerts', alerts);

  // ---- survivors ----
  static Future<void> saveSurvivorNodeModel(SurvivorNodeModel node) async {
    await Hive.box(_survivorBox).put(node.id, node.toMap());
  }

  static Future<List<SurvivorNodeModel>> getAllSurvivorNodeModels() async {
    final box = Hive.box(_survivorBox);
    return box.keys
        .map((k) => SurvivorNodeModel.fromMap(Map<String, dynamic>.from(box.get(k))))
        .toList();
  }

  // ---- resources ----
  static Future<void> saveResourceModel(ResourceModel item) async {
    final raw = Hive.box(_resourceBox).get('posts', defaultValue: []) as List;
    final list = raw.map((m) => ResourceModel.fromMap(Map<String, dynamic>.from(m))).toList();
    if (list.any((p) => p.id == item.id)) return;
    list.add(item);
    await Hive.box(_resourceBox).put('posts', list.map((p) => p.toMap()).toList());
  }

  static Future<List<ResourceModel>> getResourceFeed() async {
    final raw = Hive.box(_resourceBox).get('posts', defaultValue: []) as List;
    final list = raw
        .map((m) => ResourceModel.fromMap(Map<String, dynamic>.from(m)))
        .where((p) => !p.isExpired)
        .toList();
    list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return list;
  }

  static Future<void> purgeExpiredResources() async {
    final raw = Hive.box(_resourceBox).get('posts', defaultValue: []) as List;
    final list = raw
        .map((m) => ResourceModel.fromMap(Map<String, dynamic>.from(m)))
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

  // ---- direct peer addresses (QR-scanned peers) ----
  static Future<void> saveDirectPeer(PeerAddress peer) async {
    await Hive.box(_directPeersBox).put(peer.sigId, peer.toMap());
  }

  static PeerAddress? getDirectPeer(String sigId) {
    final raw = Hive.box(_directPeersBox).get(sigId);
    if (raw == null) return null;
    return PeerAddress.fromMap(Map<String, dynamic>.from(raw));
  }

  static List<PeerAddress> getAllDirectPeers() {
    final box = Hive.box(_directPeersBox);
    return box.keys
        .map((k) => PeerAddress.fromMap(Map<String, dynamic>.from(box.get(k))))
        .toList();
  }

  static Future<void> removeDirectPeer(String sigId) async {
    await Hive.box(_directPeersBox).delete(sigId);
  }

  // ---- local IP cache ----
  static const _localIpKey = 'cached_local_ip';
  static String? getCachedLocalIp() =>
      Hive.box(_settingsBox).get(_localIpKey) as String?;
  static Future<void> setCachedLocalIp(String ip) async =>
      Hive.box(_settingsBox).put(_localIpKey, ip);

  // ---- generic settings (own status, prefs, etc) ----
  static dynamic getSetting(String key) => Hive.box(_settingsBox).get(key);
  static Future<void> setSetting(String key, dynamic value) => Hive.box(_settingsBox).put(key, value);
}
