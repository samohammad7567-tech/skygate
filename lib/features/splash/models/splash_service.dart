/// The two service lines the splash screen lets the user enter the app with.
///
/// The choice is persisted by [SplashCubit] so later features can tailor the
/// catalogue they show; [cacheValue] is what lands in SharedPreferences and
/// must stay stable, [labelKey] is the button copy.
enum SplashService {
  tourism('tourism', 'tourism_services'),
  umrah('umrah', 'umrah_services');

  const SplashService(this.cacheValue, this.labelKey);

  final String cacheValue;
  final String labelKey;

  /// Reads back a persisted [cacheValue]; `null` when nothing was stored yet
  /// or the stored value is no longer known.
  static SplashService? fromCache(Object? value) {
    for (final service in SplashService.values) {
      if (service.cacheValue == value) return service;
    }
    return null;
  }
}
