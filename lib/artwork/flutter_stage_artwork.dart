import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme.dart';
import '../widgets/site_icons.dart' show CodeBrackets, parseSvgPath;

/// Isometric 3D Flutter mark on a glowing stage, with two floating labelled
/// tiles, orbit arcs, ground glow and node dots. Motion halts under reduced
/// motion.
class FlutterStageArtwork extends StatefulWidget {
  const FlutterStageArtwork({super.key, required this.size});
  final double size;

  @override
  State<FlutterStageArtwork> createState() => _FlutterStageArtworkState();
}

class _FlutterStageArtworkState extends State<FlutterStageArtwork>
    with TickerProviderStateMixin {
  late final AnimationController _float =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 7500));
  late final AnimationController _tileA =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 5500));
  late final AnimationController _tileB =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 6800));
  late final AnimationController _twinkle =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 3200));
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      for (final c in [_float, _tileA, _tileB, _twinkle]) {
        c.stop();
        c.value = 0.5;
      }
    } else if (!_started) {
      _started = true;
      _float.repeat(reverse: true);
      _tileA.repeat(reverse: true);
      _tileB.repeat(reverse: true);
      _twinkle.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _float.dispose();
    _tileA.dispose();
    _tileB.dispose();
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
        // L0 orbit arcs
        Positioned.fill(
          child: RepaintBoundary(
            child: CustomPaint(painter: _OrbitArcsPainter(), child: const SizedBox.expand()),
          ),
        ),
        // L1 ground glow
        Align(
          alignment: const Alignment(0, 0.62),
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              width: s * 0.86,
              height: s * 0.28,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                gradient: RadialGradient(
                  colors: [AppColors.blue.withValues(alpha: 0.45), Colors.transparent],
                ),
              ),
            ),
          ),
        ),
        // L2 stage
        Positioned.fill(
          child: CustomPaint(painter: _StagePainter(), child: const SizedBox.expand()),
        ),
        // L3 3D flutter mark
        Align(
          alignment: const Alignment(0, -0.02),
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0012)
              ..rotateX(0.16)
              ..rotateZ(-0.10),
            child: CustomPaint(
              size: Size.square(s * 0.52),
              painter: _FlutterMark3DPainter(),
            ),
          ),
        ),
        // L4 floating tiles
        Positioned(
          right: s * 0.02,
          top: s * 0.01,
          child: AnimatedBuilder(
            animation: _tileA,
            builder: (_, _) => Transform.translate(
              offset: Offset(0, _wave(_tileA) * 6),
              child: _tile(
                dimension: 78,
                radius: 18,
                angle: -0.20,
                shadowStrength: 1,
                child: Text('Dart',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 17, color: AppColors.textHi)),
              ),
            ),
          ),
        ),
        Positioned(
          right: s * 0.0,
          bottom: s * 0.22,
          child: AnimatedBuilder(
            animation: _tileB,
            builder: (_, _) => Transform.translate(
              offset: Offset(0, _wave(_tileB) * 6),
              child: _tile(
                dimension: 72,
                radius: 16,
                angle: 0.17,
                shadowStrength: 0.8,
                child: const CodeBrackets(size: 30, color: AppColors.cyanLt),
              ),
            ),
          ),
        ),
        // L5 nodes
        Positioned.fill(
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: _twinkle,
              builder: (_, _) => CustomPaint(
                painter: _StageNodesPainter(_twinkle.value),
                child: const SizedBox.expand(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _tile({
    required double dimension,
    required double radius,
    required double angle,
    required double shadowStrength,
    required Widget child,
  }) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        width: dimension,
        height: dimension,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: AppGradients.tileBlue,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: const Color(0x38FFFFFF)),
          boxShadow: [
            BoxShadow(
              color: AppColors.blue.withValues(alpha: 0.45 * shadowStrength),
              blurRadius: 26,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class _OrbitArcsPainter extends CustomPainter {
  void _arc(Canvas c, Size size, double tilt) {
    c.save();
    c.translate(size.width / 2, size.height / 2);
    c.rotate(tilt);
    final rect = Rect.fromCenter(center: Offset.zero, width: size.width * 0.92, height: size.height * 0.5);
    c.drawArc(
      rect, -2.7, 3.5, false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = const Color(0x593C96FF)
        ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 2),
    );
    c.restore();
  }

  @override
  void paint(Canvas canvas, Size size) {
    _arc(canvas, size, -0.31);
    _arc(canvas, size, 0.91);
  }

  @override
  bool shouldRepaint(_OrbitArcsPainter old) => false;
}

class _StagePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final slabW = size.width * 0.80;
    final base = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset.zero, width: slabW, height: slabW),
      const Radius.circular(22),
    );
    canvas.save();
    canvas.translate(size.width / 2, size.height * 0.70);
    final m = Matrix4.identity()
      ..setEntry(1, 0, -0.32)
      ..scaleByDouble(1.0, 0.42, 1.0, 1.0);
    canvas.transform(m.storage);

    // thickness (offset copy)
    canvas.drawRRect(base.shift(const Offset(0, 26)), Paint()..color = const Color(0x1A0A1E4A));
    // top face
    canvas.drawRRect(
      base,
      Paint()
        ..isAntiAlias = true
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0x3D2F7BFF), Color(0x141E5ADC)],
        ).createShader(base.outerRect),
    );
    // rim light (whole outline; front/bottom reads brightest)
    canvas.drawRRect(
      base,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..color = AppColors.cyan.withValues(alpha: 0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );
    canvas.drawRRect(
      base,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = AppColors.cyan.withValues(alpha: 0.9),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_StagePainter old) => false;
}

