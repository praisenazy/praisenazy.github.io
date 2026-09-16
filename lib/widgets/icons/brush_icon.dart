import 'package:flutter/material.dart';

/// Angled paintbrush. viewBox 24.
class BrushIcon extends StatelessWidget {
  const BrushIcon({super.key, this.size = 30, required this.color});
  final double size;
  final Color color;
  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _BrushPainter(color));
}

class _BrushPainter extends CustomPainter {
  _BrushPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 24);
    final fill = Paint()..color = color..isAntiAlias = true;
    final soft = Paint()..color = color.withValues(alpha: 0.6)..isAntiAlias = true;

    // Handle (rotated rounded bar, top-right to middle).
    canvas.save();
    canvas.translate(15.5, 8.5);
    canvas.rotate(0.79); // ~45°
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(-2, -8.5, 4, 11), const Radius.circular(2)), fill);
    canvas.restore();

    // Ferrule + brush head (bottom-left).
    final head = Path()
      ..moveTo(9.5, 12.5)
      ..lineTo(12.5, 15.5)
      ..lineTo(8.5, 19)
      ..cubicTo(6.5, 21, 3.5, 21, 3.2, 20.7)
      ..cubicTo(3.0, 18.5, 4.5, 15.8, 6.2, 14.2)
      ..close();
    canvas.drawPath(head, soft);
    canvas.drawCircle(const Offset(5.2, 18.6), 1.1, Paint()..color = const Color(0x66000000));
    canvas.restore();
  }

  @override
  bool shouldRepaint(_BrushPainter old) => old.color != color;
}
