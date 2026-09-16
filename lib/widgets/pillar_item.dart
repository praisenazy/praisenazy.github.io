import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme.dart';

/// A small "pillar": an icon beside a two-line title/subtitle.
class PillarItem extends StatelessWidget {
  const PillarItem({
    super.key,
    required this.icon,
    required this.title,
    required this.sub,
  });

  final Widget icon;
  final String title;
  final String sub;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox.square(dimension: 26, child: Center(child: icon)),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title,
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600, fontSize: 15, color: AppColors.textHi)),
            const SizedBox(height: 6),
            Text(sub,
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400, fontSize: 13, color: AppColors.textMut)),
          ],
        ),
      ],
    );
  }
}
