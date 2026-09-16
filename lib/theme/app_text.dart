import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme.dart';

/// Typographic scale. Archivo for headings/logo/buttons, Inter for everything
/// else. Later sections reuse h2/h3/chip.
abstract class AppText {
  static TextStyle get h1 => GoogleFonts.archivo(
        fontWeight: FontWeight.w800,
        height: 0.97,
        letterSpacing: -2.0,
        color: AppColors.textHi,
      );

  static TextStyle get mono => GoogleFonts.archivo(
        fontWeight: FontWeight.w800,
        letterSpacing: -2.2,
        height: 1,
      );

  static TextStyle get wordmark => GoogleFonts.archivo(
        fontWeight: FontWeight.w700,
        fontSize: 22,
        letterSpacing: -0.2,
        color: AppColors.textHi,
      );

  static TextStyle get subhead => GoogleFonts.inter(
        fontWeight: FontWeight.w500,
        height: 1.34,
        color: AppColors.textHi,
      );

  static TextStyle get body => GoogleFonts.inter(
        fontWeight: FontWeight.w400,
        fontSize: 17.5,
        height: 1.64,
        color: AppColors.textMut,
      );

  static TextStyle get nav => GoogleFonts.inter(
        fontWeight: FontWeight.w500,
        fontSize: 15.5,
      );

  static TextStyle get eyebrow => GoogleFonts.inter(
        fontWeight: FontWeight.w600,
        fontSize: 13.5,
        letterSpacing: 3.0,
        color: AppColors.cyan,
      );

  static TextStyle get button => GoogleFonts.inter(
        fontWeight: FontWeight.w600,
        fontSize: 17,
      );

  // Defined for later sections (not used yet).
  static TextStyle get h2 => GoogleFonts.archivo(
        fontWeight: FontWeight.w800,
        height: 1.05,
        letterSpacing: -1.1,
        color: AppColors.textHi,
      );

  static TextStyle get h3 => GoogleFonts.archivo(
        fontWeight: FontWeight.w700,
        fontSize: 22,
        height: 1.25,
        letterSpacing: -0.2,
        color: AppColors.textHi,
      );

  static TextStyle get chip => GoogleFonts.inter(
        fontWeight: FontWeight.w500,
        fontSize: 15,
        color: AppColors.textMid,
      );
}
