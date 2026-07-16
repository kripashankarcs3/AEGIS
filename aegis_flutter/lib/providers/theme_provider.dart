import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';

enum AppThemeMode { system, light, dark }

class ThemeProvider extends ChangeNotifier {
  AppThemeMode _mode = AppThemeMode.dark;

  AppThemeMode get mode => _mode;
  ThemeMode get themeMode {
    switch (_mode) {
      case AppThemeMode.system:
        return ThemeMode.system;
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
    }
  }

  bool get isLightActive {
    if (_mode == AppThemeMode.light) return true;
    if (_mode == AppThemeMode.dark) return false;
    return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
        Brightness.light;
  }

  void setMode(AppThemeMode mode) {
    _mode = mode;
    AegisColors.setLight(mode == AppThemeMode.light ||
        (mode == AppThemeMode.system &&
            WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                Brightness.light));
    notifyListeners();
  }
}

class ThemeProviderWidget extends StatefulWidget {
  final Widget Function(BuildContext) builder;
  const ThemeProviderWidget({super.key, required this.builder});

  static ThemeProvider of(BuildContext context) {
    final widget =
        context.dependOnInheritedWidgetOfExactType<_ThemeProviderInherited>();
    assert(widget != null, 'No ThemeProvider found in context');
    return widget!.provider;
  }

  @override
  State<ThemeProviderWidget> createState() => _ThemeProviderWidgetState();
}

class _ThemeProviderWidgetState extends State<ThemeProviderWidget> {
  final ThemeProvider _provider = ThemeProvider();

  @override
  void initState() {
    super.initState();
    _provider.setMode(AppThemeMode.dark);
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ThemeProviderInherited(
      provider: _provider,
      child: ListenableBuilder(
        listenable: _provider,
        builder: (ctx, __) => widget.builder(ctx),
      ),
    );
  }
}

class _ThemeProviderInherited extends InheritedWidget {
  final ThemeProvider provider;
  const _ThemeProviderInherited({required this.provider, required super.child});

  @override
  bool updateShouldNotify(_ThemeProviderInherited oldWidget) =>
      provider != oldWidget.provider;
}
