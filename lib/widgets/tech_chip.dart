import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/accents.dart';

/// A decorative technology label pill (not a link/tab-stop).
class TechChip extends StatefulWidget {
  const TechChip(this.label, {super.key, required this.accent});
  final String label;
  final Accent accent;

  @override
  State<TechChip> createState() => _TechChipState();
}

class _TechChipState extends State<TechChip> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final a = accentSpec(widget.accent);
    Color bump(Color c, double add) =>
        c.withValues(alpha: (c.a + add).clamp(0.0, 1.0));
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        transform: Matrix4.translationValues(0, _hover ? -1 : 0, 0),
        height: 39,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _hover ? bump(a.chipFill, 0.08) : a.chipFill,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: _hover ? bump(a.chipEdge, 0.15) : a.chipEdge),
        ),
        child: Text(
          widget.label,
          style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 15, color: a.chipText),
        ),
      ),
    );
  }
}
