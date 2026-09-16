import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Site colour palette. Original names (bg, primary, accent…) are kept so the
/// existing sections keep compiling; the new tokens below (bg900, cyan, blue…)
/// are the design-system names the redesigned sections use.
class AppColors {
  // ---- Legacy names (still used by About/Skills/Projects/Contact) ----
  static const bg = Color(0xFF05091A);
  static const surface = Color(0xFF0E1430);
  static const surfaceAlt = Color(0xFF141C3A);
  static const primary = Color(0xFF2196F3);
  static const accent = Color(0xFF22D3EE);
  static const textHigh = Color(0xFFF3F6FF);
  static const textLow = Color(0xFF7C86A2);

  static const accentGradient = LinearGradient(
    colors: [primary, accent],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // ---- Design-system tokens (new sections) ----
  static const bg900 = Color(0xFF060B18);
  static const bg850 = Color(0xFF071223);
  static const bg800 = Color(0xFF05101F);

  static const surface1 = Color(0x0BFFFFFF);
  static const surfaceHv = Color(0x18FFFFFF);
  static const border = Color(0x1FFFFFFF);
  static const borderSft = Color(0x12FFFFFF);
  static const divider = Color(0x2EFFFFFF);

  static const cyan = Color(0xFF22D3EE);
  static const cyanLt = Color(0xFF67E8F9);
  static const blue = Color(0xFF2F7BFF);
  static const blueDeep = Color(0xFF1E6BFF);
  static const blueLt = Color(0xFF5AA8FF);
  static const bluePale = Color(0xFFA9D4FF);
  static const sky = Color(0xFF4FC3F7);

  static const textHi = Color(0xFFFFFFFF);
  static const textMid = Color(0xFFC9D6E8);
  static const textMut = Color(0xFF93A4BF);
  static const textDim = Color(0xFF6B7C96);

  // ---- Section 2 (About) tokens ----
  static const emerald = Color(0xFF21E08D);
  static const emeraldDim = Color(0xFF15A868);
  static const emeraldEdge = Color(0x5921E08D);
  static const violet = Color(0xFF7C6AF0);
  static const violetDeep = Color(0xFF5B4BD6);
  static const violetIcon = Color(0xFFC4B5FD);
  static const iconBlue = Color(0xFF9FC8FF);
  static const cardFill = Color(0xFF0C1730);
  static const cardFillHi = Color(0xFF122344);
  static const waveBlue = Color(0xFF0E2E7A);
  static const waveEdge = Color(0xFF3B7FE8);
  static const waveTeal = Color(0xFF14C8C8);

  // ---- Section 3 (Skills) tokens ----
  static const eyebrowBlue = Color(0xFF8FB4FF);
  static const indigo = Color(0xFF4F46E5);
  static const teal = Color(0xFF14B8A6);
  static const tealBright = Color(0xFF2DD4BF);
  static const mintText = Color(0xFF7FE8C8);
  static const blueText = Color(0xFF6FB4FF);
  static const violetText = Color(0xFFC4A8FF);
  static const cardSurface = Color(0xFF0A1428);
  static const taglineTxt = Color(0xFF8FB8E8);
  static const taglineSlash = Color(0x593C96FF);
}

/// Signature gradients used across the site.
class AppGradients {
  static const name = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [AppColors.sky, AppColors.blue, AppColors.cyan],
    stops: [0, .48, 1],
  );
  static const btn = LinearGradient(
    begin: Alignment(-1, -.4),
    end: Alignment(1, .4),
    colors: [AppColors.blueDeep, Color(0xFF3B8CFF), AppColors.blue],
    stops: [0, .55, 1],
  );
  static const logo = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.blueLt, AppColors.cyan],
  );

  // ---- Section 2 (About) gradients ----
  static const card = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x14FFFFFF), Color(0x05FFFFFF)],
  );
  static const tileBlue = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2F7BFF), Color(0xFF1E5FE0)],
  );
  static const tileViolet = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF7C6AF0), Color(0xFF5B4BD6)],
  );
}

/// The app's dark theme. Website styling → no ink ripples anywhere.
ThemeData buildTheme() {
  final base = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bg900,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.blue,
      surface: AppColors.surface,
    ),
    useMaterial3: true,
    splashFactory: NoSplash.splashFactory,
  );

  return base.copyWith(
    textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
      bodyColor: AppColors.textMid,
      displayColor: AppColors.textHi,
    ),
  );
}
