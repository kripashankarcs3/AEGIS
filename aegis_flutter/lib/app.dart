import 'package:flutter/material.dart';
import 'theme/aegis_theme.dart';
import 'screens/splash_screen.dart';
import 'providers/theme_provider.dart';

class AegisApp extends StatelessWidget {
  const AegisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeProviderWidget(
      child: Builder(
        builder: (context) {
          final provider = ThemeProviderWidget.of(context);
          return MaterialApp(
            key: ValueKey(provider.mode),
            title: 'AEGIS Mesh',
            debugShowCheckedModeBanner: false,
            theme: AegisTheme.lightTheme,
            darkTheme: AegisTheme.darkTheme,
            themeMode: provider.themeMode,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
