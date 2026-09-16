import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../theme.dart';

/// Left Contact artwork: a tilted 3D message tile with a glowing envelope and a
/// speech-bubble tail, a paper plane escaping the corner, orbit arcs and nodes.
class EnvelopeArtwork extends StatefulWidget {
  const EnvelopeArtwork({super.key, required this.size});
  final double size;

  @override
  State<EnvelopeArtwork> createState() => _EnvelopeArtworkState();
}

class _EnvelopeArtworkState extends State<EnvelopeArtwork>
    with TickerProviderStateMixin {
  late final AnimationController _float =
      AnimationController(vsync: this, duration: const Duration(seconds: 8));
  late final AnimationController _plane =
      AnimationController(vsync: this, duration: const Duration(seconds: 5));
  late final AnimationController _twinkle =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 3200));
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      for (final c in [_float, _plane, _twinkle]) {
        c.stop();
        c.value = 0.5;
      }
    } else if (!_started) {
      _started = true;
      _float.repeat(reverse: true);
      _plane.repeat(reverse: true);
      _twinkle.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _float.dispose();
    _plane.dispose();
    _twinkle.dispose();
    super.dispose();
  }

  double _wave(AnimationController c) => (Curves.easeInOut.transform(c.value) - 0.5) * 2;

  @override
  Widget build(BuildContext context) {
    final s = widget.size;
    return ExcludeSemantics(
      child: RepaintBoundary(
        child: SizedBox.square(
          dimension: s,
          child: AnimatedBuilder(
            animation: _float,
            child: _content(s),
            builder: (_, child) =>
                Transform.translate(offset: Offset(0, _wave(_float) * 8), child: child),
          ),
        ),
      ),
    );
  }

  Widget _content(double s) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: RepaintBoundary(
            child: CustomPaint(painter: _ArcsPainter(), child: const SizedBox.expand()),
          ),
        ),
        Center(
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 34, sigmaY: 34),
            child: Container(
              width: s * 0.6,
              height: s * 0.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                gradient: RadialGradient(
                  colors: [const Color(0xFF22D3EE).withValues(alpha: 0.40), Colors.transparent],
                ),
              ),
            ),
          ),
        ),
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0012)
            ..rotateX(0.22)
            ..rotateZ(-0.12),
          child: CustomPaint(size: Size.square(s * 0.52), painter: _TilePainter()),
        ),
        Positioned(
          right: s * 0.10,
          top: s * 0.10,
          child: AnimatedBuilder(
            animation: _plane,
            builder: (_, _) => Transform.translate(
              offset: Offset(_wave(_plane) * 4, -_wave(_plane) * 4),
              child: Transform.rotate(
                angle: -0.42,
                child: CustomPaint(size: Size.square(s * 0.22), painter: _PlanePainter()),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: _twinkle,
              builder: (_, _) => CustomPaint(
                painter: _NodesPainter(_twinkle.value),
                child: const SizedBox.expand(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ArcsPainter extends CustomPainter {
  void _arc(Canvas c, Size s, double tilt, Color color, double width) {
    c.save();
    c.translate(s.width / 2, s.height / 2);
    c.rotate(tilt);
    final rect = Rect.fromCenter(center: Offset.zero, width: s.width * 0.98, height: s.height * 0.62);
    c.drawArc(rect, -2.6, 3.9, false,
        Paint()..style = PaintingStyle.stroke..strokeWidth = width..color = color..maskFilter = const MaskFilter.blur(BlurStyle.solid, 2));
    c.restore();
  }

  @override
  void paint(Canvas canvas, Size size) {
    _arc(canvas, size, -0.49, const Color(0x8C5AC8FF), 1.1);
    _arc(canvas, size, 0.31, const Color(0x4D22D3EE), 0.9);
    _arc(canvas, size, 1.26, const Color(0x3322D3EE), 0.9);
  }

  @override
  bool shouldRepaint(_ArcsPainter old) => false;
}

class _TilePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final r = 28 * (w / 150);
    final face = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, w, w), Radius.circular(r));

    // speech-bubble tail (lower-right)
    final tail = Path()
      ..moveTo(w * 0.58, w * 0.9)
      ..lineTo(w * 0.86, w * 0.9)
      ..lineTo(w * 0.8, w * 1.16)
      ..close();

    // extrusion (offset dark copies of face + tail)
    final dark = Paint()..color = const Color(0xFF0B2350)..isAntiAlias = true;
    canvas.drawRRect(face.shift(const Offset(7, 9)), dark);
    canvas.drawPath(tail.shift(const Offset(7, 9)), dark);

    final fill = Paint()
      ..isAntiAlias = true
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0x662F7BFF), Color(0x333B82F6)],
      ).createShader(Offset.zero & size);
    canvas.drawPath(tail, fill);
    canvas.drawRRect(face, fill);

    final border = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = const Color(0x8C7FD8FF)
      ..isAntiAlias = true;
    canvas.drawPath(tail, border);
    canvas.drawRRect(face, border);
    // top-left highlight
    canvas.drawLine(Offset(r, 2), Offset(w * 0.5, 2),
        Paint()..style = PaintingStyle.stroke..strokeWidth = 1.5..color = const Color(0x66FFFFFF));

    // envelope glyph, centred, glowing cyan
    final cx = w / 2, cy = w * 0.46;
    final ew = w * 0.52, eh = ew * 0.66;
    final body = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy), width: ew, height: eh), const Radius.circular(3));
    final flap = Path()
      ..moveTo(cx - ew / 2, cy - eh / 2)
      ..lineTo(cx, cy + eh * 0.06)
      ..lineTo(cx + ew / 2, cy - eh / 2);
    final glow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..color = AppColors.cyan.withValues(alpha: 0.7)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawRRect(body, glow);
    final glyph = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..color = AppColors.cyan
      ..isAntiAlias = true;
    canvas.drawRRect(body, glyph);
    canvas.drawPath(flap, glyph);
  }

  @override
  bool shouldRepaint(_TilePainter old) => false;
}

