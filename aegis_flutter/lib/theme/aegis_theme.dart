import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';

class AegisTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AegisColors.primaryBlue,
        secondary: AegisColors.activeGreen,
        error: AegisColors.sosRed,
        background: AegisColors.background,
        surface: AegisColors.cardBackground,
      ),
      scaffoldBackgroundColor: AegisColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AegisColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: AegisColors.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: AegisColors.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AegisColors.border, width: 1),
        ),
      ),
    );
  }
}
