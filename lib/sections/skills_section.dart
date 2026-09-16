import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../artwork/flutter_mark.dart';
import '../artwork/skills_hero_artwork.dart';
import '../artwork/wave_divider_painter.dart';
import '../theme.dart';
import '../theme/accents.dart';
import '../theme/app_text.dart';
import '../theme/breakpoints.dart';
import '../widgets/hero_widgets.dart' show Eyebrow, GradientText;
import '../widgets/icons/brush_icon.dart';
import '../widgets/icons/database_icon.dart';
import '../widgets/icons/layers_icon.dart';
import '../widgets/icons/tools_icon.dart';
import '../widgets/site_icons.dart' show CodeBrackets;
import '../widgets/skill_card.dart';
import '../widgets/tech_chip.dart';

class SkillsSection extends StatefulWidget {
  const SkillsSection({super.key});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1150));
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
    if (y < MediaQuery.sizeOf(context).height * 0.6) {
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
    final sectionH = math.max(960.0, size.height);
    final gutter = Breakpoints.gutter(w);
    final hSize = (w * 0.050).clamp(40.0, 76.0);

    return Semantics(
      container: true,
      label: 'Skills',
      child: ConstrainedBox(
        // At least a full screen, but grows if the content is taller so it
        // never overflows/clips at shorter window heights.
        constraints: BoxConstraints(minHeight: sectionH),
        child: Stack(
          children: [
            Positioned.fill(child: ClipRect(child: _atmosphere(w, sectionH))),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: sectionH * 0.30,
              child: RepaintBoundary(
                child: ClipRect(
                  child: CustomPaint(
                    painter: const WaveDividerPainter(intensity: 1.25, crestOpacity: 0.95),
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            ),
            // Content sizes the Stack's height (bounded below by minHeight).
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(top: 52, bottom: 96),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: Breakpoints.maxContent),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: gutter),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _header(w, hSize),
                          const SizedBox(height: 58),
                          _grid(w),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(double w, double hSize) {
    final text = _HeaderText(hSize: hSize);
    if (w >= 1100) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 58, child: text),
          const SizedBox(width: 40),
          const Expanded(flex: 42, child: SkillsHeroArtwork(height: 300)),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text,
        const SizedBox(height: 40),
        const Center(child: SkillsHeroArtwork(height: 230)),
      ],
    );
  }

  // ---- Grid ----
  double _iv(double t, int i) {
    final start = i * 0.078;
    final end = (start + 0.61).clamp(0.0, 1.0);
    if (t <= start) return 0;
    if (t >= end) return 1;
    return Curves.easeOutCubic.transform((t - start) / (end - start));
  }

  Widget _reveal(int i, Widget child) {
    final t = _iv(_entrance.value, i);
    return Opacity(
      opacity: t,
      child: Transform.translate(offset: Offset(0, 20 * (1 - t)), child: child),
    );
  }

  Widget _grid(double w) {
    final cards = _cards();
    final cols = w >= 980 ? 3 : (w >= 640 ? 2 : 1);
    final gap = cols == 3 ? 26.0 : 22.0;

    return AnimatedBuilder(
      animation: _entrance,
      builder: (_, _) {
        final rows = <Widget>[];
        for (var i = 0; i < cards.length; i += cols) {
          final rowCards = <Widget>[];
          for (var j = 0; j < cols; j++) {
            final idx = i + j;
            if (j > 0) rowCards.add(SizedBox(width: gap));
            if (idx < cards.length) {
              rowCards.add(Expanded(child: _reveal(idx, cards[idx])));
            } else {
              rowCards.add(const Expanded(child: SizedBox()));
            }
          }
          if (rows.isNotEmpty) rows.add(SizedBox(height: gap));
          rows.add(cols == 1
              ? _reveal(i, cards[i])
              : IntrinsicHeight(child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: rowCards)));
        }
        return Column(children: rows);
      },
    );
  }

  List<Widget> _cards() {
    const lavender = Color(0xFFDCD3FF);
    return [
      const SkillCard(
        accent: Accent.blue,
        glyph: CodeBrackets(size: 30, color: Colors.white),
        title: 'Languages',
        subtitle: 'Programming languages I use',
        chips: [TechChip('Dart', accent: Accent.blue)],
      ),
      const SkillCard(
        accent: Accent.blue,
        tileGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E5FD8), Color(0xFF0E4A8C)],
        ),
        glyph: FlutterMark(size: 30),
        title: 'Framework',
        subtitle: 'Mobile development framework',
        chips: [
          TechChip('Flutter', accent: Accent.blue),
          TechChip('Material 3', accent: Accent.teal),
        ],
      ),
      const SkillCard(
        accent: Accent.violet,
        glyph: LayersIcon(size: 30, color: lavender),
        title: 'State management',
        subtitle: 'Managing app state efficiently',
        chips: [TechChip('Riverpod', accent: Accent.violet)],
      ),
      const SkillCard(
        accent: Accent.teal,
        glyph: DatabaseIcon(size: 30, color: AppColors.mintText),
        title: 'Local data',
        subtitle: 'Storing data locally',
        chips: [TechChip('Hive', accent: Accent.teal)],
      ),
      const SkillCard(
        accent: Accent.violet,
        glyph: BrushIcon(size: 30, color: lavender),
        title: 'UI & UX',
        subtitle: 'Design & animation tools',
        chips: [
          TechChip('Responsive design', accent: Accent.blue),
          TechChip('Animations', accent: Accent.teal),
          TechChip('Charts (fl_chart)', accent: Accent.blue),
        ],
      ),
      const SkillCard(
        accent: Accent.teal,
        glyph: ToolsIcon(size: 30, color: AppColors.cyan),
        title: 'Tooling',
        subtitle: 'Version control & development tools',
        chips: [
          TechChip('Git & GitHub', accent: Accent.blue),
          TechChip('GitHub Actions (CI/CD)', accent: Accent.teal),
          TechChip('Vs Code', accent: Accent.violet),
        ],
      ),
    ];
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
          right: w * 0.04, top: h * 0.02, width: 700, height: 600, blur: 60,
          colors: const [Color(0x66328CFF), Color(0x2E1E5ADC), Color(0x00000000)],
          stops: const [0, .38, .70],
        ),
        blob(
          left: w * 0.10, top: h * 0.40, width: 900, height: 500, blur: 95,
          colors: const [Color(0x142F7BFF), Color(0x00000000)],
          stops: const [0, .74],
        ),
      ],
    );
  }
}

class _HeaderText extends StatelessWidget {
  const _HeaderText({required this.hSize});
  final double hSize;

  static const _lede =
      'These are the technologies and tools I use to bring ideas to life, '
      'build amazing mobile apps, and create smooth user experiences.';

  @override
  Widget build(BuildContext context) {
    final white = AppText.h1.copyWith(fontSize: hSize, color: AppColors.textHi);
    final grad = AppText.h1.copyWith(
      fontSize: hSize,
      shadows: [Shadow(color: AppColors.blue.withValues(alpha: 0.35), blurRadius: 30, offset: const Offset(0, 6))],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Eyebrow.heavy('My skills'),
        const SizedBox(height: 22),
        LayoutBuilder(
          builder: (_, c) {
            final row = Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text('Tools I ', style: white),
                GradientText('build with', gradient: AppGradients.name, style: grad),
              ],
            );
            if (c.maxWidth >= 520) return row;
            return Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text('Tools I ', style: white),
                GradientText('build with', gradient: AppGradients.name, style: grad),
              ],
            );
          },
        ),
        const SizedBox(height: 26),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Text(
            _lede,
            style: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 18, height: 2.0, color: AppColors.textMid),
          ),
        ),
      ],
    );
  }
}
