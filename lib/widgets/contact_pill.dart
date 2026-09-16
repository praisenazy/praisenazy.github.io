import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme.dart';
import 'site_icons.dart' show ArrowRight;

/// A contact pill: [ContactPill.primary] is the bright gradient email pill with
/// DARK ink; [ContactPill.ghost] is a dark bordered pill (GitHub / LinkedIn).
class ContactPill extends StatefulWidget {
  const ContactPill.primary({
    super.key,
    required this.label,
    required this.leading,
    required this.onTap,
    required this.semanticLabel,
  }) : primary = true;

  const ContactPill.ghost({
    super.key,
    required this.label,
    required this.leading,
    required this.onTap,
    required this.semanticLabel,
  }) : primary = false;

  final String label;
  final Widget leading;
  final VoidCallback onTap;
  final String semanticLabel;
  final bool primary;

  @override
  State<ContactPill> createState() => _ContactPillState();
}

class _ContactPillState extends State<ContactPill> {
  bool _hover = false;
  bool _focus = false;

  @override
  Widget build(BuildContext context) {
    final ink = widget.primary ? AppColors.pillInk : AppColors.textHi;
    final pill = AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      height: 62,
      padding: widget.primary
          ? const EdgeInsets.fromLTRB(24, 0, 22, 0)
          : const EdgeInsets.fromLTRB(26, 0, 22, 0),
      transformAlignment: Alignment.center,
      transform: Matrix4.translationValues(0, _hover ? -2 : 0, 0),
      decoration: widget.primary
          ? BoxDecoration(
              gradient: AppGradients.emailPill,
              borderRadius: BorderRadius.circular(999),
              boxShadow: [
                BoxShadow(
                    color: const Color(0xFF22D3EE).withValues(alpha: _hover ? 0.70 : 0.52),
                    blurRadius: _hover ? 52 : 40,
                    offset: const Offset(0, 12)),
                BoxShadow(color: const Color(0xFF34E0B0).withValues(alpha: 0.30), blurRadius: 26),
                const BoxShadow(color: Color(0x59000000), blurRadius: 12, offset: Offset(0, 4)),
              ],
            )
          : BoxDecoration(
              color: AppColors.ghostFill,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: _hover ? const Color(0x8C7FD8FF) : AppColors.ghostEdge),
              boxShadow: _hover
                  ? [BoxShadow(color: AppColors.cyan.withValues(alpha: 0.22), blurRadius: 28)]
                  : [const BoxShadow(color: Color(0x4D000000), blurRadius: 16, offset: Offset(0, 6))],
            ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.leading,
          const SizedBox(width: 14),
          Flexible(
            child: Text(
              widget.label,
              maxLines: 1,
              overflow: TextOverflow.visible,
              softWrap: false,
              style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 17, color: ink),
            ),
          ),
          const SizedBox(width: 16),
          AnimatedSlide(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            offset: _hover ? const Offset(0.18, 0) : Offset.zero,
            child: ArrowRight(size: widget.primary ? 20 : 18, color: ink),
          ),
        ],
      ),
    );

    return Semantics(
      link: true,
      label: widget.semanticLabel,
      child: FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        onShowHoverHighlight: (h) => setState(() => _hover = h),
        onShowFocusHighlight: (f) => setState(() => _focus = f),
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) {
            widget.onTap();
            return null;
          }),
        },
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            padding: EdgeInsets.all(_focus ? 3 : 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: _focus ? AppColors.cyan : Colors.transparent, width: 2),
            ),
            child: pill,
          ),
        ),
      ),
    );
  }
}
