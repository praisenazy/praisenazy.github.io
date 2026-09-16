import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../theme.dart';
import '../theme/app_text.dart';
import '../widgets/hero_widgets.dart' show GradientText;
import 'flutter_mark.dart';
import 'node_web_painter.dart';
import 'orbit_rings_painter.dart';
import 'wireframe_painter.dart';

/// The hero centrepiece: a glowing glass orb with a rotating wireframe, two
/// depth-sorted orbital rings, a tilted "PA" glass card, the Flutter mark and a
/// twinkling node web. Every loop halts under reduced motion.
class OrbArtwork extends StatefulWidget {
  const OrbArtwork({super.key, required this.size});
  final double size;

  @override
  State<OrbArtwork> createState() => _OrbArtworkState();
}

class _OrbArtworkState extends State<OrbArtwork> with TickerProviderStateMixin {
  late final AnimationController _float =
      AnimationController(vsync: this, duration: const Duration(seconds: 7));
  late final AnimationController _spin =
      AnimationController(vsync: this, duration: const Duration(seconds: 60));
  late final AnimationController _orbit =
      AnimationController(vsync: this, duration: const Duration(seconds: 22));
  late final AnimationController _twinkle =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 3200));

  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduce = MediaQuery.of(context).disableAnimations;
    if (reduce) {
      _float.stop(); _spin.stop(); _orbit.stop(); _twinkle.stop();
      _float.value = 0.5; _spin.value = 0; _orbit.value = 0; _twinkle.value = 0;
    } else if (!_started) {
      _started = true;
      _float.repeat(reverse: true);
      _spin.repeat();
      _orbit.repeat();
      _twinkle.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _float.dispose(); _spin.dispose(); _orbit.dispose(); _twinkle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    return ExcludeSemantics(
      child: RepaintBoundary(
        child: SizedBox.square(
          dimension: size,
          child: AnimatedBuilder(
            animation: _float,
            child: _stack(size),
            builder: (_, child) {
              final fy = -10 + 20 * Curves.easeInOut.transform(_float.value);
              return Transform.translate(offset: Offset(0, fy), child: child);
            },
          ),
        ),
      ),
    );
  }

  Widget _stack(double size) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // L0 wireframe
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _spin,
            child: const RepaintBoundary(
              child: CustomPaint(painter: WireframePainter(), child: SizedBox.expand()),
            ),
            builder: (_, child) =>
                Transform.rotate(angle: _spin.value * 2 * math.pi, child: child),
          ),
        ),
        // L1 halo
        Center(
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
            child: Container(
              width: size * 0.72,
              height: size * 0.72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [AppColors.blue.withValues(alpha: 0.40), Colors.transparent],
                  stops: const [0, 0.62],
                ),
              ),
            ),
          ),
        ),
        // L4 rings — behind
        Positioned.fill(
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: _orbit,
              builder: (_, _) => CustomPaint(
                painter: OrbitRingsPainter(progress: _orbit.value, half: RingHalf.back),
                child: const SizedBox.expand(),
              ),
            ),
          ),
        ),
        // L2 orb (with breathing pulse)
        AnimatedBuilder(
          animation: _float,
          builder: (_, _) =>
              _orb(size, 90 + 30 * Curves.easeInOut.transform(_float.value)),
        ),
        // L3 card stack
        _cards(size),
        // L4 rings — in front
        Positioned.fill(
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: _orbit,
              builder: (_, _) => CustomPaint(
                painter: OrbitRingsPainter(progress: _orbit.value, half: RingHalf.front),
                child: const SizedBox.expand(),
              ),
            ),
          ),
        ),
        // L5 Flutter mark
        Positioned(
          right: size * 0.04,
          bottom: size * 0.16,
          child: FlutterMark(size: size * 0.154),
        ),
        // L6 nodes
        Positioned.fill(
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: _twinkle,
              builder: (_, _) => CustomPaint(
                painter: NodeWebPainter(twinkle: _twinkle.value),
                child: const SizedBox.expand(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _orb(double size, double pulseBlur) {
    final d = size * 0.62;
    return SizedBox(
      width: d,
      height: d,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                center: Alignment(-0.32, -0.44),
                radius: 0.95,
                colors: [
                  Color(0xF2A0D7FF),
                  Color(0xBF46A0FF),
                  Color(0xD92064DC),
                  Color(0xF20C2D78),
                  Color(0xFF06143C),
                ],
                stops: [0.0, 0.14, 0.42, 0.72, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                    color: AppColors.blue.withValues(alpha: 0.70),
                    blurRadius: pulseBlur,
                    spreadRadius: 4),
                BoxShadow(color: const Color(0xFF1E64DC).withValues(alpha: 0.45), blurRadius: 180),
              ],
            ),
          ),
          // specular gloss
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.all(d * 0.06),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    center: Alignment(-0.4, -0.52),
                    radius: 0.6,
                    colors: [Color(0x8CFFFFFF), Color(0x1AFFFFFF), Colors.transparent],
                    stops: [0, 0.16, 0.44],
                  ),
                ),
              ),
            ),
          ),
          // rim light
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0x738CD7FF)),
            ),
          ),
          // bottom-right dark vignette
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  center: Alignment(0.55, 0.62),
                  radius: 0.95,
                  colors: [Color(0x00061436), Color(0x9904122A)],
                  stops: [0.5, 1.0],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cards(double size) {
    final cs = size / 560;
    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.translate(
          offset: Offset(26 * cs, -22 * cs),
          child: Transform.rotate(
            angle: 0.122,
            child: Container(
              width: 176 * cs,
              height: 206 * cs,
              decoration: BoxDecoration(
                color: const Color(0x0EFFFFFF),
                borderRadius: BorderRadius.circular(18 * cs),
                border: Border.all(color: const Color(0x47B4DCFF)),
              ),
            ),
          ),
        ),
        Transform.rotate(
          angle: -0.087,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20 * cs),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(
                width: 196 * cs,
                height: 228 * cs,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0x24FFFFFF), Color(0x0AFFFFFF)],
                  ),
                  borderRadius: BorderRadius.circular(20 * cs),
                  border: Border.all(color: const Color(0x61BEE1FF)),
                  boxShadow: const [
                    BoxShadow(color: Color(0x66000000), blurRadius: 50, offset: Offset(0, 16)),
                  ],
                ),
                child: Center(
                  child: GradientText(
                    'PA',
                    gradient: AppGradients.logo,
                    style: AppText.mono.copyWith(
                      fontSize: size * 0.15,
                      shadows: [const Shadow(color: Color(0xA646B4FF), blurRadius: 22)],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
