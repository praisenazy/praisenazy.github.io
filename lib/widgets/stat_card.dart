import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme.dart';

/// A stat card: a leading tile/ring + a big value + a label. When [accent] is
/// set the card gets a tinted border and a soft coloured outer glow.
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.leading,
    required this.value,
    required this.label,
    this.accent,
  });

  final Widget leading;
  final Widget value;
  final String label;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${_plain(value)}, $label',
      container: true,
      child: Container(
        constraints: const BoxConstraints(minHeight: 142),
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.cardFillHi.withValues(alpha: 0.55),
              AppColors.cardFill.withValues(alpha: 0.65),
            ],
          ),
          border: Border.all(
            width: 1,
            color: accent == null ? AppColors.border : AppColors.emeraldEdge,
          ),
          boxShadow: [
            const BoxShadow(color: Color(0x66000000), blurRadius: 30, offset: Offset(0, 12)),
            if (accent != null)
              BoxShadow(color: accent!.withValues(alpha: 0.14), blurRadius: 34),
          ],
        ),
        child: Row(
          children: [
            ExcludeSemantics(child: leading),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ExcludeSemantics(child: value),
                  const SizedBox(height: 6),
                  Text(
                    label,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        height: 1.45,
                        color: AppColors.textMid),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Best-effort plain text of the value widget for semantics.
  String _plain(Widget w) => w is Text ? (w.data ?? '') : '';
}

/// Convenience big-number value text used by the stat cards.
class StatValue extends StatelessWidget {
  const StatValue(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Text(
        text,
        style: GoogleFonts.archivo(
            fontWeight: FontWeight.w800,
            fontSize: 34,
            height: 1,
            letterSpacing: -1,
            color: AppColors.textHi),
      );
}
