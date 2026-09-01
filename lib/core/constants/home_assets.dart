/// Assets used by the home screen and the bottom navigation bar, exported to
/// `assets/images/home/`.
///
/// Load them with `AppImage`, which picks the SVG or raster decoder from the
/// file extension. The glyphs are single-colour SVGs, so every call site is
/// free to re-tint them from the theme.
class HomeAssets {
  HomeAssets._();

  static const String _root = 'assets/images/home';
  static const String _svg = '$_root/svgs';

  // ── Photography ──────────────────────────────────────────────────────────
  /// Haram photo behind the travel-date search card.
  static const String heroBackground = '$_root/back_ground.png';

  /// Kaaba photo: offer-card cover and the "صمم رحلتك الخاصة" artwork.
  static const String kaaba = '$_root/makka.png';

  // ── Header / chrome ──────────────────────────────────────────────────────
  static const String menu = '$_svg/menu.svg';
  static const String notifications = '$_svg/notifications.svg';
  static const String search = '$_svg/search.svg';
  static const String calendar = '$_svg/calander.svg';

  /// Clock on the "نرسل لك القبول و التفاصيل بأقرب وقت" notice.
  static const String clock = '$_svg/schedule.svg';

  /// Crown chip on the custom-trip card. The orange rounded plate behind the
  /// crown is baked into the export, so it needs no wrapper.
  static const String crown = '$_svg/crown.svg';

  /// Orange pennant that hangs over the custom-trip artwork.
  static const String vipPennant = '$_svg/orange_mark.svg';

  /// Blue plate behind the custom-trip artwork; its curved edge is what shows
  /// as a rim around the photo.
  static const String artworkPlate = '$_svg/Rectangle.svg';

  // ── Travel glyphs ────────────────────────────────────────────────────────
  /// Shared by the category pills and the offer "what's included" row.
  static const String umrah = '$_svg/Union.svg';
  static const String flight = '$_svg/travel.svg';
  static const String hotel = '$_svg/domain.svg';
  static const String train = '$_svg/train.svg';
  static const String seaTransport = '$_svg/sailing.svg';
  static const String car = '$_svg/local_taxi.svg';
  static const String mosque = '$_svg/mosque.svg';

  // ── Custom-trip selling points ───────────────────────────────────────────
  static const String tripBag = '$_svg/trip.svg';
  static const String supportAgent = '$_svg/support_agent.svg';

  // ── Bottom navigation ────────────────────────────────────────────────────
  static const String navHome = '$_svg/home.svg';
  static const String navTrips = '$_svg/trip_wght.svg';
  static const String navMap = '$_svg/map_search.svg';
  static const String navAccount = '$_svg/account_circle_wght.svg';
  static const String navSettings = '$_svg/settings_wght.svg';

  // ── "ماذا تشمل خدماتنا" illustrations ────────────────────────────────────
  /// The exports are numbered in the mockup's left-to-right reading order;
  /// [ServiceModel.catalogue] is what puts them back in RTL order.
  static const String serviceVipTrips = '$_root/1.png';
  static const String serviceSupport247 = '$_root/2.png';
  static const String servicePilgrimTracking = '$_root/3.png';
  static const String serviceFlights = '$_root/4.png';
  static const String serviceTrains = '$_root/5.png';
  static const String serviceVisitsActivities = '$_root/6.png';
  static const String serviceSeaTransport = '$_root/7.png';
  static const String serviceTransportation = '$_root/8.png';
  static const String serviceHotels = '$_root/9.png';

  /// "vip" banner drawn across the bottom of [serviceVipTrips]. It ships as a
  /// separate export at the illustration's own width, so it lines up when both
  /// are stretched to the same box.
  static const String serviceVipBanner = '$_root/1-onsurface_vip.png';

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
