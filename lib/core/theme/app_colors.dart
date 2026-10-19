import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF1857FF);
  static const Color primaryDark = Color(0xFF0F3FC7);
  static const Color secondary = Color(0xFF00C2A8);
  static const Color accent = Color(0xFFFFB020);

  // Semantic
  static const Color success = Color(0xFF1FAA59);
  static const Color danger = Color(0xFFE84C4C);
  static const Color warning = Color(0xFFFFB020);

  // Neutrals - light
  static const Color background = Color(0xFFF5F7FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF15192E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color border = Color(0xFFE5E9F2);

  // Neutrals - dark
  static const Color backgroundDark = Color(0xFF0E1120);
  static const Color surfaceDark = Color(0xFF171B2E);
  static const Color textPrimaryDark = Color(0xFFF3F5FA);
  static const Color textSecondaryDark = Color(0xFFA0A6BC);
  static const Color borderDark = Color(0xFF2A2F45);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
