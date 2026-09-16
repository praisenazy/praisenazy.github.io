import 'package:flutter/material.dart';

import '../theme.dart';

enum FadeSide { left, right }

/// A 1px hairline that fades to transparent at one end (or both, for [full]).
class FadingRule extends StatelessWidget {
  const FadingRule({
    super.key,
    this.width,
    this.maxWidth,
    this.fadeToward = FadeSide.left,
    this.full = false,
  });

  const FadingRule.full({super.key, this.maxWidth})
      : width = null,
        fadeToward = FadeSide.left,
        full = true;

  final double? width;
  final double? maxWidth;
  final FadeSide fadeToward;
  final bool full;

  @override
  Widget build(BuildContext context) {
    final bright = AppColors.cyan.withValues(alpha: 0.75);
    final colors = full
        ? const [Color(0x00FFFFFF), Color(0x1AFFFFFF), Color(0x00FFFFFF)]
        : (fadeToward == FadeSide.left
            ? [Colors.transparent, bright]
            : [bright, Colors.transparent]);
    Widget rule = Container(
      width: width ?? double.infinity,
      height: 1,
      decoration: BoxDecoration(gradient: LinearGradient(colors: colors)),
    );
    if (maxWidth != null) {
      rule = ConstrainedBox(constraints: BoxConstraints(maxWidth: maxWidth!), child: rule);
    }
    return rule;
  }
}
