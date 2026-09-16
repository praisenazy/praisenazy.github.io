import 'package:flutter/material.dart';

/// Three stacked plates (layers), filled, top-brightest. viewBox 24.
class LayersIcon extends StatelessWidget {
  const LayersIcon({super.key, this.size = 30, required this.color});
  final double size;
  final Color color;
  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _LayersPainter(color));
}

class _LayersPainter extends CustomPainter {
  _LayersPainter(this.color);
  final Color color;

  Path _plate(double cy) => Path()
    ..moveTo(12, cy - 4.5)
    ..lineTo(20.5, cy)
    ..lineTo(12, cy + 4.5)
    ..lineTo(3.5, cy)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 24);
    canvas.drawPath(_plate(17), Paint()..color = color.withValues(alpha: 0.45)..isAntiAlias = true);
    canvas.drawPath(_plate(12.5), Paint()..color = color.withValues(alpha: 0.7)..isAntiAlias = true);
    canvas.drawPath(_plate(8), Paint()..color = color..isAntiAlias = true);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_LayersPainter old) => old.color != color;
}
