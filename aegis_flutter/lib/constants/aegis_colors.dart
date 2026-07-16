import 'package:flutter/material.dart';

class AegisColors {
  // ═══════════════════════════════════════════════
  // PRIMARY ACCENTS
  // ═══════════════════════════════════════════════
  static const Color electricBlue = Color(0xFF0088FF);
  static const Color electricCyan = Color(0xFF00E5FF);
  static const Color neonGreen = Color(0xFF00FF88);
  static const Color lime = Color(0xFF39FF14);
  static const Color amber = Color(0xFFFFB300);
  static const Color orange = Color(0xFFFF6B00);
  static const Color red = Color(0xFFFF0030);
  static const Color crimson = Color(0xFFDC143C);
  static const Color violet = Color(0xFF8B5CF6);
  static const Color purple = Color(0xFFA855F7);
  static const Color magenta = Color(0xFFFF00FF);
  static const Color pink = Color(0xFFFF0080);

  // ═══════════════════════════════════════════════
  // SURFACE COLORS - Deep Premium Dark
  // ═══════════════════════════════════════════════
  static const Color background = Color(0xFF050508);
  static const Color surface0 = Color(0xFF08080E);
  static const Color surface1 = Color(0xFF0C0C16);
  static const Color surface2 = Color(0xFF111122);
  static const Color cardBg = Color(0xFF0E0E1E);
  static const Color cardBgAlt = Color(0xFF141428);
  static const Color elevated = Color(0xFF1A1A34);
  static const Color glassBg = Color(0x14FFFFFF);
  static const Color glassBorder = Color(0x22FFFFFF);

  // ═══════════════════════════════════════════════
  // BORDERS
  // ═══════════════════════════════════════════════
  static const Color border1 = Color(0xFF1E1E3A);
  static const Color border2 = Color(0xFF2A2A4A);
  static const Color borderLight = Color(0xFF3A3A5A);

  // ═══════════════════════════════════════════════
  // TEXT
  // ═══════════════════════════════════════════════
  static const Color textPrimary = Color(0xFFF0F0FF);
  static const Color textSecondary = Color(0xFF8888AA);
  static const Color textMuted = Color(0xFF55557A);
  static const Color textDim = Color(0xFF33335A);

  // ═══════════════════════════════════════════════
  // STATUS
  // ═══════════════════════════════════════════════
  static const Color safe = Color(0xFF00FF88);
  static const Color sosRed = Color(0xFFFF0030);
  static const Color warning = Color(0xFFFFB300);
  static const Color relay = Color(0xFFA855F7);

  // ═══════════════════════════════════════════════
  // GLOW BOX SHADOWS - Reusable
  // ═══════════════════════════════════════════════
  static List<BoxShadow> glow({Color color = electricBlue, double radius = 20, double spread = 2}) => [
    BoxShadow(color: color.withOpacity(0.3), blurRadius: radius, spreadRadius: spread),
    BoxShadow(color: color.withOpacity(0.15), blurRadius: radius * 2, spreadRadius: spread * 0.5),
  ];

  static List<BoxShadow> get glowBlue => glow(color: electricBlue);
  static List<BoxShadow> get glowGreen => glow(color: neonGreen);
  static List<BoxShadow> get glowRed => glow(color: sosRed, radius: 30, spread: 4);
  static List<BoxShadow> get glowPurple => glow(color: violet, radius: 24);

  static List<BoxShadow> get cardShadow => [
    BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 24, offset: const Offset(0, 8), spreadRadius: -4),
    BoxShadow(color: electricBlue.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4)),
  ];

  static List<BoxShadow> get cardShadowElevated => [
    BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 32, offset: const Offset(0, 12), spreadRadius: -8),
    BoxShadow(color: electricBlue.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 6)),
  ];

  // ═══════════════════════════════════════════════
  // GRADIENTS
  // ═══════════════════════════════════════════════
  static const Gradient bgGradient = LinearGradient(
    begin: Alignment.topCenter, end: Alignment.bottomCenter,
    colors: [Color(0xFF08080E), Color(0xFF050508)],
  );

  static const Gradient cardGradient = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [Color(0xFF141428), Color(0xFF0E0E1E)],
  );

  static const Gradient glassGradient = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [Color(0x18FFFFFF), Color(0x08FFFFFF)],
    stops: [0.0, 1.0],
  );

  static const Gradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [Color(0xFF0088FF), Color(0xFF00E5FF)],
  );

  static const Gradient sosGradient = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [Color(0xFFFF0030), Color(0xFFCC0030)],
  );

  static const Gradient greenGradient = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [Color(0xFF00FF88), Color(0xFF00CC66)],
  );

  static const Gradient purpleGradient = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
  );

  static const Gradient cyanGradient = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [Color(0xFF00E5FF), Color(0xFF0088FF)],
  );

  static const Gradient amberGradient = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [Color(0xFFFFB300), Color(0xFFFF6B00)],
  );

  static const Gradient sosBgGradient = LinearGradient(
    begin: Alignment.topCenter, end: Alignment.bottomCenter,
    colors: [Color(0xFF1A0508), Color(0xFF0E0508)],
  );

  static const Gradient scanningGradient = LinearGradient(
    begin: Alignment.topCenter, end: Alignment.bottomCenter,
    colors: [Color(0xFF0A1A0A), Color(0xFF050508)],
  );

  // Dynamic light theme toggle backing state
  static bool _isLight = false;
  static bool get isLight => _isLight;
  static void setLight(bool value) {
    _isLight = value;
  }
}
