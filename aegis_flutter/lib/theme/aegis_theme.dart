import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';

class AegisTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AegisColors.electricBlue,
        secondary: AegisColors.neonGreen,
        error: AegisColors.sosRed,
        surface: AegisColors.cardBg,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onError: Colors.white,
        onSurface: AegisColors.textPrimary,
        primaryContainer: AegisColors.electricBlue,
        tertiary: AegisColors.violet,
      ),
      scaffoldBackgroundColor: AegisColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(color: AegisColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.5),
        iconTheme: IconThemeData(color: AegisColors.textPrimary, size: 22),
      ),
      cardTheme: CardThemeData(
        color: AegisColors.cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: AegisColors.border1, width: 0.5)),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        modalBackgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(28), topRight: Radius.circular(28))),
      ),
      dividerTheme: const DividerThemeData(color: AegisColors.border1, thickness: 0.5, space: 1),
      iconTheme: const IconThemeData(color: AegisColors.textSecondary, size: 22),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AegisColors.electricBlue,
        selectionColor: AegisColors.electricBlue.withOpacity(0.3),
        selectionHandleColor: AegisColors.electricBlue,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: AegisColors.border1, width: 0.5)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AegisColors.cardBgAlt,
        contentTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: AegisColors.border1, width: 0.5)),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AegisColors.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: const BorderSide(color: AegisColors.border1, width: 0.5)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AegisColors.surface2,
        hintStyle: const TextStyle(color: AegisColors.textMuted, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AegisColors.border1, width: 0.5)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AegisColors.border1, width: 0.5)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AegisColors.electricBlue, width: 1.0)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AegisColors.sosRed, width: 0.5)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AegisColors.sosRed, width: 1.0)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AegisColors.electricBlue,
        elevation: 8,
        shape: CircleBorder(),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {TargetPlatform.android: ZoomPageTransitionsBuilder(), TargetPlatform.iOS: CupertinoPageTransitionsBuilder()},
      ),
    );
  }
}
