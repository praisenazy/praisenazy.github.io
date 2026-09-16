import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../artwork/orb_artwork.dart';
import '../theme.dart';
import '../theme/app_text.dart';
import '../theme/breakpoints.dart';
import '../widgets/hero_widgets.dart';
import '../widgets/site_icons.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({
    super.key,
    required this.onProjects,
    required this.onContact,
    required this.onGithub,
  });

  final VoidCallback onProjects;
  final VoidCallback onContact;
  final VoidCallback onGithub;

  static const _subhead = 'I build polished, offline-first mobile apps with Flutter.';
  static const _lede =
      'Flutter developer focused on clean UI, smooth UX, and shipping real, '
      'usable apps. I recently built NairaTrack — a full offline expense '
      'tracker for Nigerian Naira.';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final w = size.width;
    final wide = w >= Breakpoints.sm;
    final heroH = math.max(720.0, size.height - Breakpoints.headerH);
    final gutter = Breakpoints.gutter(w);
    final h1Size = (w * 0.062).clamp(52.0, 92.0);
    final subSize = (w * 0.017).clamp(19.0, 26.0);

    return SizedBox(
      height: heroH,
      child: Stack(
        children: [
          ClipRect(child: _atmosphere(w, heroH)),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: Breakpoints.maxContent),
              child: Padding(
                padding: EdgeInsets.fromLTRB(gutter, 40, gutter, 90),
                child: wide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(flex: 108, child: _text(h1Size, subSize, true)),
                          const SizedBox(width: 56),
                          Expanded(
                            flex: 92,
                            child: Center(
                              child: LayoutBuilder(
                                builder: (_, c) => OrbArtwork(
                                  size: c.maxWidth.clamp(300.0, 560.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _text(h1Size, subSize, false),
                          const SizedBox(height: 56),
                          Center(
                            child: OrbArtwork(size: math.min(340, w - gutter * 2)),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _text(double h1Size, double subSize, bool wide) {
    final buttons = <Widget>[
      PrimaryButton(
        label: 'See my work',
        onTap: onProjects,
        leading: const CodeBrackets(size: 20, color: Colors.white),
        trailing: const ArrowRight(size: 20, color: Colors.white),
      ),
      GhostButton(
        label: 'GitHub',
        onTap: onGithub,
        minWidth: 168,
        leading: const GithubMark(size: 20, color: AppColors.textHi),
      ),
      GhostButton(
        label: 'Get in touch',
        onTap: onContact,
        minWidth: 196,
        leading: const EnvelopeIcon(size: 20, color: AppColors.textHi),
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Eyebrow('Flutter Developer'),
        const SizedBox(height: 28),
        Text("Hi, I'm", style: AppText.h1.copyWith(fontSize: h1Size)),
        GradientText(
          'Praise Anyigor',
          gradient: AppGradients.name,
          style: AppText.h1.copyWith(
            fontSize: h1Size,
            shadows: [
              Shadow(color: AppColors.blue.withValues(alpha: 0.35), blurRadius: 30, offset: const Offset(0, 6)),
            ],
          ),
        ),
        const SizedBox(height: 26),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 660),
          child: Text(_subhead, style: AppText.subhead.copyWith(fontSize: subSize)),
        ),
        const SizedBox(height: 22),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 580),
          child: Text(_lede, style: AppText.body),
        ),
        const SizedBox(height: 44),
        // All three in one row. On wide screens it scales down to fit if the
        // column is tight; on narrow screens it wraps.
        if (wide)
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                buttons[0],
                const SizedBox(width: 20),
                buttons[1],
                const SizedBox(width: 20),
                buttons[2],
              ],
            ),
          )
        else
          Wrap(spacing: 20, runSpacing: 14, children: buttons),
      ],
    );
  }

  Widget _atmosphere(double w, double h) {
    return Stack(
      children: [
        _blob(
          left: w * 0.58, top: h * 0.08, width: 920, height: 820, blur: 50, circle: true,
          colors: const [Color(0x6B328CFF), Color(0x381E5ADC), Color(0x00000000)],
          stops: const [0, .38, .68],
        ),
        _blob(
          left: -260, bottom: -220, width: 1000, height: 620, blur: 80, rotation: -0.42,
          colors: const [Color(0x4D6EAFFF), Color(0x243C78DC), Color(0x00000000)],
          stops: const [0, .45, .72],
        ),
        _blob(
          right: -180, bottom: -200, width: 700, height: 520, blur: 90, circle: true,
          colors: const [Color(0x3314BEC8), Color(0x00000000)],
          stops: const [0, .70],
        ),
        _blob(
          left: 0, right: 0, top: -320, height: 520, blur: 60,
          colors: const [Color(0x244696FF), Color(0x00000000)],
          stops: const [0, .70],
        ),
      ],
    );
  }

  Widget _blob({
    double? left,
    double? right,
    double? top,
    double? bottom,
    double? width,
    required double height,
    required double blur,
    required List<Color> colors,
    required List<double> stops,
    bool circle = false,
    double rotation = 0,
  }) {
    Widget blob = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: circle ? BoxShape.circle : BoxShape.rectangle,
        gradient: RadialGradient(colors: colors, stops: stops),
      ),
    );
    if (rotation != 0) blob = Transform.rotate(angle: rotation, child: blob);
    blob = ImageFiltered(imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur), child: blob);
    return Positioned(left: left, right: right, top: top, bottom: bottom, child: IgnorePointer(child: blob));
  }
}
