import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/mesh_provider.dart';
import 'theme/aegis_theme.dart';
import 'screens/onboarding_screen.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(meshProvider.notifier).start();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeProviderWidget(
      builder: (context) {
        final provider = ThemeProviderWidget.of(context);
        return MaterialApp(
          navigatorKey: _navigatorKey,
          key: ValueKey(provider.mode),
          title: 'AEGIS Mesh',
          debugShowCheckedModeBanner: false,
          theme: AegisTheme.lightTheme,
          darkTheme: AegisTheme.darkTheme,
          themeMode: provider.themeMode,
          home: const OnboardingScreen(),
        );
      },
    );
  }
}
