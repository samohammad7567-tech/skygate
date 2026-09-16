enum SettingsToggle {
  push('settings_push', true),
  geofence('settings_geofence', true),
  tripUpdates('settings_trip_updates', true),
  biometric('settings_biometric', true),
  liveLocation('settings_live_location', true);

  const SettingsToggle(this.cacheKey, this.byDefault);

  final String cacheKey;
  final bool byDefault;
}
