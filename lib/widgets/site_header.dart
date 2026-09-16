import 'dart:ui' show ImageFilter;

import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme.dart';
import '../theme/app_text.dart';
import '../theme/breakpoints.dart';
import 'hero_widgets.dart' show GradientText;
import 'site_icons.dart';

class SiteHeader extends StatefulWidget {
  const SiteHeader({
    super.key,
    required this.stuck,
    required this.onLogo,
    required this.onNav,
    required this.onGithub,
  });

  final ValueListenable<bool> stuck;
  final VoidCallback onLogo;
  final void Function(String id) onNav; // about / skills / projects / contact
  final VoidCallback onGithub;

  @override
  State<SiteHeader> createState() => _SiteHeaderState();
}

class _SiteHeaderState extends State<SiteHeader> {
  bool _menuOpen = false;

  void _close() => setState(() => _menuOpen = false);

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final wide = w >= Breakpoints.sm;
    if (wide && _menuOpen) _menuOpen = false;

    return Semantics(
      header: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: widget.stuck,
            builder: (_, stuck, _) => _bar(context, w, wide, stuck),
          ),
          if (_menuOpen && !wide) _panel(context, w),
        ],
      ),
    );
  }

  Widget _bar(BuildContext context, double w, bool wide, bool stuck) {
    final bar = SizedBox(
      height: Breakpoints.headerH,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Breakpoints.maxContent),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Breakpoints.gutter(w)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _Logo(onTap: widget.onLogo),
                if (wide)
                  Row(
                    children: [
                      NavLink('About', active: true, onTap: () => widget.onNav('about')),
                      const SizedBox(width: 34),
                      NavLink('Skills', onTap: () => widget.onNav('skills')),
                      const SizedBox(width: 34),
                      NavLink('Projects', onTap: () => widget.onNav('projects')),
                      const SizedBox(width: 34),
                      NavLink('Contact', onTap: () => widget.onNav('contact')),
                      const SizedBox(width: 28),
                      Container(width: 1, height: 22, color: AppColors.divider),
                      const SizedBox(width: 28),
                      _GithubItem(onTap: widget.onGithub),
                    ],
                  )
                else
                  _Hamburger(
                    open: _menuOpen,
                    onTap: () => setState(() => _menuOpen = !_menuOpen),
                  ),
              ],
            ),
          ),
        ),
      ),
    );

    final decoration = BoxDecoration(
      color: stuck ? AppColors.bg900.withValues(alpha: 0.72) : Colors.transparent,
      border: Border(
        bottom: BorderSide(color: stuck ? AppColors.borderSft : Colors.transparent),
      ),
    );

    if (!stuck) return DecoratedBox(decoration: decoration, child: bar);
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: DecoratedBox(decoration: decoration, child: bar),
      ),
    );
  }

  Widget _panel(BuildContext context, double w) {
    final items = [
      ('About', 'about'),
      ('Skills', 'skills'),
      ('Projects', 'projects'),
      ('Contact', 'contact'),
    ];
    return Focus(
      autofocus: true,
      onKeyEvent: (_, e) {
        if (e is KeyDownEvent && e.logicalKey == LogicalKeyboardKey.escape) {
          _close();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        builder: (_, t, child) => Opacity(
          opacity: t,
          child: Transform.translate(offset: Offset(0, -8 * (1 - t)), child: child),
        ),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: Breakpoints.gutter(w), vertical: 24),
              decoration: BoxDecoration(
                color: AppColors.bg900.withValues(alpha: 0.96),
                border: const Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final it in items) ...[
                    _MobileLink(
                      it.$1,
                      onTap: () {
                        _close();
                        widget.onNav(it.$2);
                      },
                    ),
                    const SizedBox(height: 22),
                  ],
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      _close();
                      widget.onGithub();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const GithubMark(size: 22, color: AppColors.textHi),
                        const SizedBox(width: 10),
                        Text('GitHub', style: AppText.nav.copyWith(fontSize: 19, color: AppColors.textHi)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatefulWidget {
  const _Logo({required this.onTap});
  final VoidCallback onTap;
  @override
  State<_Logo> createState() => _LogoState();
}

class _LogoState extends State<_Logo> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'P',
                  style: AppText.mono.copyWith(
                    fontSize: 36,
                    color: AppColors.blueLt,
                    shadows: [
                      Shadow(
                        color: Color(_hover ? 0xBF50B4FF : 0x8C3C96FF),
                        blurRadius: _hover ? 20 : 14,
                      ),
                    ],
                  ),
                ),
                Transform.translate(
                  offset: const Offset(-3, 0),
                  child: GradientText('A', gradient: AppGradients.logo,
                      style: AppText.mono.copyWith(fontSize: 36)),
                ),
              ],
            ),
            const SizedBox(width: 14),
            Text('Praise Anyigor', style: AppText.wordmark),
          ],
        ),
      ),
    );
  }
}

class NavLink extends StatefulWidget {
  const NavLink(this.label, {super.key, this.active = false, required this.onTap});
  final String label;
  final bool active;
  final VoidCallback onTap;
  @override
  State<NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<NavLink> {
  bool _hover = false;

  double _measure() {
    final tp = TextPainter(
      text: TextSpan(text: widget.label, style: AppText.nav),
      textDirection: TextDirection.ltr,
    )..layout();
    return tp.width;
  }

  @override
  Widget build(BuildContext context) {
    final on = widget.active || _hover;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Semantics(
          button: true,
          selected: widget.active,
          label: widget.label,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.label,
                  style: AppText.nav.copyWith(color: on ? AppColors.textHi : AppColors.textMut)),
              const SizedBox(height: 10),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                height: 2,
                width: widget.active ? _measure() : 0,
                decoration: BoxDecoration(
                  color: AppColors.cyan,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [BoxShadow(color: AppColors.cyan.withValues(alpha: 0.7), blurRadius: 10)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GithubItem extends StatefulWidget {
  const _GithubItem({required this.onTap});
  final VoidCallback onTap;
  @override
  State<_GithubItem> createState() => _GithubItemState();
}

class _GithubItemState extends State<_GithubItem> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    final color = _hover ? AppColors.bluePale : AppColors.textHi;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Semantics(
          button: true,
          label: 'GitHub profile',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GithubMark(size: 22, color: color),
              const SizedBox(width: 10),
              Text('GitHub', style: AppText.nav.copyWith(color: color)),
            ],
          ),
        ),
      ),
    );
  }
}

class _MobileLink extends StatelessWidget {
  const _MobileLink(this.label, {required this.onTap});
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Text(label, style: AppText.nav.copyWith(fontSize: 19, color: AppColors.textMid)),
    );
  }
}

class _Hamburger extends StatelessWidget {
  const _Hamburger({required this.open, required this.onTap});
  final bool open;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Semantics(
          button: true,
          label: open ? 'Close menu' : 'Open menu',
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < 3; i++) ...[
                  Container(width: 20, height: 2, color: AppColors.textHi),
                  if (i < 2) const SizedBox(height: 5),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
