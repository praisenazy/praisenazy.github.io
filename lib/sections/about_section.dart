import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../artwork/flutter_mark.dart';
import '../artwork/flutter_stage_artwork.dart';
import '../artwork/wave_divider_painter.dart';
import '../theme.dart';
import '../theme/app_text.dart';
import '../theme/breakpoints.dart';
import '../widgets/hero_widgets.dart' show Eyebrow, GradientText;
import '../widgets/icon_tile.dart';
import '../widgets/icons/bolt_icon.dart';
import '../widgets/icons/calendar_icon.dart';
import '../widgets/icons/send_icon.dart';
import '../widgets/pillar_item.dart';
import '../widgets/progress_ring.dart';
import '../widgets/site_icons.dart' show CodeBrackets;
import '../widgets/stat_card.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({super.key});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
  ScrollPosition? _pos;
  bool _fired = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      _entrance.value = 1;
      _fired = true;
      return;
    }
    final sp = Scrollable.maybeOf(context)?.position;
    if (sp != _pos) {
      _pos?.removeListener(_onScroll);
      _pos = sp;
      _pos?.addListener(_onScroll);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  void _onScroll() {
    if (_fired || !mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return;
    final y = box.localToGlobal(Offset.zero).dy;
    if (y < MediaQuery.sizeOf(context).height * 0.85) {
      _fired = true;
      _entrance.forward();
      _pos?.removeListener(_onScroll);
    }
  }

  @override
  void dispose() {
    _pos?.removeListener(_onScroll);
    _entrance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final w = size.width;
    final sectionH = math.max(860.0, size.height);
    final gutter = Breakpoints.gutter(w);
    final hSize = (w * 0.050).clamp(40.0, 76.0);

    return Semantics(
      container: true,
      label: 'About me',
      child: SizedBox(
        height: sectionH,
        child: Stack(
          children: [
            ClipRect(child: _atmosphere(w, sectionH)),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: sectionH * 0.34,
              child: RepaintBoundary(
                child: ClipRect(
                  child: CustomPaint(
                    painter: const WaveDividerPainter(),
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            ),
            Align(
              alignment: const Alignment(0, -0.18),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: Breakpoints.maxContent),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: gutter),
                  child: _layout(w, hSize),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _layout(double w, double hSize) {
    final text = _AboutText(hSize: hSize);
    final cards = _StatColumn(entrance: _entrance);

    if (w >= 1180) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 52, child: text),
          const SizedBox(width: 48),
          SizedBox(width: 353, child: cards),
          const SizedBox(width: 28),
          Expanded(
            flex: 26,
            child: Center(
              child: LayoutBuilder(
                builder: (_, c) =>
                    FlutterStageArtwork(size: c.maxWidth.clamp(220.0, 360.0)),
              ),
            ),
          ),
        ],
      );
    } else if (w >= 900) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: text),
          const SizedBox(width: 40),
          SizedBox(
            width: 340,
            child: Column(
              children: [
                cards,
                const SizedBox(height: 40),
                const FlutterStageArtwork(size: 300),
              ],
            ),
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text,
        const SizedBox(height: 48),
        cards,
        const SizedBox(height: 48),
        const Center(child: FlutterStageArtwork(size: 280)),
      ],
    );
  }

  Widget _atmosphere(double w, double h) {
    Widget blob({
      double? left,
      double? right,
      double? top,
      required double width,
      required double height,
      required double blur,
      required List<Color> colors,
      required List<double> stops,
    }) {
      return Positioned(
        left: left,
        right: right,
        top: top,
        child: IgnorePointer(
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: colors, stops: stops),
              ),
            ),
          ),
        ),
      );
    }

    return Stack(
      children: [
        blob(
          right: w * 0.08, top: h * 0.18, width: 760, height: 640, blur: 60,
          colors: const [Color(0x5C328CFF), Color(0x2E1E5ADC), Color(0x00000000)],
          stops: const [0, .40, .70],
        ),
        blob(
          left: w * 0.18, top: -h * 0.10, width: 900, height: 520, blur: 90,
          colors: const [Color(0x1A4696FF), Color(0x00000000)],
          stops: const [0, .72],
        ),
      ],
    );
  }
}

/// ---------------------------------------------------------------------------
/// LEFT COLUMN
/// ---------------------------------------------------------------------------
class _AboutText extends StatelessWidget {
  const _AboutText({required this.hSize});
  final double hSize;

