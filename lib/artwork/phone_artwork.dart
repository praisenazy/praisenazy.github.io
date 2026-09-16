import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme.dart';
import '../widgets/site_icons.dart' show parseSvgPath;

/// Right Contact artwork: a tilted phone with a gradient rim light, notch, the
/// 3D Flutter mark on screen, and the four italic lines. Motion halts under
/// reduced motion.
class PhoneArtwork extends StatefulWidget {
  const PhoneArtwork({super.key, required this.height});
  final double height;

  @override
  State<PhoneArtwork> createState() => _PhoneArtworkState();
}

class _PhoneArtworkState extends State<PhoneArtwork> with TickerProviderStateMixin {
  late final AnimationController _float =
      AnimationController(vsync: this, duration: const Duration(seconds: 9));
  late final AnimationController _orbit =
      AnimationController(vsync: this, duration: const Duration(seconds: 20));
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      _float.stop();
      _orbit.stop();
      _float.value = 0.5;
      _orbit.value = 0;
    } else if (!_started) {
      _started = true;
      _float.repeat(reverse: true);
      _orbit.repeat();
    }
  }

  @override
  void dispose() {
    _float.dispose();
    _orbit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = widget.height;
    final w = h * 0.68;
    return ExcludeSemantics(
      child: RepaintBoundary(
        child: SizedBox(
          width: w,
          height: h,
          child: AnimatedBuilder(
            animation: _float,
            child: _content(w, h),
            builder: (_, child) => Transform.translate(
              offset: Offset(0, (Curves.easeInOut.transform(_float.value) - 0.5) * 18),
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  Widget _content(double w, double h) {
    final deviceH = h * 0.9;
    final deviceW = deviceH * 0.5;
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: _orbit,
              builder: (_, _) => CustomPaint(
                painter: _PhoneArcsPainter(_orbit.value),
                child: const SizedBox.expand(),
              ),
            ),
          ),
        ),
        Center(
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
            child: Container(
              width: deviceW * 1.2,
              height: deviceH * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                gradient: RadialGradient(
                  colors: [const Color(0xFF22D3EE).withValues(alpha: 0.35), Colors.transparent],
                ),
              ),
            ),
          ),
        ),
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0011)
            ..rotateY(-0.20)
            ..rotateZ(0.03),
          child: SizedBox(
            width: deviceW,
            height: deviceH,
            child: Stack(
              children: [
                Positioned.fill(child: CustomPaint(painter: _PhoneChrome())),
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.all(deviceW * 0.05),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(34),
                      child: _screen(deviceW),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _screen(double deviceW) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: deviceW * 0.12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 52),
              Align(
                alignment: Alignment.centerRight,
                child: CustomPaint(size: const Size.square(66), painter: _Flutter3D()),
              ),
              const SizedBox(height: 40),
              Text(
                'Let’s\nbuild\nsomething\ngreat',
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    fontSize: 19,
                    height: 1.32,
                    fontStyle: FontStyle.italic,
                    color: AppColors.screenInk),
              ),
              const SizedBox(height: 14),
              Container(
                width: 34,
                height: 3,
                decoration: BoxDecoration(
                  color: AppColors.cyan,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [BoxShadow(color: AppColors.cyan.withValues(alpha: 0.7), blurRadius: 10)],
                ),
              ),
            ],
          ),
        ),
        // sheen
        IgnorePointer(
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white.withValues(alpha: 0.05), Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PhoneChrome extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final body = RRect.fromRectAndRadius(rect, const Radius.circular(42));
    // body fill
    canvas.drawRRect(
      body,
      Paint()
        ..isAntiAlias = true
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0B1B38), Color(0xFF050E22)],
        ).createShader(rect),
    );
    // rim light (glow + stroke)
    final rimShader = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF3B9BFF), Color(0xFF22D3EE)],
    ).createShader(rect);
    canvas.drawRRect(
      body,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..shader = rimShader
        ..color = const Color(0xFF22D3EE).withValues(alpha: 0.75)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14),
    );
    canvas.drawRRect(
      body,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..shader = rimShader
        ..isAntiAlias = true,
    );
    // inner bezel
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect.deflate(5), const Radius.circular(37)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = const Color(0x2EFFFFFF),
    );
    // notch
    final nw = size.width * 0.42;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(size.width / 2, 20), width: nw, height: 18),
        const Radius.circular(9),
      ),
      Paint()..color = const Color(0xFF04091A),
    );
  }

  @override
  bool shouldRepaint(_PhoneChrome old) => false;
}

class _PhoneArcsPainter extends CustomPainter {
  _PhoneArcsPainter(this.progress);
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    void arc(double tilt, double rxF, double ryF, double dotP) {
      canvas.save();
      canvas.translate(c.dx, c.dy);
      canvas.rotate(tilt);
      final rx = size.width * rxF, ry = size.height * ryF;
      canvas.drawArc(
        Rect.fromCenter(center: Offset.zero, width: rx * 2, height: ry * 2),
        -2.5, 4.2, false,
        Paint()..style = PaintingStyle.stroke..strokeWidth = 1.3..color = const Color(0xA622D3EE)..maskFilter = const MaskFilter.blur(BlurStyle.solid, 2),
      );
      final theta = 2 * math.pi * dotP;
      final d = Offset(rx * math.cos(theta), ry * math.sin(theta));
      canvas.drawCircle(d, 4, Paint()..color = const Color(0xFF22D3EE)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4));
      canvas.drawCircle(d, 2.5, Paint()..color = const Color(0xFF9FF3FF));
      canvas.restore();
    }

    arc(-0.35, 0.62, 0.42, progress);
    arc(0.55, 0.58, 0.5, (progress + 0.5) % 1);
  }

  @override
  bool shouldRepaint(_PhoneArcsPainter old) => old.progress != progress;
}

class _Flutter3D extends CustomPainter {
  static const _d =
      'M14.314 0L2.3 12 6 15.7 21.684.013h-7.37zm.014 11.072L7.857 17.53l3.715 3.715 3.717-3.717 6.4-6.457h-7.37z';
  static final Path _raw = parseSvgPath(_d);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 24);
    canvas.drawPath(_raw, Paint()..color = const Color(0xB33C96FF)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6));
    final dark = Paint()..color = const Color(0xFF123C96)..isAntiAlias = true;
    for (var i = 8; i >= 1; i--) {
      canvas.save();
      canvas.translate(i * 0.3, i * 0.45);
      canvas.drawPath(_raw, dark);
      canvas.restore();
    }
    canvas.drawPath(
      _raw,
      Paint()
        ..isAntiAlias = true
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7DDBFF), Color(0xFF3B8CFF), Color(0xFF1B5FD8)],
          stops: [0, .5, 1],
        ).createShader(_raw.getBounds()),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_Flutter3D old) => false;
}
