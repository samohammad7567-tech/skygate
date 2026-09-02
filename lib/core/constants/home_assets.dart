/// Assets used by the home screen and the bottom navigation bar, exported to
/// `assets/images/home/`.
///
/// Load them with `AppImage`, which picks the SVG or raster decoder from the
/// file extension. The glyphs are single-colour SVGs, so every call site is
/// free to re-tint them from the theme.
class HomeAssets {
  HomeAssets._();

  static const String _svgs = 'assets/images/svgs';
  static const String _pngs = 'assets/images/pngs';

  // ── Photography ──────────────────────────────────────────────────────────
  /// Haram photo behind the travel-date search card.
  static const String heroBackground = '$_pngs/home_background.png';

  /// Kaaba photo: offer-card cover and the "صمم رحلتك الخاصة" artwork.
  static const String kaaba = '$_pngs/makka.png';

  // ── Header / chrome ──────────────────────────────────────────────────────
  static const String menu = '$_svgs/menu.svg';
  static const String notifications = '$_svgs/notifications.svg';
  static const String search = '$_svgs/search.svg';
  static const String calendar = '$_svgs/calander.svg';

  /// Clock on the "نرسل لك القبول و التفاصيل بأقرب وقت" notice.
  static const String clock = '$_svgs/schedule.svg';

  /// Crown chip on the custom-trip card. The orange rounded plate behind the
  /// crown is baked into the export, so it needs no wrapper.
  static const String crown = '$_svgs/crown.svg';

  /// Orange pennant that hangs over the custom-trip artwork.
  static const String vipPennant = '$_svgs/orange_mark.svg';

  /// Blue plate behind the custom-trip artwork; its curved edge is what shows
  /// as a rim around the photo.
  static const String artworkPlate = '$_svgs/Rectangle.svg';

  // ── Travel glyphs ────────────────────────────────────────────────────────
  /// Shared by the category pills and the offer "what's included" row.
  static const String umrah = '$_svgs/Union.svg';
  static const String flight = '$_svgs/travel.svg';
  static const String hotel = '$_svgs/domain.svg';
  static const String train = '$_svgs/train.svg';
  static const String seaTransport = '$_svgs/sailing.svg';
  static const String car = '$_svgs/local_taxi.svg';
  static const String mosque = '$_svgs/mosque.svg';

  // ── Custom-trip selling points ───────────────────────────────────────────
  static const String tripBag = '$_svgs/trip.svg';
  static const String supportAgent = '$_svgs/support_agent.svg';

  // ── Bottom navigation ────────────────────────────────────────────────────
  static const String navHome = '$_svgs/home.svg';
  static const String navTrips = '$_svgs/trip_wght.svg';
  static const String navMap = '$_svgs/map_search.svg';
  static const String navAccount = '$_svgs/account_circle_wght.svg';
  static const String navSettings = '$_svgs/settings_wght.svg';

  // ── "ماذا تشمل خدماتنا" illustrations ────────────────────────────────────
  /// The exports are numbered in the mockup's left-to-right reading order;
  /// [ServiceModel.catalogue] is what puts them back in RTL order.
  static const String serviceVipTrips = '$_pngs/1.png';
  static const String serviceSupport247 = '$_pngs/2.png';
  static const String servicePilgrimTracking = '$_pngs/3.png';
  static const String serviceFlights = '$_pngs/4.png';
  static const String serviceTrains = '$_pngs/5.png';
  static const String serviceVisitsActivities = '$_pngs/6.png';
  static const String serviceSeaTransport = '$_pngs/7.png';
  static const String serviceTransportation = '$_pngs/8.png';
  static const String serviceHotels = '$_pngs/9.png';

  /// "vip" banner drawn across the bottom of [serviceVipTrips]. It ships as a
  /// separate export at the illustration's own width, so it lines up when both
  /// are stretched to the same box.
  static const String serviceVipBanner = '$_pngs/1-onsurface_vip.png';

  /// Every asset above, for bundle smoke tests.
  static const List<String> all = [
    heroBackground,
    kaaba,
    menu,
    notifications,
    search,
    calendar,
    clock,
    crown,
    vipPennant,
    artworkPlate,
    umrah,
    flight,
    hotel,
    train,
    seaTransport,
    car,
    mosque,
    tripBag,
    supportAgent,
    navHome,
    navTrips,
    navMap,
    navAccount,
    navSettings,
    serviceVipTrips,
    serviceSupport247,
    servicePilgrimTracking,
    serviceFlights,
    serviceTrains,
    serviceVisitsActivities,
    serviceSeaTransport,
    serviceTransportation,
    serviceHotels,
    serviceVipBanner,
  ];
}
