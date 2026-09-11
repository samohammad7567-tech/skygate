class MapAssets {
  MapAssets._();

  static const String _svgs = 'assets/images/svgs';
  static const String _pngs = 'assets/images/pngs';

  // ── Artwork ──────────────────────────────────────────────────────────────
  static const String protocolShield = '$_pngs/map_protocol_shield.png';
  static const String trackingStopped = '$_pngs/map_tracking_stopped.png';
  static const String trackingPreview = '$_pngs/map_tracking_preview.png';

  // ── Protocol card ────────────────────────────────────────────────────────
  static const String instantAlerts = '$_svgs/fmd_bad.svg';
  static const String movementLog = '$_svgs/map_search.svg';
  static const String shield = '$_svgs/shield.svg';

  // ── Idle / stopped cards ─────────────────────────────────────────────────
  static const String trackingOff = '$_svgs/map_pin.svg';
  static const String cross = '$_svgs/close_x.svg';
  static const String documents = '$_svgs/file_text.svg';
  static const String bell = '$_svgs/notifications.svg';
  static const String tripDone = '$_svgs/check_circle_outline.svg';
  static const String chart = '$_svgs/bar_chart.svg';
  static const String calendar = '$_svgs/calendar_today.svg';
  static const String home = '$_svgs/home.svg';

  // ── GPS alert ────────────────────────────────────────────────────────────
  static const String alert = '$_svgs/alert_triangle.svg';
  static const String timer = '$_svgs/timer.svg';
  static const String pin = '$_svgs/location_on.svg';

  // ── Live view ────────────────────────────────────────────────────────────
  static const String chevronNext = '$_svgs/chevron_forward.svg';
  static const String chevronPrevious = '$_svgs/chevron_backward.svg';
  static const String recenter = '$_svgs/move.svg';
  static const String sos = '$_svgs/sos.svg';
  static const List<String> all = [
    protocolShield,
    trackingStopped,
    trackingPreview,
    instantAlerts,
    movementLog,
    shield,
    trackingOff,
    cross,
    documents,
    bell,
    tripDone,
    chart,
    calendar,
    home,
    alert,
    timer,
    pin,
    chevronNext,
    chevronPrevious,
    recenter,
    sos,
  ];
}
