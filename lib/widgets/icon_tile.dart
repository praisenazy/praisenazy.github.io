import 'package:flutter/material.dart';

/// A rounded gradient tile holding a glyph, with a soft coloured glow.
class IconTile extends StatelessWidget {
  const IconTile({
    super.key,
    required this.gradient,
    required this.glow,
    required this.child,
    this.size = 72,
    this.radius = 18,
  });

  final Gradient gradient;
  final Color glow;
  final Widget child;
  final double size;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius),
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
