/// Responsive breakpoints and layout constants shared across sections.
abstract class Breakpoints {
  static const double xl = 1440;
  static const double lg = 1200;
  static const double md = 1024;
  static const double sm = 900;
  static const double xs = 768;
  static const double xxs = 560;

  static const double maxContent = 1360;
  static const double headerH = 88;

  /// Side padding for the content container at a given viewport width.
  static double gutter(double w) => w >= xl
      ? 88
      : w >= lg
          ? 64
          : w >= md
              ? 48
              : w >= xs
                  ? 32
                  : w >= xxs
                      ? 22
                      : 18;
}
