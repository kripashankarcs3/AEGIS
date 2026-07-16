import 'package:flutter/material.dart';

class AegisColorsLight {
  // Brand accents stay identical to dark theme
  static const Color electricBlue = Color(0xFF0088FF);
  static const Color electricCyan = Color(0xFF00E5FF);
  static const Color neonGreen = Color(0xFF16C784);
  static const Color lime = Color(0xFF39FF14);
  static const Color amber = Color(0xFFFFB300);
  static const Color orange = Color(0xFFFF6B00);
  static const Color red = Color(0xFFFF0030);
  static const Color crimson = Color(0xFFDC143C);
  static const Color violet = Color(0xFF7C3AED);
  static const Color purple = Color(0xFFA855F7);
  static const Color magenta = Color(0xFFFF00FF);
  static const Color pink = Color(0xFFFF0080);

  // Light Surfaces
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface0 = Color(0xFFF1F5F9);
  static const Color surface1 = Color(0xFFF8FAFC);
  static const Color surface2 = Color(0xFFF3F4F6);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color cardBgAlt = Color(0xFFFAFBFC);
  static const Color elevated = Color(0xFFFFFFFF);
  static const Color glassBg = Color(0x14FFFFFF);
  static const Color glassBorder = Color(0x22FFFFFF);

  // Borders
  static const Color border1 = Color(0xFFE5E7EB);
  static const Color border2 = Color(0xFFD1D5DB);
  static const Color borderLight = Color(0xFFE5E7EB);

  // Text
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF4B5563);
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color textDim = Color(0xFFD1D5DB);

  // Status
  static const Color safe = Color(0xFF22C55E);
  static const Color sosRed = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color relay = Color(0xFFA855F7);

  // Shadows
  static List<BoxShadow> glow({Color color = electricBlue, double radius = 20, double spread = 2}) => [
    BoxShadow(color: color.withOpacity(0.2), blurRadius: radius, spreadRadius: spread),
    BoxShadow(color: color.withOpacity(0.1), blurRadius: radius * 2, spreadRadius: spread * 0.5),
  ];

  static List<BoxShadow> get glowBlue => glow(color: electricBlue);
  static List<BoxShadow> get glowGreen => glow(color: neonGreen);
  static List<BoxShadow> get glowRed => glow(color: sosRed, radius: 30, spread: 4);
  static List<BoxShadow> get glowPurple => glow(color: violet, radius: 24);

  static List<BoxShadow> get cardShadow => [
    BoxShadow(color: Color(0xFF0F172A).withOpacity(0.08), blurRadius: 24, offset: const Offset(0, 8), spreadRadius: -4),
    BoxShadow(color: Color(0xFF0F172A).withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4)),
  ];

  static List<BoxShadow> get cardShadowElevated => [
    BoxShadow(color: Color(0xFF0F172A).withOpacity(0.1), blurRadius: 32, offset: const Offset(0, 12), spreadRadius: -8),
    BoxShadow(color: Color(0xFF0088FF).withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 6)),
  ];

  // Gradients
  static final Gradient bgGradient = LinearGradient(
    begin: Alignment.topCenter, end: Alignment.bottomCenter,
    colors: [const Color(0xFFF8FAFC), const Color(0xFFF1F5F9)],
  );

  static final Gradient cardGradient = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [const Color(0xFFFFFFFF), const Color(0xFFFAFBFC)],
  );

  static final Gradient glassGradient = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [const Color(0x18FFFFFF), const Color(0x08FFFFFF)],
    stops: [0.0, 1.0],
  );

  static const Gradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [Color(0xFF0088FF), Color(0xFF00E5FF)],
  );

  static const Gradient sosGradient = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
  );

  static const Gradient greenGradient = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
  );

  static const Gradient purpleGradient = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [Color(0xFF7C3AED), Color(0xFF6D28D9)],
  );

  static const Gradient cyanGradient = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [Color(0xFF00E5FF), Color(0xFF0088FF)],
  );

  static const Gradient amberGradient = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
  );

  static final Gradient sosBgGradient = LinearGradient(
    begin: Alignment.topCenter, end: Alignment.bottomCenter,
    colors: [const Color(0xFFFEF2F2), const Color(0xFFFFF5F5)],
  );

  static final Gradient scanningGradient = LinearGradient(
    begin: Alignment.topCenter, end: Alignment.bottomCenter,
    colors: [const Color(0xFFF0FDF4), const Color(0xFFF8FAFC)],
  );
}
