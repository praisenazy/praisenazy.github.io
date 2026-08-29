/// ============================================================================
///  EDIT YOUR CONTENT HERE
/// ----------------------------------------------------------------------------
///  Everything shown on the site comes from this one file, so you can update
///  your details without touching the layout code. Fields marked "TODO" need
///  your real values.
/// ============================================================================
library;

class PortfolioData {
  // ---- Identity ----
  static const String name = 'Anyigor Praise';
  static const String role = 'Flutter Developer';
  static const String initials = 'AP'; // shown in the avatar circle
  static const String tagline =
      'I build polished, offline-first mobile apps with Flutter.';

  // A short intro shown under the hero heading.
  static const String heroIntro =
      'Flutter developer focused on clean UI, smooth UX, and shipping real, '
      'usable apps. I recently built NairaTrack — a full offline expense '
      'tracker for Nigerian Naira.';

  // ---- About (each string is its own paragraph) ----
  static const List<String> about = [
    "I'm a Flutter developer from Nigeria who fell in love with building "
        "apps that feel great to use. Over close to two years I've gone from "
        "learning Dart to shipping complete, polished apps.",
    "I care about the details — responsive layouts that work on any screen, "
        "smooth animations, thoughtful empty states, and code that's clean and "
        "easy to maintain. I'm looking for a Flutter developer role where I "
        "can keep building great products.",
  ];

  // ---- Contact / links ----
  static const String email = 'nazypraise93@gmail.com'; // TODO: confirm email
  static const String githubUrl = 'https://github.com/praisenazy';
  static const String linkedinUrl = ''; // TODO: add your LinkedIn URL (or leave '')
  static const String twitterUrl = ''; // TODO: optional X/Twitter URL

  // ---- Skills (grouped) ----
  static const Map<String, List<String>> skills = {
    'Languages': ['Dart'],
    'Framework': ['Flutter', 'Material 3'],
    'State management': ['Riverpod'],
    'Local data': ['Hive'],
    'UI & UX': ['Responsive design', 'Animations', 'Charts (fl_chart)'],
    'Tooling': ['Git & GitHub', 'GitHub Actions (CI/CD)', 'VS Code'],
  };

  // ---- Projects ----
  // Add a new project by copying one Project(...) block and filling it in.
  // It will automatically appear as a new card on the site.
  static const List<Project> projects = [
    Project(
      name: 'NairaTrack',
      tagline: 'Offline-first expense tracker for Nigerian Naira (₦).',
      description:
          'A full personal-finance app — budgets, an animated insights donut, '
          'custom emoji categories, light/dark theming, and JSON backup, '
          'restore & share. No account and no backend: your data lives on '
          'your device.',
      highlights: [
        'Offline-first with Hive local storage',
        'Animated insights donut (fl_chart)',
        'Backup, restore & share your data',
        'Deployed to the web via GitHub Actions',
      ],
      tech: ['Flutter', 'Riverpod', 'Hive', 'fl_chart'],
      demoUrl: 'https://praisenazy.github.io/expense-tracker/',
      repoUrl: 'https://github.com/praisenazy/expense-tracker',
      imageAsset: 'assets/screenshots/home.png',
      status: 'Live',
    ),

    // 👇 Your next project goes here. For example:
    // Project(
    //   name: 'My Next App',
    //   tagline: 'One line about what it does.',
    //   description: 'A longer paragraph describing the project.',
    //   highlights: ['Key thing 1', 'Key thing 2'],
    //   tech: ['Flutter', 'Firebase'],
    //   demoUrl: 'https://...',        // optional
    //   repoUrl: 'https://github.com/...',
    //   imageAsset: 'assets/screenshots/mynextapp.png', // optional
    //   status: 'In progress',         // optional badge
    // ),
  ];
}

/// A single portfolio project. Everything optional can be left out.
class Project {
  const Project({
    required this.name,
    required this.tagline,
    required this.description,
    required this.tech,
    this.highlights = const [],
    this.demoUrl,
    this.repoUrl,
    this.imageAsset,
    this.status,
  });

  final String name;
  final String tagline;
  final String description;
  final List<String> tech;
  final List<String> highlights;
  final String? demoUrl; // live demo link (omit if none)
  final String? repoUrl; // source code link
  final String? imageAsset; // screenshot shown on the card
  final String? status; // small badge, e.g. 'Live' or 'In progress'
}
