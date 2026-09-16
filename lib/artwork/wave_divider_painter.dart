import 'package:flutter/material.dart';

import '../theme.dart';

/// The four-layer glowing wave footer. All control points are fractional so it
/// scales with the section; the waves bleed past every edge (clip externally).
class WaveDividerPainter extends CustomPainter {
  const WaveDividerPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final full = Offset.zero & size;

    // (a) Deep wave.
    final aTop = Path()
      ..moveTo(-20, h * 0.22)
      ..cubicTo(w * 0.12, h * 0.20, w * 0.24, h * 0.52, w * 0.40, h * 0.50)
      ..cubicTo(w * 0.60, h * 0.47, w * 0.78, h * 0.66, w + 20, h * 0.78);
    final aFill = Path.from(aTop)
      ..lineTo(w + 20, h + 20)
      ..lineTo(-20, h + 20)
      ..close();
    canvas.drawPath(
      aFill,
      Paint()
        ..isAntiAlias = true
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xD90A1F52), Color(0xD9071634)],
        ).createShader(full),
    );

    // (b) Mid wave.
    final bTop = Path()
      ..moveTo(-20, h * 0.34)
      ..cubicTo(w * 0.06, h * 0.10, w * 0.16, h * 0.06, w * 0.30, h * 0.24)
      ..cubicTo(w * 0.55, h * 0.52, w * 0.82, h * 0.72, w + 20, h * 0.96);
    final bFill = Path.from(bTop)
      ..lineTo(w + 20, h + 20)
      ..lineTo(-20, h + 20)
      ..close();
    canvas.drawPath(
      bFill,
      Paint()
        ..isAntiAlias = true
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xD90E2E7A), Color(0xE6071A44)],
        ).createShader(full),
    );

    // (c) Crest line + glow on wave (b).
    canvas.drawPath(
      bTop,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..color = AppColors.waveEdge.withValues(alpha: 0.45)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );
    canvas.drawPath(
      bTop,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..color = AppColors.waveEdge
        ..isAntiAlias = true,
    );

    // (d) Teal corner wave (right third).
    final dTop = Path()
      ..moveTo(w + 20, h * 0.55)
      ..cubicTo(w * 0.92, h * 0.72, w * 0.80, h * 0.86, w * 0.66, h + 20);
    final dFill = Path.from(dTop)
      ..lineTo(w + 20, h + 20)
      ..close();
    canvas.drawPath(
      dFill,
      Paint()
        ..isAntiAlias = true
        ..shader = RadialGradient(
          center: const Alignment(1, 1),
          radius: 1.0,
          colors: [AppColors.waveTeal.withValues(alpha: 0.22), AppColors.waveTeal.withValues(alpha: 0.0)],
          stops: const [0, 0.75],
        ).createShader(full),
    );
    canvas.drawPath(
      dTop,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..color = AppColors.waveTeal.withValues(alpha: 0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9),
    );
    canvas.drawPath(
      dTop,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = AppColors.waveTeal.withValues(alpha: 0.75)
        ..isAntiAlias = true,
    );
  }

  @override
  bool shouldRepaint(WaveDividerPainter old) => false;
}
