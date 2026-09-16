import 'dart:async';

import 'package:flutter/material.dart';

import 'portfolio_data.dart';
import 'theme.dart';
import 'widgets.dart';

/// ---------------------------------------------------------------------------
/// SKILLS
/// ---------------------------------------------------------------------------
class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width < 700 ? 1 : (width < 1000 ? 2 : 3);
    final entries = PortfolioData.skills.entries.toList();

    return Section(
      background: AppColors.surface.withValues(alpha: 0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Eyebrow('Skills'),
          const SizedBox(height: 14),
          const Heading('Tools I build with'),
          const SizedBox(height: 32),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: entries.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              mainAxisExtent: 150,
            ),
            itemBuilder: (context, i) => _SkillCard(
              title: entries[i].key,
              items: entries[i].value,
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillCard extends StatelessWidget {
  const _SkillCard({required this.title, required this.items});
  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textHigh,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [for (final s in items) TagChip(s)],
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// PROJECTS  (a grid that grows as you add projects)
/// ---------------------------------------------------------------------------
class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final projects = PortfolioData.projects;

    return Section(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Eyebrow('Projects'),
          const SizedBox(height: 14),
          const Heading("Things I've built"),
          const SizedBox(height: 12),
          const Text(
            'A growing collection of apps I design and build with Flutter.',
            style: TextStyle(fontSize: 16, height: 1.6),
          ),
          const SizedBox(height: 32),
          LayoutBuilder(
            builder: (context, c) {
              final maxCols = c.maxWidth < 820 ? 1 : 2;
              // Never make more columns than there are projects.
              final columns =
                  projects.length < maxCols ? projects.length : maxCols;
              const gap = 22.0;
              final cardWidth = (c.maxWidth - gap * (columns - 1)) / columns;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (final p in projects)
                    SizedBox(width: cardWidth, child: _ProjectCard(p)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  const _ProjectCard(this.project);
  final Project project;

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.project;
    final initial = p.name.isNotEmpty ? p.name[0] : '?';

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        transform: Matrix4.translationValues(0, _hover ? -4 : 0, 0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.surface,
              AppColors.surfaceAlt.withValues(alpha: 0.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _hover ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Showcase(
              images: p.screenshots.isNotEmpty
                  ? p.screenshots
                  : (p.imageAsset != null
                      ? <String>[p.imageAsset!]
                      : const <String>[]),
              initial: initial,
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          p.name,
                          style: const TextStyle(
                            color: AppColors.textHigh,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      if (p.status != null) _StatusBadge(p.status!),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    p.tagline,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    p.description,
                    style: const TextStyle(fontSize: 15, height: 1.6),
                  ),
                  if (p.highlights.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    for (final h in p.highlights)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle_rounded,
                                size: 18, color: AppColors.accent),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(h,
                                  style: const TextStyle(
                                      fontSize: 14, height: 1.4)),
                            ),
                          ],
                        ),
                      ),
                  ],
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [for (final t in p.tech) TagChip(t)],
                  ),
                  const SizedBox(height: 22),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      if (p.demoUrl != null)
                        PrimaryButton(
                          label: 'Live demo',
                          icon: Icons.open_in_new_rounded,
                          url: p.demoUrl,
                        ),
                      if (p.repoUrl != null)
                        GhostButton(
                          label: 'View code',
                          icon: Icons.code_rounded,
                          url: p.repoUrl,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A small pill badge, e.g. "Live" or "In progress".
class _StatusBadge extends StatelessWidget {
  const _StatusBadge(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration:
                const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: AppColors.accent,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// An eye-catching, animated project showcase: a phone that gently floats and
/// cross-fades through the project's screenshots over a soft pulsing glow.
class _Showcase extends StatefulWidget {
  const _Showcase({required this.images, required this.initial});
  final List<String> images;
  final String initial;

  @override
  State<_Showcase> createState() => _ShowcaseState();
}

class _ShowcaseState extends State<_Showcase> with TickerProviderStateMixin {
  late final AnimationController _float = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat(reverse: true);
  late final AnimationController _glow = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 4),
  )..repeat(reverse: true);
  Timer? _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    if (widget.images.length > 1) {
      _timer = Timer.periodic(const Duration(milliseconds: 2800), (_) {
        if (mounted) {
          setState(() => _index = (_index + 1) % widget.images.length);
        }
      });
    }
  }

  void _goTo(int i) {
    setState(() => _index = i);
    _startTimer(); // restart the auto-advance after a manual tap
  }

  @override
  void dispose() {
    _timer?.cancel();
    _float.dispose();
    _glow.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasImages = widget.images.isNotEmpty;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: SizedBox(
        height: 470,
        width: double.infinity,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.surfaceAlt, AppColors.surface],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Soft pulsing glow behind the phone.
              AnimatedBuilder(
                animation: _glow,
                builder: (context, _) => Container(
                  width: 220 + _glow.value * 34,
                  height: 220 + _glow.value * 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.38),
                        AppColors.accent.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
              // Floating phone.
              AnimatedBuilder(
                animation: _float,
                builder: (context, child) {
                  final t = Curves.easeInOut.transform(_float.value);
                  return Transform.translate(
                    offset: Offset(0, -8 + t * 16),
                    child: child,
                  );
                },
                child: _phone(hasImages),
              ),
              // Dots (only when there's more than one screenshot).
              if (widget.images.length > 1)
                Positioned(
                  bottom: 16,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int i = 0; i < widget.images.length; i++)
                        GestureDetector(
                          onTap: () => _goTo(i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: i == _index ? 22 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: i == _index
                                  ? AppColors.primary
                                  : Colors.white.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _phone(bool hasImages) {
    const w = 168.0, h = 388.0, radius = 30.0;
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12), width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 44,
            spreadRadius: -6,
            offset: const Offset(0, 18),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 30,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(radius - 2),
            child: hasImages
                ? AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    child: Image.asset(
                      widget.images[_index],
                      key: ValueKey<int>(_index),
                      fit: BoxFit.cover,
                      width: w,
                      height: h,
                      errorBuilder: (_, _, _) => _placeholder(),
                    ),
                  )
                : _placeholder(),
          ),
          // Notch.
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: 46,
            height: 14,
            decoration: BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return SizedBox(
      width: 168,
      height: 388,
      child: Center(
        child: GradientText(
          widget.initial,
          style: const TextStyle(fontSize: 56, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// CONTACT + FOOTER
/// ---------------------------------------------------------------------------
class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Section(
      background: AppColors.surface.withValues(alpha: 0.4),
      child: Column(
        children: [
          const Eyebrow('Contact'),
          const SizedBox(height: 14),
          const Heading("Let's work together"),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: const Text(
              "I'm open to Flutter developer roles and freelance work. "
              "The fastest way to reach me is by email.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
          ),
          const SizedBox(height: 28),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            alignment: WrapAlignment.center,
            children: [
              PrimaryButton(
                label: PortfolioData.email,
                icon: Icons.mail_rounded,
                url: 'mailto:${PortfolioData.email}',
              ),
              const GhostButton(
                label: 'GitHub',
                icon: Icons.code_rounded,
                url: PortfolioData.githubUrl,
              ),
              if (PortfolioData.linkedinUrl.isNotEmpty)
                const GhostButton(
                  label: 'LinkedIn',
                  icon: Icons.link_rounded,
                  url: PortfolioData.linkedinUrl,
                ),
            ],
          ),
          const SizedBox(height: 64),
          Divider(color: AppColors.border),
          const SizedBox(height: 20),
          Text(
            '© 2026 ${PortfolioData.name} · Built with Flutter',
            style: const TextStyle(color: AppColors.textLow, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
