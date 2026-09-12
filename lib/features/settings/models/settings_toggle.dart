/// The switches "الإعدادات" carries, and the key each one is remembered under.
///
/// None of them has an endpoint yet — the published API has nothing for
/// notification or privacy preferences — so the choice lives on the device and
/// the cubit is the only thing that touches storage.
enum SettingsToggle {
  push('settings_push', true),
  geofence('settings_geofence', true),
  tripUpdates('settings_trip_updates', true),
  biometric('settings_biometric', true),
  liveLocation('settings_live_location', true);

  const SettingsToggle(this.cacheKey, this.byDefault);

  final String cacheKey;

  /// What a device that has never been asked answers. The design shows every
  /// switch on, which is what a pilgrim being tracked by their group expects.
  final bool byDefault;
}
