import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme.dart';
import '../theme/accents.dart';
import 'icon_tile.dart';

/// A skill card: an accent icon tile + title/subtitle + a wrap of tech chips.
class SkillCard extends StatefulWidget {
  const SkillCard({
    super.key,
    required this.accent,
    required this.glyph,
    required this.title,
    required this.subtitle,
    required this.chips,
    this.tileGradient,
  });

  final Accent accent;
  final Widget glyph;
  final String title;
  final String subtitle;
  final List<Widget> chips;
  final Gradient? tileGradient; // override the tile fill (card 2)

  @override
  State<SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<SkillCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final a = accentSpec(widget.accent);
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _hover ? -4 : 0, 0),
        padding: const EdgeInsets.fromLTRB(34, 35, 30, 32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.cardSurface.withValues(alpha: 0.55),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0x0FFFFFFF), Color(0x05FFFFFF)],
          ),
          border: Border.all(
            width: 1,
            color: _hover ? a.chipEdge : AppColors.borderSft,
          ),
          boxShadow: _hover
              ? [
                  const BoxShadow(color: Color(0x73000000), blurRadius: 40, offset: Offset(0, 18)),
                  BoxShadow(color: a.glow.withValues(alpha: 0.16), blurRadius: 36),
                ]
              : [const BoxShadow(color: Color(0x59000000), blurRadius: 26, offset: Offset(0, 12))],
        ),
        child: Semantics(
          container: true,
          label: '${widget.title}. ${widget.subtitle}.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExcludeSemantics(
                    child: IconTile(
                      size: 64,
                      radius: 16,
                      gradient: widget.tileGradient ?? a.tile,
                      glow: a.glow,
                      child: widget.glyph,
                    ),
                  ),
                  const SizedBox(width: 31),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(widget.title,
                            style: GoogleFonts.archivo(
                                fontWeight: FontWeight.w700,
                                fontSize: 21,
                                letterSpacing: -0.3,
                                color: AppColors.textHi)),
                        const SizedBox(height: 8),
                        Text(widget.subtitle,
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                height: 1.4,
                                color: AppColors.textMut)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              Wrap(spacing: 14, runSpacing: 11, children: widget.chips),
            ],
          ),
        ),
      ),
    );
  }
}
