/// The glyphs "الإعدادات" prints. Every path here is already bundled for
/// another flow — the screen borrows rather than ships a second copy of the
/// same mark.
class SettingsAssets {
  SettingsAssets._();

  static const String _svgs = 'assets/images/svgs';
  static const String _pngs = 'assets/images/pngs';

  // ── الإشعارات ────────────────────────────────────────────────────────────
  static const String push = '$_svgs/notifications.svg';
  static const String geofence = '$_svgs/my_location.svg';
  static const String tripUpdates = '$_svgs/flight.svg';

  // ── الخصوصية والأمان ─────────────────────────────────────────────────────
  static const String biometric = '$_svgs/lock.svg';
  static const String liveLocation = '$_svgs/location_pin.svg';

  // ── التفضيلات ────────────────────────────────────────────────────────────
  static const String language = '$_svgs/globel.svg';

  // ── الدعم ────────────────────────────────────────────────────────────────
  static const String chat = '$_svgs/chat.svg';
  static const String call = '$_svgs/phone_enabled.svg';
  static const String faq = '$_pngs/drawer_faq.png';
  static const String report = '$_svgs/description.svg';

  // ── حول ──────────────────────────────────────────────────────────────────
  static const String version = '$_svgs/info.svg';
  static const String privacy = '$_svgs/shield.svg';
  static const String terms = '$_svgs/menu_book.svg';

  // ── Footer ───────────────────────────────────────────────────────────────
  static const String logout = '$_svgs/logout.svg';
  static const String chevron = '$_svgs/chevron_forward.svg';
  static const List<String> all = [
    push,
    geofence,
    tripUpdates,
    biometric,
    liveLocation,
    language,
    chat,
    call,
    faq,
    report,
    version,
    privacy,
    terms,
    logout,
    chevron,
  ];
}
