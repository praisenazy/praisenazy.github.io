import 'package:flutter/material.dart';

/// Crossed wrench + screwdriver. viewBox 24.
class ToolsIcon extends StatelessWidget {
  const ToolsIcon({super.key, this.size = 30, required this.color});
  final double size;
  final Color color;
  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _ToolsPainter(color));
}

class _ToolsPainter extends CustomPainter {
  _ToolsPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 24);
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    // Screwdriver shaft (top-left → bottom-right).
    canvas.drawLine(const Offset(5, 5), const Offset(18, 18.5), p);
    // Screwdriver handle (thicker cap top-left).
    canvas.drawLine(const Offset(4, 4), const Offset(6.5, 6.5),
        Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 4.4..strokeCap = StrokeCap.round);

    // Wrench shaft (top-right → bottom-left).
    canvas.drawLine(const Offset(19, 5.5), const Offset(7, 17.5), p);
    // Wrench open head (top-right).
    final head = Path()
      ..moveTo(20.5, 4)
      ..lineTo(18.2, 4.2)
      ..lineTo(17.5, 6.4)
      ..lineTo(19.2, 8.1)
      ..lineTo(21.4, 7.4)
      ..lineTo(21.6, 5.1);
    canvas.drawPath(head, p);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_ToolsPainter old) => old.color != color;
}
