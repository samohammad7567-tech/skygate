/// Video played on launch, before the service-choice screen.
///
/// The clip comes from the tourism app, which used it as its own splash; it is
/// now the whole app's entry, so it lives in the shared registry rather than
/// inside a feature.
class LaunchAssets {
  LaunchAssets._();

  static const String _videos = 'assets/videos';

  /// Brand animation, ~2s, plays once and is not looped.
  static const String splashVideo = '$_videos/splash.mp4';

  /// Every asset above, for bundle smoke tests.
  static const List<String> all = [splashVideo];
}
