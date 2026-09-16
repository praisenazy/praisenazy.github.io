import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme.dart';
import '../widgets/site_icons.dart' show CodeBrackets, parseSvgPath;

/// Top-right Skills artwork: swoosh arcs, an upright 3D Flutter mark, a floating
/// holographic "</>" card, and the tagline row. Motion halts under reduced motion.
class SkillsHeroArtwork extends StatefulWidget {
  const SkillsHeroArtwork({super.key, required this.height});
  final double height;

  @override
  State<SkillsHeroArtwork> createState() => _SkillsHeroArtworkState();
}

class _SkillsHeroArtworkState extends State<SkillsHeroArtwork>
    with TickerProviderStateMixin {
  late final AnimationController _float =
      AnimationController(vsync: this, duration: const Duration(seconds: 8));
  late final AnimationController _card =
      AnimationController(vsync: this, duration: const Duration(seconds: 6));
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      _float.stop();
      _card.stop();
      _float.value = 0.5;
      _card.value = 0.5;
    } else if (!_started) {
      _started = true;
      _float.repeat(reverse: true);
      _card.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _float.dispose();
    _card.dispose();
    super.dispose();
  }

  double _wave(AnimationController c) => (Curves.easeInOut.transform(c.value) - 0.5) * 2;

  @override
  Widget build(BuildContext context) {
    final h = widget.height;
    return ExcludeSemantics(
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _float,
          child: _content(h),
          builder: (_, child) =>
              Transform.translate(offset: Offset(0, _wave(_float) * 7), child: child),
        ),
      ),
    );
  }

  Widget _content(double h) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: h,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned.fill(
                child: RepaintBoundary(
                  child: CustomPaint(painter: _SwooshPainter(), child: const SizedBox.expand()),
                ),
              ),
              Align(
                alignment: const Alignment(-0.15, 0.0),
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.0012)
                    ..rotateX(0.06)
                    ..rotateZ(-0.04),
                  child: CustomPaint(
                    size: Size.square(h * 0.66),
                    painter: _SkillsFlutter3D(),
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(0.92, -0.08),
                child: AnimatedBuilder(
                  animation: _card,
                  builder: (_, _) => Transform.translate(
                    offset: Offset(0, _wave(_card) * 5),
                    child: const _HoloCard(),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _tagline(),
      ],
    );
  }

  Widget _tagline() {
    final txt = GoogleFonts.inter(
        fontWeight: FontWeight.w500, fontSize: 13, letterSpacing: 1.6, color: AppColors.taglineTxt);
    final slash = txt.copyWith(color: AppColors.taglineSlash);
    return RichText(
      textAlign: TextAlign.right,
      text: TextSpan(children: [
        TextSpan(text: 'CLEAN CODE', style: txt),
        TextSpan(text: '  /  ', style: slash),
        TextSpan(text: 'MODERN APPS', style: txt),
        TextSpan(text: '  /  ', style: slash),
        TextSpan(text: 'BETTER EXPERIENCES', style: txt),
      ]),
    );
  }
}

class _SwooshPainter extends CustomPainter {
  void _swoosh(Canvas c, Size s, double yFrac, Color color, double width) {
    final p = Path()
      ..moveTo(-10, s.height * yFrac)
      ..cubicTo(s.width * 0.35, s.height * (yFrac - 0.1), s.width * 0.62, s.height * 0.3,
          s.width * 0.95, s.height * 0.08);
    c.drawPath(
      p,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = width
        ..color = color
        ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 2),
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    _swoosh(canvas, size, 0.66, const Color(0x593C96FF), 1.2);
    _swoosh(canvas, size, 0.78, const Color(0x332DD4BF), 0.8);
  }

  @override
  bool shouldRepaint(_SwooshPainter old) => false;
}

class _SkillsFlutter3D extends CustomPainter {
  static const _d =
      'M14.314 0L2.3 12 6 15.7 21.684.013h-7.37zm.014 11.072L7.857 17.53l3.715 3.715 3.717-3.717 6.4-6.457h-7.37z';
  static final Path _raw = parseSvgPath(_d);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 24);
    canvas.drawPath(
      _raw,
      Paint()
        ..color = const Color(0xB33C96FF)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9),
    );
    final dark = Paint()..color = const Color(0xFF123C96)..isAntiAlias = true;
    for (var i = 10; i >= 1; i--) {
      canvas.save();
      canvas.translate(i * 0.35, i * 0.5);
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
  bool shouldRepaint(_SkillsFlutter3D old) => false;
}

class _HoloCard extends StatelessWidget {
  const _HoloCard();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(size: const Size(190, 150), painter: _ConnectorsPainter()),
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(
                width: 148,
                height: 116,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0x0DFFFFFF),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0x4759B8FF)),
                  boxShadow: [BoxShadow(color: AppColors.blue.withValues(alpha: 0.30), blurRadius: 30)],
                ),
                child: DecoratedBox(
                  decoration: const BoxDecoration(),
                  child: _glowBrackets(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glowBrackets() => SizedBox(
        width: 44,
        height: 44,
        child: Stack(
          alignment: Alignment.center,
          children: const [
            ImageFilteredBrackets(),
            CodeBrackets(size: 44, color: AppColors.cyan),
          ],
        ),
      );
}

/// Blurred cyan copy of the brackets for a glow.
class ImageFilteredBrackets extends StatelessWidget {
  const ImageFilteredBrackets({super.key});
  @override
  Widget build(BuildContext context) => ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: CodeBrackets(size: 44, color: AppColors.cyan.withValues(alpha: 0.55)),
      );
}

class _ConnectorsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // card is 148x116 centred in 190x150 → margins ~21 x, ~17 y
    final left = (size.width - 148) / 2;
    final right = left + 148;
    final top = (size.height - 116) / 2;
    final bottom = top + 116;

    final line = Paint()
      ..color = const Color(0x8C5AC8FF)
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 1);
    final dot = Paint()..color = const Color(0xFF67E8F9)..isAntiAlias = true;

    // top-right dot + line
    final tr = Offset(right + 6, top - 6);
    canvas.drawLine(Offset(right - 24, top), Offset(right, top), line);
    canvas.drawCircle(tr, 3, dot);
    // bottom-left dot + line
    final bl = Offset(left - 8, bottom + 4);
    canvas.drawLine(Offset(left, bottom), Offset(left + 34, bottom), line);
    canvas.drawCircle(bl, 3, dot);
  }

  @override
  bool shouldRepaint(_ConnectorsPainter old) => false;
}
