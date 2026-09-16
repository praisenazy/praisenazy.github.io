import 'package:flutter/material.dart';

import '../theme.dart';

/// The layered glowing wave footer. [intensity] scales fill opacity + glow
/// blur; [crestOpacity] scales the bright edge strokes. A third thin crest is
/// added when [intensity] > 1.1. Defaults reproduce the Section 2 footer.
class WaveDividerPainter extends CustomPainter {
  const WaveDividerPainter({
    this.intensity = 1.0,
    this.crestOpacity = 0.75,
    this.fillTint,
  });

  final double intensity;
  final double crestOpacity;
  final Color? fillTint; // blended into the wave body (Contact screen only)

  double get _crestMul => (crestOpacity / 0.75);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final full = Offset.zero & size;

    Color fa(int rgb, double a) =>
        Color(rgb).withValues(alpha: (a * intensity).clamp(0.0, 1.0));

    // (a) Deep wave.
    final aTop = Path()
      ..moveTo(-20, h * 0.22)
      ..cubicTo(w * 0.12, h * 0.20, w * 0.24, h * 0.52, w * 0.40, h * 0.50)
      ..cubicTo(w * 0.60, h * 0.47, w * 0.78, h * 0.66, w + 20, h * 0.78);
    final aFill = Path.from(aTop)..lineTo(w + 20, h + 20)..lineTo(-20, h + 20)..close();
    canvas.drawPath(
      aFill,
      Paint()
        ..isAntiAlias = true
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [fa(0xFF0A1F52, 0.85), fa(0xFF071634, 0.85)],
        ).createShader(full),
    );

    // (b) Mid wave.
    final bTop = Path()
      ..moveTo(-20, h * 0.34)
      ..cubicTo(w * 0.06, h * 0.10, w * 0.16, h * 0.06, w * 0.30, h * 0.24)
      ..cubicTo(w * 0.55, h * 0.52, w * 0.82, h * 0.72, w + 20, h * 0.96);
    final bFill = Path.from(bTop)..lineTo(w + 20, h + 20)..lineTo(-20, h + 20)..close();
    var b1 = fa(0xFF0E2E7A, 0.85), b2 = fa(0xFF071A44, 0.9);
    if (fillTint != null) {
      b1 = Color.lerp(b1, fillTint!.withValues(alpha: b1.a), 0.35)!;
      b2 = Color.lerp(b2, fillTint!.withValues(alpha: b2.a), 0.35)!;
    }
    canvas.drawPath(
      bFill,
      Paint()
        ..isAntiAlias = true
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [b1, b2],
        ).createShader(full),
    );

    // (c) Crest line + glow on wave (b).
    canvas.drawPath(
      bTop,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..color = AppColors.waveEdge.withValues(alpha: (0.45 * _crestMul).clamp(0.0, 1.0))
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10 * intensity),
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

    // (b2) Optional third, thinner crest (Skills screen only).
    if (intensity > 1.1) {
      final cTop = Path()
        ..moveTo(-20, h * 0.12)
        ..cubicTo(w * 0.14, h * -0.06, w * 0.26, h * -0.02, w * 0.42, h * 0.20)
        ..cubicTo(w * 0.52, h * 0.34, w * 0.58, h * 0.44, w + 20, h * 0.62);
      canvas.drawPath(
        cTop,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5
          ..color = AppColors.waveEdge.withValues(alpha: (0.30 * _crestMul).clamp(0.0, 1.0))
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9),
      );
      canvas.drawPath(
        cTop,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color = AppColors.waveEdge.withValues(alpha: (0.55 * _crestMul).clamp(0.0, 1.0))
          ..isAntiAlias = true,
      );
    }

    // (d) Teal corner wave.
    final dTop = Path()
      ..moveTo(w + 20, h * 0.55)
      ..cubicTo(w * 0.92, h * 0.72, w * 0.80, h * 0.86, w * 0.66, h + 20);
    final dFill = Path.from(dTop)..lineTo(w + 20, h + 20)..close();
    canvas.drawPath(
      dFill,
      Paint()
        ..isAntiAlias = true
        ..shader = RadialGradient(
          center: const Alignment(1, 1),
          radius: 1.0,
          colors: [AppColors.waveTeal.withValues(alpha: 0.22 * intensity), AppColors.waveTeal.withValues(alpha: 0.0)],
          stops: const [0, 0.75],
        ).createShader(full),
    );
    canvas.drawPath(
      dTop,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..color = AppColors.waveTeal.withValues(alpha: (0.35 * _crestMul).clamp(0.0, 1.0))
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 9 * intensity),
    );
    canvas.drawPath(
      dTop,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = AppColors.waveTeal.withValues(alpha: (0.75 * _crestMul).clamp(0.0, 1.0))
        ..isAntiAlias = true,
    );
  }

  @override
  bool shouldRepaint(WaveDividerPainter old) =>
      old.intensity != intensity ||
      old.crestOpacity != crestOpacity ||
      old.fillTint != fillTint;
}
