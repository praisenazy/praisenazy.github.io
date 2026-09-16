import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Scattered glowing node dots with a few connecting lines; three nodes twinkle.
class NodeWebPainter extends CustomPainter {
  NodeWebPainter({required this.twinkle});

  /// 0..1 progress of the shared twinkle controller.
  final double twinkle;

  static const _pts = <Offset>[
    Offset(.86, .18),
    Offset(.97, .30),
    Offset(.96, .54),
    Offset(.62, .79),
    Offset(.78, .86),
    Offset(.06, .42),
    Offset(.18, .64),
  ];
  // Which nodes twinkle, and their phase offsets.
  static const _twinklers = {0: 0.0, 2: 0.35, 4: 0.7};
  static const _pairs = [[0, 1], [3, 4], [5, 6]];

  @override
  void paint(Canvas canvas, Size size) {
    Offset at(int i) => Offset(_pts[i].dx * size.width, _pts[i].dy * size.height);

    final line = Paint()
      ..color = const Color(0x4D78C8FF)
      ..strokeWidth = 1
      ..isAntiAlias = true;
    for (final pr in _pairs) {
      canvas.drawLine(at(pr[0]), at(pr[1]), line);
    }

    for (var i = 0; i < _pts.length; i++) {
      var opacity = 1.0;
      if (_twinklers.containsKey(i)) {
        final t = (twinkle + _twinklers[i]!) % 1.0;
        opacity = 0.35 + 0.65 * (0.5 - 0.5 * math.cos(2 * math.pi * t));
      }
      final p = at(i);
      canvas.drawCircle(p, 8,
          Paint()..color = const Color(0xFF67E8F9).withValues(alpha: 0.35 * opacity)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6));
      canvas.drawCircle(p, 3,
          Paint()..color = const Color(0xFF67E8F9).withValues(alpha: opacity)..isAntiAlias = true);
    }
  }

  @override
  bool shouldRepaint(NodeWebPainter old) => old.twinkle != twinkle;
}
