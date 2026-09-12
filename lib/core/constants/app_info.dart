/// Facts about the build itself that the UI prints.
class AppInfo {
  AppInfo._();

  /// Kept in step with `version:` in pubspec.yaml, and overridable per build
  /// so a flavour can print what it actually shipped:
  /// `--dart-define=APP_VERSION=2.5.1`.
  static const String version = String.fromEnvironment(
    'APP_VERSION',
    defaultValue: '1.0.0',
  );
}
