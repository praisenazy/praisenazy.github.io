import 'package:flutter/material.dart';

import '../theme.dart';
import '../theme/app_text.dart';

/// Text painted with a gradient via ShaderMask (srcIn).
class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    super.key,
    required this.gradient,
    required this.style,
    this.textAlign,
  });

  final String text;
  final Gradient gradient;
  final TextStyle style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (r) => gradient.createShader(r),
      child: Text(text, textAlign: textAlign, style: style.copyWith(color: Colors.white)),
    );
  }
}

/// Cyan eyebrow: a short gradient rule + uppercase spaced label.
/// [Eyebrow.heavy] uses a wider/taller blue rule and a lighter-blue label
/// (used on the Skills screen); the default stays 36×2 cyan for Sections 1–2.
class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key}) : heavy = false;
  const Eyebrow.heavy(this.text, {super.key}) : heavy = true;
  final String text;
  final bool heavy;

  @override
  Widget build(BuildContext context) {
    final ruleColor = heavy ? AppColors.eyebrowBlue : AppColors.cyan;
    final labelColor = heavy ? AppColors.eyebrowBlue : AppColors.cyan;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: heavy ? 46 : 36,
          height: heavy ? 3 : 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            gradient: LinearGradient(
              colors: [
                (heavy ? const Color(0x333C96FF) : AppColors.cyan.withValues(alpha: 0.25)),
                ruleColor,
              ],
            ),
          ),
        ),
        const SizedBox(width: 18),
        Text(
          text.toUpperCase(),
          style: AppText.eyebrow.copyWith(
            color: labelColor,
            shadows: [Shadow(color: labelColor.withValues(alpha: 0.30), blurRadius: 16)],
          ),
        ),
      ],
    );
  }
}

/// Filled gradient button with a real outward blue bloom + hover lift.
class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onTap,
    this.leading,
    this.trailing,
    this.minWidth = 252,
  });

  final String label;
  final VoidCallback onTap;
  final Widget? leading;
  final Widget? trailing;
  final double minWidth;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _hover = false;
  bool _focus = false;

  @override
  Widget build(BuildContext context) {
    return _Focusable(
      onTap: widget.onTap,
      onHover: (h) => setState(() => _hover = h),
      onFocus: (f) => setState(() => _focus = f),
      focused: _focus,
      semanticLabel: widget.label,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        height: 62,
        constraints: BoxConstraints(minWidth: widget.minWidth),
        padding: const EdgeInsets.symmetric(horizontal: 34),
        transformAlignment: Alignment.center,
        transform: Matrix4.translationValues(0, _hover ? -2 : 0, 0),
        decoration: BoxDecoration(
          gradient: AppGradients.btn,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0x4D96C8FF)),
          boxShadow: [
            BoxShadow(
              color: AppColors.blue.withValues(alpha: _hover ? 0.68 : 0.50),
              blurRadius: _hover ? 46 : 34,
              offset: Offset(0, _hover ? 14 : 10),
            ),
            const BoxShadow(color: Color(0x73000000), blurRadius: 10, offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.leading != null) ...[widget.leading!, const SizedBox(width: 12)],
            Text(widget.label, style: AppText.button.copyWith(color: Colors.white)),
            if (widget.trailing != null) ...[
              const SizedBox(width: 14),
              AnimatedSlide(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                offset: _hover ? const Offset(0.2, 0) : Offset.zero,
                child: widget.trailing,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Outlined "ghost" button — surface fill, subtle hover, no glow.
class GhostButton extends StatefulWidget {
  const GhostButton({
    super.key,
    required this.label,
    required this.onTap,
    this.leading,
    this.minWidth = 168,
  });

  final String label;
  final VoidCallback onTap;
  final Widget? leading;
  final double minWidth;

  @override
  State<GhostButton> createState() => _GhostButtonState();
}

class _GhostButtonState extends State<GhostButton> {
  bool _hover = false;
  bool _focus = false;

  @override
  Widget build(BuildContext context) {
    return _Focusable(
      onTap: widget.onTap,
      onHover: (h) => setState(() => _hover = h),
      onFocus: (f) => setState(() => _focus = f),
      focused: _focus,
      semanticLabel: widget.label,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        height: 62,
        constraints: BoxConstraints(minWidth: widget.minWidth),
        padding: const EdgeInsets.symmetric(horizontal: 30),
        transformAlignment: Alignment.center,
        transform: Matrix4.translationValues(0, _hover ? -2 : 0, 0),
        decoration: BoxDecoration(
          color: _hover ? AppColors.surfaceHv : AppColors.surface1,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: _hover ? const Color(0x38FFFFFF) : AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.leading != null) ...[widget.leading!, const SizedBox(width: 12)],
            Text(widget.label, style: AppText.button.copyWith(color: AppColors.textHi)),
          ],
        ),
      ),
    );
  }
}

/// Shared interaction wrapper: mouse hover, keyboard focus ring (cyan, 2px @3px),
/// click + Enter/Space activation, and button semantics.
class _Focusable extends StatelessWidget {
  const _Focusable({
    required this.child,
    required this.onTap,
    required this.onHover,
    required this.onFocus,
    required this.focused,
    required this.semanticLabel,
  });

  final Widget child;
  final VoidCallback onTap;
  final ValueChanged<bool> onHover;
  final ValueChanged<bool> onFocus;
  final bool focused;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        onShowHoverHighlight: onHover,
        onShowFocusHighlight: onFocus,
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) {
            onTap();
            return null;
          }),
        },
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            padding: EdgeInsets.all(focused ? 3 : 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: focused ? AppColors.cyan : Colors.transparent,
                width: 2,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
