import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'sections.dart';
import 'sections/about_section.dart';
import 'sections/hero_section.dart';
import 'sections/skills_section.dart';
import 'theme.dart';
import 'theme/breakpoints.dart';
import 'widgets/site_header.dart';

const _githubUrl = 'https://github.com/praisenazy';
const _email = 'nazypraise93@gmail.com';

void main() => runApp(const PortfolioApp());

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Praise Anyigor — Flutter Developer',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scroll = ScrollController();
  final ValueNotifier<bool> _stuck = ValueNotifier<bool>(false);

  // Section anchors. Only some exist today; missing ones no-op safely.
  final Map<String, GlobalKey> _keys = {
    'about': GlobalKey(),
    'skills': GlobalKey(),
    'projects': GlobalKey(),
    'contact': GlobalKey(),
  };

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      final s = _scroll.offset > 40;
      if (s != _stuck.value) _stuck.value = s;
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    _stuck.dispose();
    super.dispose();
  }

  Future<void> _scrollTo(String id) async {
    final ctx = _keys[id]?.currentContext;
    if (ctx == null) return; // section not present yet → safe no-op
    await Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeInOutCubic,
      alignment: 0.0,
    );
  }

  void _toTop() => _scroll.animateTo(0,
      duration: const Duration(milliseconds: 650), curve: Curves.easeInOutCubic);

  Future<void> _openGithub() =>
      launchUrl(Uri.parse(_githubUrl), mode: LaunchMode.externalApplication);
  Future<void> _openMail() => launchUrl(Uri.parse('mailto:$_email'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.bg900, AppColors.bg850, AppColors.bg800],
                  stops: [0.0, 0.46, 1.0],
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            controller: _scroll,
            child: Column(
              children: [
                const SizedBox(height: Breakpoints.headerH),
                HeroSection(
                  onProjects: () => _scrollTo('projects'),
                  onContact: _openMail,
                  onGithub: _openGithub,
                ),
                const SizedBox(height: 20),
                KeyedSubtree(key: _keys['about'], child: const AboutSection()),
                KeyedSubtree(key: _keys['skills'], child: const SkillsSection()),
                // ── LATER SECTIONS GET APPENDED HERE ──
                // (Existing sections kept below; they will be redesigned next.)
                KeyedSubtree(key: _keys['projects'], child: const ProjectsSection()),
                KeyedSubtree(key: _keys['contact'], child: const ContactSection()),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SiteHeader(
              stuck: _stuck,
              onLogo: _toTop,
              onNav: _scrollTo,
              onGithub: _openGithub,
            ),
          ),
        ],
      ),
    );
  }
}
