import 'package:flutter/material.dart';

import 'portfolio_data.dart';
import 'theme.dart';
import 'widgets.dart';

/// ---------------------------------------------------------------------------
/// HERO
/// ---------------------------------------------------------------------------
class HeroSection extends StatelessWidget {
  const HeroSection({
    super.key,
    required this.onContact,
    required this.onProjects,
  });
  final VoidCallback onContact;
  final VoidCallback onProjects;

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < 860;

    final text = FadeInUp(
      child: Column(
        crossAxisAlignment:
            narrow ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          const Eyebrow('Flutter Developer'),
          const SizedBox(height: 16),
          _headline(narrow),
          const SizedBox(height: 20),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Text(
              PortfolioData.heroIntro,
              textAlign: narrow ? TextAlign.center : TextAlign.start,
              style: const TextStyle(
                color: AppColors.textMid,
                fontSize: 17,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 28),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            alignment: narrow ? WrapAlignment.center : WrapAlignment.start,
            children: [
              PrimaryButton(
                label: 'See my work',
                icon: Icons.rocket_launch_rounded,
                onTap: onProjects,
              ),
              const GhostButton(
                label: 'GitHub',
                icon: Icons.code_rounded,
                url: PortfolioData.githubUrl,
              ),
              GhostButton(
                label: 'Get in touch',
                icon: Icons.mail_outline_rounded,
                onTap: onContact,
              ),
            ],
          ),
        ],
      ),
    );

    final avatar = FadeInUp(delayMs: 150, child: const _Avatar());

    if (narrow) {
      return Section(
        vertical: 120,
        child: Column(
          children: [avatar, const SizedBox(height: 40), text],
        ),
      );
    }

    return Section(
      vertical: 130,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(flex: 6, child: text),
          const SizedBox(width: 40),
          Expanded(flex: 4, child: Center(child: avatar)),
        ],
      ),
    );
  }

  Widget _headline(bool narrow) {
    final size = narrow ? 40.0 : 58.0;
    return Column(
      crossAxisAlignment:
          narrow ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          "Hi, I'm",
          style: TextStyle(
            color: AppColors.textHigh,
            fontSize: size,
            fontWeight: FontWeight.w800,
            height: 1.05,
          ),
        ),
        GradientText(
          PortfolioData.name,
          style: TextStyle(
            fontSize: size,
            fontWeight: FontWeight.w800,
            height: 1.05,
          ),
        ),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 540),
          child: Text(
            PortfolioData.tagline,
            textAlign: narrow ? TextAlign.center : TextAlign.start,
            style: TextStyle(
              color: AppColors.textMid,
              fontSize: narrow ? 18 : 20,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: 240,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.accentGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.45),
            blurRadius: 60,
            spreadRadius: 4,
          ),
        ],
      ),
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surface,
        ),
        alignment: Alignment.center,
        child: GradientText(
          PortfolioData.initials,
          style: const TextStyle(fontSize: 84, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// ABOUT
/// ---------------------------------------------------------------------------
class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < 860;

    final textCol = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Eyebrow('About'),
        const SizedBox(height: 14),
        const Heading('A bit about me'),
        const SizedBox(height: 20),
        for (final p in PortfolioData.about) ...[
          Text(p, style: const TextStyle(fontSize: 16, height: 1.7)),
          const SizedBox(height: 16),
        ],
      ],
    );

    const stats = _StatsPanel();

    return Section(
      child: narrow
          ? Column(children: [textCol, const SizedBox(height: 36), stats])
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 6, child: textCol),
                const SizedBox(width: 48),
                const Expanded(flex: 4, child: stats),
              ],
            ),
    );
  }
}

class _StatsPanel extends StatelessWidget {
  const _StatsPanel();

  static const _stats = [
    ('~2', 'years building with Flutter'),
    ('100%', 'offline-first — no backend'),
    ('1', 'polished app shipped to the web'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final (value, label) in _stats)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                GradientText(
                  value,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: AppColors.textMid,
                      fontSize: 15,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

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
            _Thumb(imageAsset: p.imageAsset, initial: initial),
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

/// The card's top image area: a phone mockup on a gradient panel. Shows the
/// screenshot when present, or a placeholder with the project's initial.
class _Thumb extends StatelessWidget {
  const _Thumb({required this.imageAsset, required this.initial});
  final String? imageAsset;
  final String initial;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.18),
            AppColors.accent.withValues(alpha: 0.10),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      alignment: Alignment.center,
      child: _Phone(imageAsset: imageAsset, initial: initial),
    );
  }
}

class _Phone extends StatelessWidget {
  const _Phone({required this.imageAsset, required this.initial});
  final String? imageAsset;
  final String initial;

  static const double _radius = 26;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 250,
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(_radius),
        border: Border.all(color: AppColors.border, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_radius - 2),
        child: imageAsset == null
            ? _placeholder()
            : Image.asset(
                imageAsset!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (_, _, _) => _placeholder(),
              ),
      ),
    );
  }

  Widget _placeholder() {
    return Center(
      child: GradientText(
        initial,
        style: const TextStyle(fontSize: 56, fontWeight: FontWeight.w800),
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
