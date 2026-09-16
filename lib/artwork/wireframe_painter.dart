import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Faint rotating wireframe: a hexagon + a 45°-rotated square (diamond).
class WireframePainter extends CustomPainter {
  const WireframePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = const Color(0x24A0C8FF)
      ..isAntiAlias = true;

    final rHex = size.width * 0.46;
    final hex = Path();
    for (var i = 0; i < 6; i++) {
      final a = math.pi / 180 * (60 * i - 30);
      final pt = Offset(c.dx + rHex * math.cos(a), c.dy + rHex * math.sin(a));
      i == 0 ? hex.moveTo(pt.dx, pt.dy) : hex.lineTo(pt.dx, pt.dy);
    }
    hex.close();
    canvas.drawPath(hex, p);

    final d = size.width * 0.40; // half-diagonal of the diamond
    final dia = Path()
      ..moveTo(c.dx, c.dy - d)
      ..lineTo(c.dx + d, c.dy)
      ..lineTo(c.dx, c.dy + d)
      ..lineTo(c.dx - d, c.dy)
      ..close();
    canvas.drawPath(dia, p);
  }

  @override
  bool shouldRepaint(WireframePainter old) => false;
}
