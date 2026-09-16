import 'package:flutter/material.dart';

/// Cylinder database with two bands, stroked. viewBox 24.
class DatabaseIcon extends StatelessWidget {
  const DatabaseIcon({super.key, this.size = 30, this.stroke = 2, required this.color});
  final double size;
  final double stroke;
  final Color color;
  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _DbPainter(color, stroke));
}

class _DbPainter extends CustomPainter {
  _DbPainter(this.color, this.stroke);
  final Color color;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 24);
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;
    const rx = 8.0, cx = 12.0;
    // top ellipse
    canvas.drawOval(Rect.fromCenter(center: const Offset(cx, 5.5), width: rx * 2, height: 5), p);
    // left & right walls
    canvas.drawLine(const Offset(cx - rx, 5.5), const Offset(cx - rx, 18.5), p);
    canvas.drawLine(const Offset(cx + rx, 5.5), const Offset(cx + rx, 18.5), p);
    // bottom curve
    canvas.drawArc(Rect.fromCenter(center: const Offset(cx, 18.5), width: rx * 2, height: 5), 0, 3.14159, false, p);
    // two band curves
    canvas.drawArc(Rect.fromCenter(center: const Offset(cx, 10), width: rx * 2, height: 5), 0, 3.14159, false, p);
    canvas.drawArc(Rect.fromCenter(center: const Offset(cx, 14.2), width: rx * 2, height: 5), 0, 3.14159, false, p);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_DbPainter old) => old.color != color;
}
