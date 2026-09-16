import 'package:flutter/material.dart';

/// Filled lightning bolt (viewBox 24), with an optional soft glow.
class BoltIcon extends StatelessWidget {
  const BoltIcon({super.key, this.size = 26, required this.color, this.glow = true});
  final double size;
  final Color color;
  final bool glow;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _BoltPainter(color, glow));
}

class _BoltPainter extends CustomPainter {
  _BoltPainter(this.color, this.glow);
  final Color color;
  final bool glow;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 24);
    final bolt = Path()
      ..moveTo(13, 2)
      ..lineTo(4, 13.5)
      ..lineTo(10.5, 13.5)
      ..lineTo(10, 22)
      ..lineTo(20, 9.5)
      ..lineTo(13, 9.5)
      ..close();
    if (glow) {
      canvas.drawPath(
        bolt,
        Paint()
          ..color = color.withValues(alpha: 0.55)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );
    }
    canvas.drawPath(bolt, Paint()..color = color..isAntiAlias = true);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_BoltPainter old) => old.color != color || old.glow != glow;
}
