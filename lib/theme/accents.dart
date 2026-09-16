import 'package:flutter/widgets.dart';

import '../theme.dart';

/// The three colour families used across the Skills screen.
enum Accent { blue, teal, violet }

class AccentSpec {
  const AccentSpec({
    required this.tile,
    required this.chipFill,
    required this.chipEdge,
    required this.chipText,
    required this.glow,
  });
  final Gradient tile;
  final Color chipFill;
  final Color chipEdge;
  final Color chipText;
  final Color glow;
}

const _blue = AccentSpec(
  tile: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF3B82F6), Color(0xFF4F46E5)],
  ),
  chipFill: Color(0x2E2F7BFF),
  chipEdge: Color(0x4D5AA8FF),
  chipText: AppColors.blueText,
  glow: Color(0x593B82F6),
);

const _teal = AccentSpec(
  tile: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF115E59), Color(0xFF0D9488)],
  ),
  chipFill: Color(0x2E14B8A6),
  chipEdge: Color(0x4D2DD4BF),
  chipText: AppColors.mintText,
  glow: Color(0x4714B8A6),
);

const _violet = AccentSpec(
  tile: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF8B5CF6), Color(0xFF6D4AEA)],
  ),
  chipFill: Color(0x2E7C6AF0),
  chipEdge: Color(0x4DA78BFA),
  chipText: AppColors.violetText,
  glow: Color(0x597C6AF0),
);

AccentSpec accentSpec(Accent a) => switch (a) {
      Accent.blue => _blue,
      Accent.teal => _teal,
      Accent.violet => _violet,
    };
