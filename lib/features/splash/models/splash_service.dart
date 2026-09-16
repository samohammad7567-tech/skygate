enum SplashService {
  tourism('tourism', 'tourism_services'),
  umrah('umrah', 'umrah_services');

  const SplashService(this.cacheValue, this.labelKey);

  final String cacheValue;
  final String labelKey;
  static SplashService? fromCache(Object? value) {
    for (final service in SplashService.values) {
      if (service.cacheValue == value) return service;
    }
    return null;
  }
}
