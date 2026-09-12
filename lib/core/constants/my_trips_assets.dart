/// The glyphs and artwork exported from the "رحلاتي" Figma frames.
///
/// The raw export lives in `screens/my-trips/exports/`; what the app actually
/// bundles was harvested from it into the flat `assets/images/{svgs,pngs}`
/// folders the rest of the app reads, under names that say what each file is.
///
/// Only the files that were **not** already in the bundle are listed here.
/// Where the design's glyph turned out to be one the app already ships, the
/// existing constant stays in use rather than a second copy being added.
class MyTripsAssets {
  MyTripsAssets._();

  static const String _svgs = 'assets/images/svgs';
  static const String _pngs = 'assets/images/pngs';

  // ── Document actions ─────────────────────────────────────────────────────
  // These four replaced Material icons that were standing in for them.
  static const String download = '$_svgs/download.svg';
  static const String link = '$_svgs/link.svg';
  static const String thumbUp = '$_svgs/thumb_up.svg';
  static const String chevronUp = '$_svgs/chevron_up.svg';

  /// "معاينة". Already bundled for the auth and profile flows; named here so
  /// the document cards do not reach into another feature's registry.
  static const String preview = '$_svgs/visibility.svg';

  // ── Document fields ──────────────────────────────────────────────────────
  /// "رقم التأشيرة" — the numbered-list glyph (designs 16–18).
  static const String serialNumber = '$_svgs/serial_number.svg';

  /// "نوع التذكرة" — the lettered-specimen glyph (designs 21–23).
  static const String ticketType = '$_svgs/type_specimen.svg';

  /// "نوع التأشيرة".
  static const String visaType = '$_svgs/id_card_2.svg';

  static const String luggage = '$_svgs/luggage.svg';
  static const String checkSmall = '$_svgs/check_small.svg';
  static const String locationPin = '$_svgs/location_pin.svg';

  // ── Printed card faces ───────────────────────────────────────────────────
  /// The mosque skyline behind the pilgrim card and the luggage tag
  /// (designs 7, 8, 13). Drawn bottom-aligned and faint.
  static const String cardWatermark = '$_pngs/card_watermark_skyline.png';

  /// Stands in until a card resource publishes its own `qr_url`.
  static const String qrPlaceholder = '$_pngs/qr_placeholder.png';

  // ── Route maps ───────────────────────────────────────────────────────────
  // The design draws a different map per mode of travel (designs 14, 24–26),
  // each with the vehicle traced along the route.
  static const String routeMapAir = '$_pngs/route_map_air.png';
  static const String routeMapTrain = '$_pngs/route_map_train.png';
  static const String routeMapSea = '$_pngs/route_map_sea.png';
  static const String routeMapLand = '$_pngs/route_map_land.png';

  /// The place and meeting-point maps on an activity (designs 28–30).
  static const String activityPlaceMap = '$_pngs/activity_place_map.png';

  static const List<String> all = [
    download,
    link,
    thumbUp,
    chevronUp,
    preview,
    serialNumber,
    ticketType,
    visaType,
    luggage,
    checkSmall,
    locationPin,
    cardWatermark,
    qrPlaceholder,
    routeMapAir,
    routeMapTrain,
    routeMapSea,
    routeMapLand,
    activityPlaceMap,
  ];
}
