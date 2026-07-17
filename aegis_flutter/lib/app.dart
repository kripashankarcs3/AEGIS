import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/aegis_theme.dart';
import 'screens/splash_screen.dart';
import 'providers/theme_provider.dart';

class AegisApp extends ConsumerStatefulWidget {
  const AegisApp({super.key});

  @override
  ConsumerState<AegisApp> createState() => _AegisAppState();
}

class _AegisAppState extends ConsumerState<AegisApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeProviderWidget(
      builder: (context) {
        final provider = ThemeProviderWidget.of(context);
        return MaterialApp(
          navigatorKey: _navigatorKey,
          title: 'AEGIS Mesh',
          debugShowCheckedModeBanner: false,
          theme: AegisTheme.lightTheme,
          darkTheme: AegisTheme.darkTheme,
          themeMode: provider.themeMode,
          home: const SplashScreen(),
        );
      },
    );
  }
}
