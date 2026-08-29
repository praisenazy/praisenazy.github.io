import 'package:flutter/material.dart';

import 'portfolio_data.dart';
import 'sections.dart';
import 'theme.dart';
import 'widgets.dart';

void main() => runApp(const PortfolioApp());

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '${PortfolioData.name} — ${PortfolioData.role}',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Keys mark scroll targets so the nav can jump to each section.
    final aboutKey = GlobalKey();
    final skillsKey = GlobalKey();
    final workKey = GlobalKey();
    final contactKey = GlobalKey();

    Future<void> scrollTo(GlobalKey key) async {
      final ctx = key.currentContext;
      if (ctx == null) return;
      await Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }

    return Scaffold(
      body: Column(
        children: [
          _NavBar(
            onAbout: () => scrollTo(aboutKey),
            onSkills: () => scrollTo(skillsKey),
            onWork: () => scrollTo(workKey),
            onContact: () => scrollTo(contactKey),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  HeroSection(
                    onContact: () => scrollTo(contactKey),
                    onProjects: () => scrollTo(workKey),
                  ),
                  KeyedSubtree(key: aboutKey, child: const AboutSection()),
                  KeyedSubtree(key: skillsKey, child: const SkillsSection()),
                  KeyedSubtree(key: workKey, child: const ProjectsSection()),
                  KeyedSubtree(key: contactKey, child: const ContactSection()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A fixed top navigation bar. Shows section links on wide screens; on narrow
/// screens it collapses to the name + a GitHub button.
class _NavBar extends StatelessWidget {
  const _NavBar({
    required this.onAbout,
    required this.onSkills,
    required this.onWork,
    required this.onContact,
  });

  final VoidCallback onAbout;
  final VoidCallback onSkills;
  final VoidCallback onWork;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 760;

    return Container(
      height: 68,
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: kMaxContentWidth),
          child: Row(
            children: [
              GradientText(
                PortfolioData.name,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const Spacer(),
              if (wide) ...[
                _NavLink('About', onAbout),
                _NavLink('Skills', onSkills),
                _NavLink('Projects', onWork),
                _NavLink('Contact', onContact),
                const SizedBox(width: 12),
              ],
              const GhostButton(
                label: 'GitHub',
                icon: Icons.code_rounded,
                url: PortfolioData.githubUrl,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  const _NavLink(this.label, this.onTap);
  final String label;
  final VoidCallback onTap;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Text(
            widget.label,
            style: TextStyle(
              color: _hover ? AppColors.textHigh : AppColors.textMid,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