  static const _p1 =
      "I'm a Flutter developer from Nigeria who fell in love with building "
      "apps that feel great to use. Over close to two years I've gone from "
      "learning Dart to shipping complete, polished apps.";
  static const _p2 =
      "I care about the details — responsive layouts that work on any screen, "
      "smooth animations, thoughtful empty states, and code that's clean and "
      "easy to maintain. I'm looking for a Flutter developer role where I can "
      "keep building great products.";

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final narrowPillars = w < 760;
    final body = GoogleFonts.inter(
        fontWeight: FontWeight.w400, fontSize: 18, height: 1.90, color: AppColors.textMut);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Eyebrow('About me'),
        const SizedBox(height: 22),
        _heading(),
        const SizedBox(height: 30),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_p1, style: body),
              const SizedBox(height: 26),
              Text(_p2, style: body),
            ],
          ),
        ),
        const SizedBox(height: 46),
        _pillars(narrowPillars),
      ],
    );
  }

  Widget _heading() {
    final white = AppText.h1.copyWith(fontSize: hSize, color: AppColors.textHi);
    final grad = AppText.h1.copyWith(
      fontSize: hSize,
      shadows: [
        Shadow(color: AppColors.blue.withValues(alpha: 0.35), blurRadius: 30, offset: const Offset(0, 6)),
      ],
    );
    return LayoutBuilder(
      builder: (_, c) {
        final one = c.maxWidth >= 520;
        if (one) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('A bit ', style: white),
              GradientText('about me', gradient: AppGradients.name, style: grad),
            ],
          );
        }
        return Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('A bit ', style: white),
            GradientText('about me', gradient: AppGradients.name, style: grad),
          ],
        );
      },
    );
  }

  Widget _pillars(bool stacked) {
    final items = [
      const PillarItem(
        icon: FlutterMark(size: 26),
        title: 'Flutter Developer',
        sub: 'Clean • Smooth • Usable',
      ),
      const PillarItem(
        icon: CodeBrackets(size: 26, color: AppColors.cyan),
        title: 'Problem Solver',
        sub: 'Learn • Build • Improve',
      ),
      const PillarItem(
        icon: BoltIcon(size: 26, color: AppColors.blueLt),
        title: 'Always Growing',
        sub: 'Better Apps • Bigger Goals',
      ),
    ];

    if (stacked) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          items[0],
          const _HRule(),
          items[1],
          const _HRule(),
          items[2],
        ],
      );
    }
    // One row, but scale the whole group down if the column is too narrow so
    // it never overflows (it fits at full size around 1536px).
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            items[0],
            const _VDivider(),
            items[1],
            const _VDivider(),
            items[2],
          ],
        ),
      ),
    );
  }
}

class _VDivider extends StatelessWidget {
  const _VDivider();
  @override
  Widget build(BuildContext context) => Container(
        width: 1,
        color: AppColors.border,
        margin: const EdgeInsets.symmetric(horizontal: 26),
      );
}

class _HRule extends StatelessWidget {
  const _HRule();
  @override
  Widget build(BuildContext context) => Container(
        height: 1,
        width: double.infinity,
        color: AppColors.border,
        margin: const EdgeInsets.symmetric(vertical: 22),
      );
}

/// ---------------------------------------------------------------------------
/// CENTRE COLUMN — stat cards with a one-time entrance + counters
/// ---------------------------------------------------------------------------
class _StatColumn extends StatelessWidget {
  const _StatColumn({required this.entrance});
  final Animation<double> entrance;

  double _iv(double t, int i) {
    final start = i * 0.1333;
    final end = (start + 0.55).clamp(0.0, 1.0);
    if (t <= start) return 0;
    if (t >= end) return 1;
    return Curves.easeOutCubic.transform((t - start) / (end - start));
  }

  Widget _reveal(int i, Widget child) {
    final t = _iv(entrance.value, i);
    return Opacity(
      opacity: t,
      child: Transform.translate(offset: Offset(0, 18 * (1 - t)), child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: entrance,
      builder: (_, _) {
        final c1 = (2 * _iv(entrance.value, 0)).round();
        final c2 = (100 * _iv(entrance.value, 1)).round();
        final c3 = (1 * _iv(entrance.value, 2)).round();
        return Column(
          children: [
            _reveal(
              0,
              StatCard(
                leading: IconTile(
                  gradient: AppGradients.tileBlue,
                  glow: AppColors.blue,
                  child: const CalendarIcon(size: 30, color: AppColors.iconBlue),
                ),
                value: StatValue('~$c1'),
                label: 'years building with Flutter',
              ),
            ),
            const SizedBox(height: 14),
            _reveal(
              1,
              StatCard(
                accent: AppColors.emerald,
                leading: ProgressRing(
                  size: 68,
                  progress: _iv(entrance.value, 1),
                  label: '$c2%',
                ),
                value: StatValue('$c2%'),
                label: 'offline-first — no backend',
              ),
            ),
            const SizedBox(height: 14),
            _reveal(
              2,
              StatCard(
                leading: IconTile(
                  gradient: AppGradients.tileViolet,
                  glow: AppColors.violet,
                  child: const SendIcon(size: 30, color: AppColors.violetIcon),
                ),
                value: StatValue('$c3'),
                label: 'polished app shipped\nto the web',
              ),
            ),
          ],
        );
      },
    );
  }
}
