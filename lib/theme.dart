import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// The site's colour palette. Dark navy to match NairaTrack, with an
/// ocean-blue → cyan accent used for highlights and gradients.
class AppColors {
  static const bg = Color(0xFF05091A); // page background
  static const surface = Color(0xFF0E1430); // cards
  static const surfaceAlt = Color(0xFF141C3A); // raised cards / chips
  static const primary = Color(0xFF2196F3); // ocean blue (NairaTrack accent)
  static const accent = Color(0xFF22D3EE); // cyan

  static const textHigh = Color(0xFFF3F6FF);
  static const textMid = Color(0xFFB9C2DA);
  static const textLow = Color(0xFF7C86A2);
  static const border = Color(0x1AFFFFFF); // white @ 10%

  /// The signature accent gradient (buttons, headings, glows).
  static const accentGradient = LinearGradient(
    colors: [primary, accent],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

/// Builds the app's dark theme with the Inter font.
ThemeData buildTheme() {
  final base = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      surface: AppColors.surface,
    ),
    useMaterial3: true,
  );

  return base.copyWith(
    textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
      bodyColor: AppColors.textMid,
      displayColor: AppColors.textHigh,
    ),
  );
}
