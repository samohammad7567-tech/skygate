class DrawerAssets {
  DrawerAssets._();

  static const String _pngs = 'assets/images/pngs';

  // ── Destinations ─────────────────────────────────────────────────────────
  static const String home = '$_pngs/drawer_home.png';
  static const String trips = '$_pngs/drawer_trips.png';
  static const String account = '$_pngs/drawer_account.png';

  // ── خدمات المعتمر ────────────────────────────────────────────────────────
  static const String lostItems = '$_pngs/drawer_lost_items.png';
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
    account,
    lostItems,
    privateTrips,
    alerts,
    support,
    faq,
    logout,
  ];
}
