import 'package:flutter/material.dart';
import 'aegis_colors.dart';

class AegisStyles {
  // ═══════════════════════════════════════════════
  // RADII
  // ═══════════════════════════════════════════════
  static const double radiusSm = 8.0;
  static const double radiusMd = 14.0;
  static const double radiusLg = 20.0;
  static const double radiusXl = 28.0;
  static const double radiusFull = 999.0;

  static final BorderRadius brSm = BorderRadius.circular(radiusSm);
  static final BorderRadius brMd = BorderRadius.circular(radiusMd);
  static final BorderRadius brLg = BorderRadius.circular(radiusLg);
  static final BorderRadius brXl = BorderRadius.circular(radiusXl);

  // ═══════════════════════════════════════════════
  // PADDING
  // ═══════════════════════════════════════════════
  static const EdgeInsets padH = EdgeInsets.symmetric(horizontal: 20.0);
  static const EdgeInsets padAll = EdgeInsets.all(20.0);
  static const EdgeInsets padCard = EdgeInsets.all(16.0);
  static const EdgeInsets padCardLg = EdgeInsets.all(20.0);

  // ═══════════════════════════════════════════════
  // TYPOGRAPHY
  // ═══════════════════════════════════════════════
  static TextStyle get hero => TextStyle(
    fontSize: 34, fontWeight: FontWeight.w800, color: AegisColors.textPrimary,
    letterSpacing: -1.0, height: 1.05,
  );

  static TextStyle get h1 => TextStyle(
    fontSize: 26, fontWeight: FontWeight.w800, color: AegisColors.textPrimary,
    letterSpacing: -0.6, height: 1.1,
  );

  static TextStyle get h2 => TextStyle(
    fontSize: 22, fontWeight: FontWeight.w800, color: AegisColors.textPrimary,
    letterSpacing: -0.4, height: 1.15,
  );

  static TextStyle get h3 => TextStyle(
    fontSize: 18, fontWeight: FontWeight.w700, color: AegisColors.textPrimary,
    letterSpacing: -0.2, height: 1.2,
  );

  static TextStyle get subtitle => TextStyle(
    fontSize: 13, fontWeight: FontWeight.w600, color: AegisColors.textSecondary,
    letterSpacing: 0.2, height: 1.3,
  );

  static TextStyle get body => TextStyle(
    fontSize: 14, fontWeight: FontWeight.w400, color: AegisColors.textPrimary,
    height: 1.5,
  );

  static TextStyle get bodySmall => TextStyle(
    fontSize: 13, fontWeight: FontWeight.w500, color: AegisColors.textSecondary,
    height: 1.4,
  );

  static TextStyle get caption => TextStyle(
    fontSize: 11, fontWeight: FontWeight.w500, color: AegisColors.textMuted,
    height: 1.3,
  );

  static TextStyle get overline => TextStyle(
    fontSize: 10, fontWeight: FontWeight.w700, color: AegisColors.textMuted,
    letterSpacing: 1.2, height: 1.2,
  );

  static TextStyle get label => TextStyle(
    fontSize: 16, fontWeight: FontWeight.w700, color: AegisColors.textPrimary,
    letterSpacing: -0.2,
  );

  static TextStyle get mono => TextStyle(
    fontFamily: 'monospace', fontSize: 13, fontWeight: FontWeight.w600,
    color: AegisColors.textSecondary, letterSpacing: 0.2,
  );

  static TextStyle get monoSmall => TextStyle(
    fontFamily: 'monospace', fontSize: 10, fontWeight: FontWeight.w500,
    color: AegisColors.textMuted,
  );

  static const TextStyle badge = TextStyle(
    fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white,
    letterSpacing: 0.5,
  );

  static TextStyle get message => TextStyle(
    fontSize: 15, fontWeight: FontWeight.w400, color: AegisColors.textPrimary,
    height: 1.4,
  );

  static TextStyle get timestamp => TextStyle(
    fontSize: 10, fontWeight: FontWeight.w500, color: AegisColors.textMuted,
    height: 1.2,
  );

  static const TextStyle button = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white,
    letterSpacing: 0.3,
  );

  // ═══════════════════════════════════════════════
  // COMMON BORDERS
  // ═══════════════════════════════════════════════
  static Border get border => Border.all(color: AegisColors.border1, width: 0.5);
  static Border get borderLight => Border.all(color: AegisColors.border2, width: 0.5);
}
