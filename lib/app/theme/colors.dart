import 'package:flutter/material.dart';

/// Brand palette — TurboDex
class TdxColors {
  static const textPrimary = Color(0xFF000000);
  static Color get textSecondary => textPrimary.withOpacity(0.65);

  // Brand
  static const red = Color(0xFFCC0605);
  static const offWhite = Color(0xFFF5F3ED);
  static const black = Color(0xFF000000);

  // Feedback
  static const success = Color(0xFF2ECC71);
  static const warning = Color(0xFFF39C12);
  static const error = Color(0xFFE74C3C);


  // Neutrals (dérivés pour offWhite)
  static const neutral700 = Color(0xFF2A2A2A);
  static const neutral600 = Color(0xFF4D4D4D);
  static const neutral400 = Color(0xFF9C9C9C);
  static const neutral300 = Color(0xFFCBC7C0);
  static const neutral200 = Color(0xFFE8E6E0); // borders/dividers
  static const neutral100 = Color(0xFFF7F6F2); // subtle fills
}
