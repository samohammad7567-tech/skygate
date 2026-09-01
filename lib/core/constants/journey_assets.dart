/// Assets used by the "تفاصيل الرحلة" flow — package overview, itinerary,
/// segment details, hotels, activities and trip offers.
///
/// Load them with `AppImage`, which picks the SVG or raster decoder from the
/// file extension. Every glyph is a single-colour SVG, so call sites are free
/// to re-tint them from the theme.
class JourneyAssets {
  JourneyAssets._();

  static const String _root = 'assets/images/journy_details';
  static const String _png = '$_root/png';

  // ── Package overview ─────────────────────────────────────────────────────
  /// "بإشراف" card, and the booking-type row on an offer card.
  static const String supervisors = '$_root/Booking_type_icon.svg';

  /// Stay chips: مكة المكرمة and المدينة المنورة.
  static const String makkah = '$_root/makka.svg';
  static const String madinah = '$_root/mosque.svg';

  /// "تفاصيل الرحلة" section tiles. The activities tile shares the mosque
  /// glyph with the Madinah stay chip.
  static const String routes = '$_root/conversion_path.svg';
  static const String hotel = '$_root/domain.svg';
  static const String activities = madinah;

  // ── Transport ────────────────────────────────────────────────────────────
  /// Vehicle *type* glyphs — the first tile of "تفاصيل المركبة".
  static const String plane = '$_root/flight.svg';
  static const String bus = '$_root/local_taxi.svg';
  static const String train = '$_root/train.svg';
  static const String ship = '$_root/boat.svg';

  /// Vehicle *model* glyphs — the second tile of "تفاصيل المركبة".
  static const String planeModel = '$_root/flight_takeoff.svg';
  static const String busModel = '$_root/garage.svg';
  static const String trainModel = '$_root/bus_railway.svg';
  static const String shipModel = '$_root/directions_boat.svg';

  /// Vehicle *capacity* glyph — shared by every transport type.
  static const String seat = '$_root/seat_read.svg';

  // ── Hotels ───────────────────────────────────────────────────────────────
  static const String search = '$_root/search.svg';
  static const String sort = '$_root/sort.svg';
  static const String star = '$_root/star_shine.svg';
  static const String nights = '$_root/helal.svg';
  static const String location = '$_root/location_on.svg';
  static const String city = '$_root/location_city.svg';
  static const String bed = '$_root/bed.svg';
  static const String roomType = '$_root/bedroom_child.svg';
  static const String calendar = '$_root/calender.svg';
  static const String map = '$_root/map.svg';

  // ── Activities ───────────────────────────────────────────────────────────
  /// Pin-point marker inside the read-only activity fields.
  static const String pinpoint = '$_root/my_location.svg';
  static const String meetingPoint = '$_png/Gathering_icon.png';

  /// "من الساعة" / "إلى الساعة" on an activity card. The first shares its
  /// glyph with the prayers activity kind.
  static const String clockFrom = prayers;
  static const String clockTo = '$_root/history.svg';

  /// Activity kind glyphs, also used by the legend bar.
  static const String rituals = '$_png/rituals.png';
  static const String stay = '$_root/night_shelter.svg';
  static const String prayers = '$_root/prayer_times.svg';

  // ── Offer prices ─────────────────────────────────────────────────────────
  static const String adult = '$_root/man.svg';
  static const String child = '$_root/child_hat.svg';
  static const String infant = '$_root/child_care.svg';

  // ── Photography / logos ──────────────────────────────────────────────────
  /// Route map printed under "تفاصيل موقع الوجهة".
  static const String routeMap = '$_png/map.png';

  /// Hotel location map printed under "الموقع على الخريطة".
  static const String hotelMap = '$_png/Site_image.png';

  /// Fallback cover for a hotel card and the hotel details header.
  static const String hotelPhoto = '$_png/hotel_card_image.png';

  /// Carrier logos shown next to "شركة المركبة".
  static const String airlineLogo = '$_png/syrian_airlines_company.png';
  static const String railwayLogo = '$_png/syrian_train_comany.png';
  static const String transportLogo = '$_png/vaciles_comany.png';

  /// Every distinct file above, for bundle smoke tests. The aliases
  /// ([activities], [clockFrom]) are covered by what they point at.
  static const List<String> all = [
    supervisors,
    makkah,
    madinah,
    routes,
    hotel,
    plane,
    bus,
    train,
    ship,
    planeModel,
    busModel,
    trainModel,
    shipModel,
    seat,
    search,
    sort,
    star,
    nights,
    location,
    city,
    bed,
    roomType,
    calendar,
    map,
    pinpoint,
    meetingPoint,
    clockTo,
    rituals,
    stay,
    prayers,
    adult,
    child,
    infant,
    routeMap,
    hotelMap,
    hotelPhoto,
    airlineLogo,
    railwayLogo,
    transportLogo,
  ];
}
