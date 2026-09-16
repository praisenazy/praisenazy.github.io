import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../artwork/envelope_artwork.dart';
import '../artwork/phone_artwork.dart';
import '../artwork/wave_divider_painter.dart';
import '../artwork/flutter_mark.dart';
import '../theme.dart';
import '../theme/app_text.dart';
import '../theme/breakpoints.dart';
import '../widgets/contact_pill.dart';
import '../widgets/fading_rule.dart';
import '../widgets/icons/linkedin_icon.dart';
import '../widgets/site_icons.dart' show EnvelopeIcon, GithubMark;

const _email = 'nazypraise93@gmail.com';
const _github = 'https://github.com/praisenazy';
const _linkedin = 'https://linkedin.com/in/anyigor-praise';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  Future<void> _open(String url) => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);

  Future<void> _mail(BuildContext context) async {
    await Clipboard.setData(const ClipboardData(text: _email));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email copied — opening Gmail…'),
          duration: Duration(seconds: 2),
        ),
      );
    }
    await launchUrl(
      Uri.parse('https://mail.google.com/mail/?view=cm&fs=1&to=$_email'),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final w = size.width;
    const sectionH = 750.0;
    final gutter = Breakpoints.gutter(w);
    final hSize = (w * 0.052).clamp(40.0, 80.0);
    final showArt = w >= 1100;
    final envSize = w >= 1440 ? 290.0 : 240.0;
    final phoneH = w >= 1440 ? 400.0 : 340.0;

    return Semantics(
      container: true,
      label: 'Contact',
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: sectionH),
        child: Stack(
          children: [
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(0, -0.30),
                    radius: 1.15,
                    colors: [AppColors.contactMid, AppColors.contactDeep, Color(0xFF040E22)],
                    stops: [0.0, 0.52, 1.0],
                  ),
                ),
              ),
            ),
            Positioned.fill(child: ClipRect(child: _atmosphere(w, sectionH))),
            if (showArt)
              Positioned(left: 30, top: sectionH * 0.30, child: EnvelopeArtwork(size: envSize)),
            if (showArt)
              Positioned(right: 16, top: sectionH * 0.22, child: PhoneArtwork(height: phoneH)),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: sectionH * 0.22,
              child: RepaintBoundary(
                child: ClipRect(
                  child: CustomPaint(
                    painter: const WaveDividerPainter(
                        intensity: 1.45, crestOpacity: 1.0, fillTint: Color(0xFF1E5FD8)),
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Transform.translate(
                offset: const Offset(0, 40), // nudge the whole block down 40px
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: showArt ? Breakpoints.maxContent : 760),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: gutter),
                    child: _centre(context, w, hSize),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _centre(BuildContext context, double w, double hSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _eyebrow(),
        const SizedBox(height: 24),
        _heading(hSize),
        const SizedBox(height: 30),
        _subCopy(w),
        const SizedBox(height: 56),
        _pillRow(context, w),
        const SizedBox(height: 90),
        _footer(w),
      ],
    );
  }

  Widget _footer(double w) {
    final credit = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const FlutterMark(size: 20),
        const SizedBox(width: 12),
        Text(
          '© 2026 Praise Anyigor  •  Built with Flutter',
          style: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 16, color: AppColors.footerTxt),
        ),
      ],
    );
    if (w < 720) return credit;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Flexible(child: FadingRule(fadeToward: FadeSide.left, maxWidth: 430)),
        const SizedBox(width: 28),
        credit,
        const SizedBox(width: 28),
        const Flexible(child: FadingRule(fadeToward: FadeSide.right, maxWidth: 430)),
      ],
    );
  }

  Widget _eyebrow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const FadingRule(width: 62, fadeToward: FadeSide.left),
        const SizedBox(width: 20),
        Text(
          'CONTACT',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 13.5,
            letterSpacing: 4.0,
            color: AppColors.cyan,
            shadows: [Shadow(color: AppColors.cyan.withValues(alpha: 0.35), blurRadius: 16)],
          ),
        ),
        const SizedBox(width: 20),
        const FadingRule(width: 62, fadeToward: FadeSide.right),
      ],
    );
  }

  Widget _heading(double hSize) {
    final white = AppText.h1.copyWith(fontSize: hSize, color: AppColors.textHi);
    final grad = AppText.h1.copyWith(
      fontSize: hSize,
      shadows: [Shadow(color: AppColors.blue.withValues(alpha: 0.40), blurRadius: 34, offset: const Offset(0, 6))],
    );
    return LayoutBuilder(
      builder: (_, c) {
        final children = [
          Text('Let’s work ', style: white),
          _grad('together', grad),
        ];
        if (c.maxWidth >= 560) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: children,
          );
        }
        return Wrap(alignment: WrapAlignment.center, crossAxisAlignment: WrapCrossAlignment.center, children: children);
      },
    );
  }

  Widget _grad(String text, TextStyle style) => ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (r) => AppGradients.name.createShader(r),
        child: Text(text, style: style.copyWith(color: Colors.white)),
      );

  Widget _subCopy(double w) {
    return Text(
      "I'm open to Flutter developer roles and freelance work.\n"
      "The fastest way to reach me is by email.",
      textAlign: TextAlign.center,
      style: GoogleFonts.inter(
        fontWeight: FontWeight.w400,
        fontSize: (w * 0.0145).clamp(17.0, 22.0),
        height: 1.95,
        color: AppColors.textMid,
      ),
    );
  }

  Widget _pillRow(BuildContext context, double w) {
    final email = ContactPill.primary(
      label: _email,
      leading: const EnvelopeIcon(size: 22, color: AppColors.pillInk),
      onTap: () => _mail(context),
      semanticLabel: 'Email nazypraise93 at gmail dot com',
    );
    final github = ContactPill.ghost(
      label: 'GitHub',
      leading: const GithubMark(size: 22, color: AppColors.textHi),
      onTap: () => _open(_github),
      semanticLabel: 'GitHub profile',
    );
    final linkedin = ContactPill.ghost(
      label: 'LinkedIn',
      leading: const LinkedInIcon(size: 22),
      onTap: () => _open(_linkedin),
      semanticLabel: 'LinkedIn profile',
    );

    if (w < 640) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [email, const SizedBox(height: 14), github, const SizedBox(height: 14), linkedin],
      );
    }
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 22,
      runSpacing: 14,
      children: [email, github, linkedin],
    );
  }

  Widget _atmosphere(double w, double h) {
    Widget blob({
      double? left,
      double? right,
      Alignment? center,
      required double top,
      required double width,
      required double height,
      required double blur,
      required List<Color> colors,
      required List<double> stops,
    }) {
      final child = IgnorePointer(
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
      );
      if (center != null) {
        return Positioned(top: top, left: (w - width) / 2, child: child);
      }
      return Positioned(left: left, right: right, top: top, child: child);
    }

    return Stack(
      children: [
        blob(
          center: Alignment.center, top: h * 0.06, width: 1100, height: 760, blur: 70,
          colors: const [Color(0x47328CFF), Color(0x1E1E5ADC), Color(0x00000000)],
          stops: const [0, .42, .72],
        ),
        blob(
          left: -w * 0.06, top: h * 0.26, width: 620, height: 520, blur: 55,
          colors: const [Color(0x5922D3EE), Color(0x00000000)],
          stops: const [0, .68],
        ),
        blob(
          right: -w * 0.06, top: h * 0.18, width: 620, height: 600, blur: 55,
          colors: const [Color(0x5922D3EE), Color(0x00000000)],
          stops: const [0, .68],
        ),
      ],
    );
  }
}
