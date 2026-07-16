import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage (opens all Hive boxes)
  await StorageService.init();

  runApp(
    const ProviderScope(
      child: AegisApp(),
    ),
  );
}
