import 'dart:math' as math;
import 'package:flutter/material.dart';

enum RingHalf { back, front }

/// Two tilted orbital rings with travelling glow dots. Painted in two passes:
/// the [RingHalf.back] pass (below the orb) clips to the top half of the canvas,
/// the [RingHalf.front] pass (above the orb) clips to the bottom half — so each
/// ring reads as passing behind the orb at the top and in front at the bottom.
class OrbitRingsPainter extends CustomPainter {
  OrbitRingsPainter({required this.progress, required this.half});
  final double progress;
  final RingHalf half;

  @override
  void paint(Canvas canvas, Size size) {
    final clip = half == RingHalf.back
        ? Rect.fromLTWH(0, 0, size.width, size.height / 2)
        : Rect.fromLTWH(0, size.height / 2, size.width, size.height / 2);
    canvas.save();
    canvas.clipRect(clip);
    final r = size.width / 2;
    _ring(canvas, size, rx: .90 * r, ry: .34 * r, tilt: -0.384,
        color: const Color(0xBF78DCFF), width: 1.6, dotP: progress);
    _ring(canvas, size, rx: .85 * r, ry: .40 * r, tilt: 1.117,
        color: const Color(0x8C5ABEFF), width: 1.4, dotP: (progress * 22 / 14) % 1);
    canvas.restore();
  }

  void _ring(Canvas canvas, Size size,
      {required double rx,
      required double ry,
      required double tilt,
      required Color color,
      required double width,
      required double dotP}) {
    final c = size.center(Offset.zero);
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(tilt);

    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: rx * 2, height: ry * 2),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = width
        ..color = color
        ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 3)
        ..isAntiAlias = true,
    );

    // Travelling dot.
    final theta = 2 * math.pi * dotP;
    final dot = Offset(rx * math.cos(theta), ry * math.sin(theta));
    // Screen-space y to decide which half currently owns the dot.
    final sy = c.dy + dot.dx * math.sin(tilt) + dot.dy * math.cos(tilt);
    final inHalf = half == RingHalf.back ? sy <= c.dy : sy >= c.dy;
    if (inHalf) {
      canvas.drawCircle(dot, 9,
          Paint()..color = const Color(0xFF22D3EE).withValues(alpha: 0.5)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6));
      canvas.drawCircle(dot, 5, Paint()..color = const Color(0xFF22D3EE)..isAntiAlias = true);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(OrbitRingsPainter old) => old.progress != progress || old.half != half;
}
