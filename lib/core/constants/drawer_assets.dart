class DrawerAssets {
  DrawerAssets._();

  static const String _pngs = 'assets/images/pngs';
  static const String _svgs = 'assets/images/svgs';

  // ── Destinations ─────────────────────────────────────────────────────────
  static const String home = '$_pngs/drawer_home.png';
  static const String trips = '$_pngs/drawer_trips.png';

  /// The two rows the drawer shares with the bottom bar but has no PNG for;
  /// they borrow the bar's own glyphs so both surfaces name the destination
  /// with the same mark.
  static const String map = '$_svgs/map_search.svg';
  static const String account = '$_pngs/drawer_account.png';
  static const String settings = '$_svgs/settings_wght.svg';

  // ── خدمات المعتمر ────────────────────────────────────────────────────────
  static const String lostItems = '$_pngs/drawer_lost_items.png';
  static const String amendBookings = '$_svgs/description.svg';
  static const String privateTrips = '$_pngs/drawer_private_trips.png';
  static const String alerts = '$_pngs/drawer_alerts.png';

  // ── الدعم ────────────────────────────────────────────────────────────────
  static const String support = '$_pngs/drawer_support.png';
  static const String faq = '$_pngs/drawer_faq.png';

  // ── Footer ───────────────────────────────────────────────────────────────
  static const String logout = '$_pngs/drawer_logout.png';
  static const List<String> all = [
    home,
    trips,
    map,
    account,
    settings,
    lostItems,
    amendBookings,
    privateTrips,
    alerts,
    support,
    faq,
    logout,
  ];
}