class _PlanePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    Offset p(double x, double y) => Offset(x * w, y * w);
    // glow
    final sil = Path()
      ..moveTo(p(0.05, 0.5).dx, p(0.05, 0.5).dy)
      ..lineTo(p(0.95, 0.12).dx, p(0.95, 0.12).dy)
      ..lineTo(p(0.55, 0.95).dx, p(0.55, 0.95).dy)
      ..close();
    canvas.drawPath(sil, Paint()..color = const Color(0xFF22D3EE).withValues(alpha: 0.5)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8));

    // top facet
    final top = Path()
      ..moveTo(p(0.05, 0.5).dx, p(0.05, 0.5).dy)
      ..lineTo(p(0.95, 0.12).dx, p(0.95, 0.12).dy)
      ..lineTo(p(0.5, 0.52).dx, p(0.5, 0.52).dy)
      ..close();
    canvas.drawPath(top, Paint()..isAntiAlias = true..shader = const LinearGradient(colors: [Color(0xFF9FE8FF), Color(0xFF3B9BFF)]).createShader(Offset.zero & size));
    // under facet
    final under = Path()
      ..moveTo(p(0.05, 0.5).dx, p(0.05, 0.5).dy)
      ..lineTo(p(0.5, 0.52).dx, p(0.5, 0.52).dy)
      ..lineTo(p(0.55, 0.95).dx, p(0.55, 0.95).dy)
      ..close();
    canvas.drawPath(under, Paint()..color = const Color(0xFF1B5FD8)..isAntiAlias = true);
    // fold facet
    final fold = Path()
      ..moveTo(p(0.5, 0.52).dx, p(0.5, 0.52).dy)
      ..lineTo(p(0.95, 0.12).dx, p(0.95, 0.12).dy)
      ..lineTo(p(0.55, 0.95).dx, p(0.55, 0.95).dy)
      ..close();
    canvas.drawPath(fold, Paint()..color = const Color(0xFF2F9BFF)..isAntiAlias = true);
  }

  @override
  bool shouldRepaint(_PlanePainter old) => false;
}

class _NodesPainter extends CustomPainter {
  _NodesPainter(this.twinkle);
  final double twinkle;
  static const _pts = [Offset(.42, .08), Offset(.06, .30), Offset(.88, .62)];

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < _pts.length; i++) {
      var o = 1.0;
      if (i == 0) {
        final t = twinkle % 1.0;
        o = 0.35 + 0.65 * (0.5 - 0.5 * math.cos(2 * math.pi * t));
      }
      final p = Offset(_pts[i].dx * size.width, _pts[i].dy * size.height);
      canvas.drawCircle(p, 8, Paint()..color = const Color(0xFF67E8F9).withValues(alpha: 0.30 * o)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6));
      canvas.drawCircle(p, 3, Paint()..color = const Color(0xFF67E8F9).withValues(alpha: o)..isAntiAlias = true);
    }
  }

  @override
  bool shouldRepaint(_NodesPainter old) => old.twinkle != twinkle;
}
