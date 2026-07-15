import 'package:flutter/material.dart';
import 'theme/aegis_theme.dart';
import 'screens/main_shell.dart';

class AegisApp extends StatelessWidget {
  const AegisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AEGIS Mesh',
      debugShowCheckedModeBanner: false,
      theme: AegisTheme.darkTheme,
      home: const MainShell(),
    );
  }
}
