import 'package:flutter/material.dart';

import '../../theme.dart';

/// LinkedIn mark: a filled rounded square with the "in" wordmark knocked out.
class LinkedInIcon extends StatelessWidget {
  const LinkedInIcon({super.key, this.size = 22, this.square = Colors.white, this.knockout});
  final double size;
  final Color square;
  final Color? knockout;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _LiPainter(square, knockout ?? AppColors.ghostFill));
}

class _LiPainter extends CustomPainter {
  _LiPainter(this.square, this.knockout);
  final Color square;
  final Color knockout;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 24);
    // rounded square
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(1, 1, 22, 22), const Radius.circular(4)),
      Paint()..color = square..isAntiAlias = true,
    );
    final ink = Paint()..color = knockout..isAntiAlias = true;
    // "i" dot + stem
    canvas.drawCircle(const Offset(6.5, 7), 1.7, ink);
    canvas.drawRect(const Rect.fromLTWH(5, 10, 3, 8.5), ink);
    // "n"
    final n = Path()
      ..moveTo(10, 18.5)
      ..lineTo(10, 10)
      ..lineTo(13, 10)
      ..lineTo(13, 11)
      ..cubicTo(14, 9.6, 16.2, 9.4, 17.6, 10.6)
      ..cubicTo(18.6, 11.5, 18.7, 12.9, 18.7, 14.2)
      ..lineTo(18.7, 18.5)
      ..lineTo(15.7, 18.5)
      ..lineTo(15.7, 14.4)
      ..cubicTo(15.7, 13.4, 15.6, 12.4, 14.4, 12.4)
      ..cubicTo(13.2, 12.4, 13, 13.5, 13, 14.5)
      ..lineTo(13, 18.5)
      ..close();
    canvas.drawPath(n, ink);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_LiPainter old) => old.square != square || old.knockout != knockout;
}
