import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'services/storage_service.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await StorageService.init();
  } catch (e) {
    debugPrint('FATAL: Hive init failed: $e');
  }

  try {
    await NotificationService.instance.init();
  } catch (e) {
    debugPrint('FATAL: Notification init failed: $e');
  }

  runApp(
    const ProviderScope(
      child: AegisApp(),
    ),
  );
}
