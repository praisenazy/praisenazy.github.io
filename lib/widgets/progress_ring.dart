import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../theme.dart';
import '../theme/app_text.dart';

/// Circular progress ring with a glowing emerald sweep and a centred label.
class ProgressRing extends StatelessWidget {
  const ProgressRing({
    super.key,
    this.size = 68,
    required this.progress,
    required this.label,
  });

  final double size;
  final double progress; // 0..1
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _RingPainter(progress),
        child: Center(
          child: Text(
            label,
            style: AppText.nav.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.emerald,
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.progress);
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final inset = rect.deflate(4);
    // track
    canvas.drawArc(
      inset, 0, 2 * math.pi, false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..color = AppColors.emeraldDim.withValues(alpha: 0.28),
    );
    final sweep = 2 * math.pi * progress.clamp(0.0, 1.0);
    // glow pass
    canvas.drawArc(
      inset, -math.pi / 2, sweep, false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round
        ..color = AppColors.emerald.withValues(alpha: 0.55)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    // solid arc
    canvas.drawArc(
      inset, -math.pi / 2, sweep, false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round
        ..color = AppColors.emerald
        ..isAntiAlias = true,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}
