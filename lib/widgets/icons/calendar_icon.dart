import 'package:flutter/material.dart';

/// Outlined calendar (viewBox 24), stroke.
class CalendarIcon extends StatelessWidget {
  const CalendarIcon({super.key, this.size = 30, this.stroke = 2, required this.color});
  final double size;
  final double stroke;
  final Color color;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _CalendarPainter(color, stroke));
}

class _CalendarPainter extends CustomPainter {
  _CalendarPainter(this.color, this.stroke);
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
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(3, 5, 18, 16), const Radius.circular(2.5)), p);
    canvas.drawLine(const Offset(3, 9.5), const Offset(21, 9.5), p);
    canvas.drawLine(const Offset(7.5, 3), const Offset(7.5, 6.5), p);
    canvas.drawLine(const Offset(16.5, 3), const Offset(16.5, 6.5), p);
    final dot = Paint()..color = color..isAntiAlias = true;
    canvas.drawCircle(const Offset(8, 14), 1.1, dot);
    canvas.drawCircle(const Offset(12, 14), 1.1, dot);
    canvas.drawCircle(const Offset(16, 14), 1.1, dot);
    canvas.drawCircle(const Offset(8, 17.5), 1.1, dot);
    canvas.drawCircle(const Offset(12, 17.5), 1.1, dot);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_CalendarPainter old) => old.color != color;
}
