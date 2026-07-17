import 'package:flutter/material.dart';
import 'aegis_colors_light.dart';

class AegisColors {
  static bool _isLight = false;
  static bool get isLight => _isLight;
  static void setLight(bool value) {
    _isLight = value;
  }

  static Color _c(Color dark, Color light) => _isLight ? light : dark;

  // ═══════════════════════════════════════════════
  // PRIMARY ACCENTS (same in both themes)
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
  // SURFACE COLORS
  // ═══════════════════════════════════════════════
  static Color get background => _c(const Color(0xFF050508), AegisColorsLight.background);
  static Color get surface0 => _c(const Color(0xFF08080E), AegisColorsLight.surface0);
  static Color get surface1 => _c(const Color(0xFF0C0C16), AegisColorsLight.surface1);
  static Color get surface2 => _c(const Color(0xFF111122), AegisColorsLight.surface2);
  static Color get cardBg => _c(const Color(0xFF0E0E1E), AegisColorsLight.cardBg);
  static Color get cardBgAlt => _c(const Color(0xFF141428), AegisColorsLight.cardBgAlt);
  static Color get elevated => _c(const Color(0xFF1A1A34), AegisColorsLight.elevated);
  static Color get glassBg => const Color(0x14FFFFFF);
  static Color get glassBorder => const Color(0x22FFFFFF);

  // ═══════════════════════════════════════════════
  // BORDERS
  // ═══════════════════════════════════════════════
  static Color get border1 => _c(const Color(0xFF1E1E3A), AegisColorsLight.border1);
  static Color get border2 => _c(const Color(0xFF2A2A4A), AegisColorsLight.border2);
  static Color get borderLight => _c(const Color(0xFF3A3A5A), AegisColorsLight.borderLight);

  // ═══════════════════════════════════════════════
  // TEXT
  // ═══════════════════════════════════════════════
  static Color get textPrimary => _c(const Color(0xFFF0F0FF), AegisColorsLight.textPrimary);
  static Color get textSecondary => _c(const Color(0xFF8888AA), AegisColorsLight.textSecondary);
  static Color get textMuted => _c(const Color(0xFF55557A), AegisColorsLight.textMuted);
  static Color get textDim => _c(const Color(0xFF33335A), AegisColorsLight.textDim);

  // ═══════════════════════════════════════════════
  // STATUS (same in both themes)
  // ═══════════════════════════════════════════════
  static const Color safe = Color(0xFF00FF88);
  static const Color sosRed = Color(0xFFFF0030);
  static const Color warning = Color(0xFFFFB300);
  static const Color relay = Color(0xFFA855F7);

  // ═══════════════════════════════════════════════
  // GLOWS SHADOWS
  // ═══════════════════════════════════════════════
  static List<BoxShadow> glow({Color color = electricBlue, double radius = 20, double spread = 2}) => [
    BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: radius, spreadRadius: spread),
    BoxShadow(color: color.withValues(alpha: 0.15), blurRadius: radius * 2, spreadRadius: spread * 0.5),
  ];

  static List<BoxShadow> get glowBlue => glow(color: electricBlue);
  static List<BoxShadow> get glowGreen => glow(color: neonGreen);
  static List<BoxShadow> get glowRed => glow(color: sosRed, radius: 30, spread: 4);
  static List<BoxShadow> get glowPurple => glow(color: violet, radius: 24);

  static List<BoxShadow> get cardShadow => _isLight
      ? AegisColorsLight.cardShadow
      : [
          BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 24, offset: const Offset(0, 8), spreadRadius: -4),
          BoxShadow(color: electricBlue.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4)),
        ];

  static List<BoxShadow> get cardShadowElevated => _isLight
      ? AegisColorsLight.cardShadowElevated
      : [
          BoxShadow(color: Colors.black.withValues(alpha: 0.6), blurRadius: 32, offset: const Offset(0, 12), spreadRadius: -8),
          BoxShadow(color: electricBlue.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 6)),
        ];

  // ═══════════════════════════════════════════════
  // GRADIENTS
  // ═══════════════════════════════════════════════
  static Gradient get bgGradient => _isLight
      ? AegisColorsLight.bgGradient
      : const LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [Color(0xFF08080E), Color(0xFF050508)],
        );

  static Gradient get cardGradient => _isLight
      ? AegisColorsLight.cardGradient
      : const LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [Color(0xFF141428), Color(0xFF0E0E1E)],
        );

  static Gradient get glassGradient => _isLight
      ? AegisColorsLight.glassGradient
      : const LinearGradient(
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

  static Gradient get sosBgGradient => _isLight
      ? AegisColorsLight.sosBgGradient
      : const LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [Color(0xFF1A0508), Color(0xFF0E0508)],
        );

  static Gradient get scanningGradient => _isLight
      ? AegisColorsLight.scanningGradient
      : const LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [Color(0xFF0A1A0A), Color(0xFF050508)],
        );
}
