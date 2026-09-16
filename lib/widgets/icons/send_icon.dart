import 'package:flutter/material.dart';

/// Paper-plane / send (viewBox 24), stroke, naturally tilted.
class SendIcon extends StatelessWidget {
  const SendIcon({super.key, this.size = 30, this.stroke = 2, required this.color});
  final double size;
  final double stroke;
  final Color color;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _SendPainter(color, stroke));
}

class _SendPainter extends CustomPainter {
  _SendPainter(this.color, this.stroke);
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
    final outline = Path()
      ..moveTo(3, 11)
      ..lineTo(21, 3)
      ..lineTo(13.5, 21)
      ..lineTo(11, 13)
      ..close();
    canvas.drawPath(outline, p);
    canvas.drawLine(const Offset(21, 3), const Offset(11, 13), p);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_SendPainter old) => old.color != color;
}
