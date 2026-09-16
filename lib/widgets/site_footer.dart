import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../artwork/flutter_mark.dart';
import '../theme.dart';
import 'fading_rule.dart';

/// Page footer: a full-width hairline, then a centred credit line flanked by
/// fading rules. Transparent — the section's waves show through.
class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 720;
    final credit = Row(
      mainAxisAlignment: MainAxisAlignment.center,
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

    return Semantics(
      container: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const FadingRule.full(),
            const SizedBox(height: 58),
            if (wide)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Flexible(child: FadingRule(fadeToward: FadeSide.left, maxWidth: 430)),
                  const SizedBox(width: 28),
                  credit,
                  const SizedBox(width: 28),
                  const Flexible(child: FadingRule(fadeToward: FadeSide.right, maxWidth: 430)),
                ],
              )
            else
              credit,
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
