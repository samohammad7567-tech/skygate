/// App-wide bundled images — the brand mark, the shared fallback, and the
/// onboarding illustrations.
///
/// Feature-specific artwork lives in its own registry next to this one:
/// [HomeAssets], [AuthAssets], [SplashAssets], [FirstSectionAssets].
class AppAssets {
  AppAssets._();

  static const String _images = 'assets/images';

  // ── Brand ────────────────────────────────────────────────────────────────
  /// Sky Gate wordmark + بوابة السماء lockup, shown in the home header.
  static const String logo = '$_images/logo.svg';

  // ── Onboarding illustrations ─────────────────────────────────────────────
  /// One illustration per onboarding page, in page order (RTL: page 1 first).
  ///
  /// Cropped from the mockups in `SCREENS/on_boarding*.png` at 384x308, so they
  /// carry the page background rather than being transparent. Replace each with
  /// the Figma export at the same file name when it is available.
  static const String onboarding1 = '$_images/onboarding/onboarding_1.png';
  static const String onboarding2 = '$_images/onboarding/onboarding_2.png';
  static const String onboarding3 = '$_images/onboarding/onboarding_3.png';
  static const String onboarding4 = '$_images/onboarding/onboarding_4.png';
  static const String onboarding5 = '$_images/onboarding/onboarding_5.png';

  /// The five illustrations in page order.
  static const List<String> onboarding = [
    onboarding1,
    onboarding2,
    onboarding3,
    onboarding4,
    onboarding5,
  ];

  // ── Fallbacks ────────────────────────────────────────────────────────────
  /// Shown by [AppImage] / [CachedImage] while loading or on error.
  static const String placeholder = '$_images/placeholder.png';

  /// Every asset above, in declaration order. Handy for smoke tests that
  /// assert the bundle actually contains each file.
  static const List<String> all = [logo, placeholder, ...onboarding];
}
