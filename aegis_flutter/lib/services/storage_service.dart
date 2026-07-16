import 'package:hive_flutter/hive_flutter.dart';

// Storage Service
// Hive box initialization + helpers

class StorageService {
  static const String _settingsBox = 'settings';
  static const String _profileImageKey = 'profile_image_path';

  static Box get _box => Hive.box(_settingsBox);

  static String? getProfileImagePath() {
    try {
      return _box.get(_profileImageKey) as String?;
    } catch (e) {
      return null;
    }
  }

  static Future<void> setProfileImagePath(String? path) async {
    if (path == null) {
      await _box.delete(_profileImageKey);
    } else {
      await _box.put(_profileImageKey, path);
    }
  }
}
