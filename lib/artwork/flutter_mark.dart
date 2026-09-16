import 'package:flutter/material.dart';

import '../widgets/site_icons.dart' show parseSvgPath;

/// The Flutter chevron, shaded top-light → bottom-dark, with a blue glow.
class FlutterMark extends StatelessWidget {
  const FlutterMark({super.key, this.size = 86});
  final double size;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _FlutterPainter());
}

class _FlutterPainter extends CustomPainter {
  static const _d =
      'M14.314 0L2.3 12 6 15.7 21.684.013h-7.37zm.014 11.072L7.857 17.53l3.715 3.715 3.717-3.717 6.4-6.457h-7.37z';
  static final Path _raw = parseSvgPath(_d);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 24);
    final rect = _raw.getBounds();

    // Glow behind.
    canvas.drawPath(
      _raw,
      Paint()
        ..color = const Color(0xBF3CA0FF)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    // Shaded fill.
    canvas.drawPath(
      _raw,
      Paint()
        ..isAntiAlias = true
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF54C5F8), Color(0xFF1E88E5), Color(0xFF1565C0)],
          stops: [0, .5, 1],
        ).createShader(rect),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_FlutterPainter old) => false;
}
