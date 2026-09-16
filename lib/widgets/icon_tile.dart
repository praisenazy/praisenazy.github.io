import 'package:flutter/material.dart';

/// A 72×72 rounded gradient tile holding a glyph, with a soft coloured glow.
class IconTile extends StatelessWidget {
  const IconTile({
    super.key,
    required this.gradient,
    required this.glow,
    required this.child,
    this.dimension = 72,
  });

  final Gradient gradient;
  final Color glow;
  final Widget child;
  final double dimension;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: dimension,
      height: dimension,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0x1FFFFFFF)),
        boxShadow: [
          BoxShadow(
            color: glow.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}