class _FlutterMark3DPainter extends CustomPainter {
  static const _d =
      'M14.314 0L2.3 12 6 15.7 21.684.013h-7.37zm.014 11.072L7.857 17.53l3.715 3.715 3.717-3.717 6.4-6.457h-7.37z';
  static final Path _raw = parseSvgPath(_d);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 24);
    // glow silhouette
    canvas.drawPath(
      _raw,
      Paint()
        ..color = const Color(0xB33C96FF)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    // extruded side (stacked dark offset copies)
    final dark = Paint()..color = const Color(0xFF0E2A6B)..isAntiAlias = true;
    for (var i = 10; i >= 1; i--) {
      canvas.save();
      canvas.translate(i * 0.4, i * 0.5);
      canvas.drawPath(_raw, dark);
      canvas.restore();
    }
    // front faces (shaded)
    final rect = _raw.getBounds();
    canvas.drawPath(
      _raw,
      Paint()
        ..isAntiAlias = true
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6FD3FF), Color(0xFF3B8CFF), Color(0xFF1B5FD8)],
          stops: [0, .5, 1],
        ).createShader(rect),
    );
    // upper-left highlight
    canvas.drawPath(
      _raw,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.4
        ..color = const Color(0xCC9FD8FF),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_FlutterMark3DPainter old) => false;
}

class _StageNodesPainter extends CustomPainter {
  _StageNodesPainter(this.twinkle);
  final double twinkle;

  static const _pts = [
    Offset(.38, .10),
    Offset(.20, .22),
    Offset(.06, .62),
    Offset(.20, .83),
    Offset(.93, .52),
  ];
  static const _tw = {1: 0.0, 3: 0.4};

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < _pts.length; i++) {
      var o = 1.0;
      if (_tw.containsKey(i)) {
        final t = (twinkle + _tw[i]!) % 1.0;
        o = 0.35 + 0.65 * (0.5 - 0.5 * math.cos(2 * math.pi * t));
      }
      final p = Offset(_pts[i].dx * size.width, _pts[i].dy * size.height);
      canvas.drawCircle(p, 8, Paint()..color = const Color(0xFF67E8F9).withValues(alpha: 0.30 * o)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6));
      canvas.drawCircle(p, 3, Paint()..color = const Color(0xFF67E8F9).withValues(alpha: o)..isAntiAlias = true);
    }
  }

  @override
  bool shouldRepaint(_StageNodesPainter old) => old.twinkle != twinkle;
}
