/// Photos behind the splash entry screen, exported to
/// `assets/images/splash/png/`.
///
/// They are full-bleed photography, not illustrations, so they are drawn with
/// `BoxFit.cover` and read the blue scrim from the theme rather than carrying
/// it baked in.
class SplashAssets {
  SplashAssets._();

  static const String _png = 'assets/images/splash/png';

  /// Kaaba and the Makkah clock tower.
  static const String background1 = '$_png/back_ground1.png';

  /// Bahrain World Trade Center at dusk.
  static const String background2 = '$_png/back_ground2.png';

  /// Dubai Marina skyline from the water.
  static const String background3 = '$_png/back_ground3.png';

  /// Airliner on take-off.
  static const String background4 = '$_png/back_ground4.png';

  /// Wing above the clouds at sunset.
  static const String background5 = '$_png/back_ground5.png';

  /// The slideshow, in design order. Slide 1 is the first one shown; with the
  /// RTL locale the indicator therefore highlights its right-most dot.
  static const List<String> backgrounds = [
    background1,
    background2,
    background3,
    background4,
    background5,
  ];

  /// Every asset above, for bundle smoke tests.
  static const List<String> all = backgrounds;
}
