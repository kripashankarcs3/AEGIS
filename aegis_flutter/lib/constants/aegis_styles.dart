import 'package:flutter/material.dart';
import 'aegis_colors.dart';

class AegisStyles {
  static const double cardRadius = 12.0;
  static const double buttonRadius = 24.0;
  
  static const EdgeInsets screenPadding = EdgeInsets.all(16.0);
  static const EdgeInsets cardPadding = EdgeInsets.all(12.0);
  
  static final BorderRadius cardBorderRadius = BorderRadius.circular(cardRadius);
  static final BorderRadius buttonBorderRadius = BorderRadius.circular(buttonRadius);
  
  static final BoxBorder cardBorder = Border.all(
    color: AegisColors.border,
    width: 1.0,
  );
  
  static final List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.2),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];
  
  static final List<BoxShadow> tightShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static const TextStyle headerTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AegisColors.textPrimary,
    letterSpacing: -0.5,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AegisColors.textPrimary,
  );

  static const TextStyle bodyBold = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AegisColors.textPrimary,
  );

  static const TextStyle bodyNormal = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AegisColors.textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: AegisColors.textMuted,
  );
  
  static const TextStyle captionBold = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: AegisColors.textSecondary,
  );
}
