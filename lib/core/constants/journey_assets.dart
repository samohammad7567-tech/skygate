/// Assets used by the "تفاصيل الرحلة" flow — package overview, itinerary,
/// segment details, hotels, activities and trip offers.
///
/// Load them with `AppImage`, which picks the SVG or raster decoder from the
/// file extension. Every glyph is a single-colour SVG, so call sites are free
/// to re-tint them from the theme.
class JourneyAssets {
  JourneyAssets._();

  static const String _svgs = 'assets/images/svgs';
  static const String _pngs = 'assets/images/pngs';

  // ── Package overview ─────────────────────────────────────────────────────
  /// "بإشراف" card, and the booking-type row on an offer card.
  static const String supervisors = '$_svgs/Booking_type_icon.svg';

  /// Stay chips: مكة المكرمة and المدينة المنورة.
  static const String makkah = '$_svgs/makka.svg';
  static const String madinah = '$_svgs/mosque.svg';

  /// "تفاصيل الرحلة" section tiles. The activities tile shares the mosque
  /// glyph with the Madinah stay chip.
  static const String routes = '$_svgs/conversion_path.svg';
  static const String hotel = '$_svgs/domain.svg';
  static const String activities = madinah;

  // ── Transport ────────────────────────────────────────────────────────────
  /// Vehicle *type* glyphs — the first tile of "تفاصيل المركبة".
  static const String plane = '$_svgs/flight.svg';
  static const String bus = '$_svgs/local_taxi.svg';
  static const String train = '$_svgs/train.svg';
  static const String ship = '$_svgs/boat.svg';

  /// Vehicle *model* glyphs — the second tile of "تفاصيل المركبة".
  static const String planeModel = '$_svgs/flight_takeoff.svg';
  static const String busModel = '$_svgs/garage.svg';
  static const String trainModel = '$_svgs/bus_railway.svg';
  static const String shipModel = '$_svgs/directions_boat.svg';

  /// Vehicle *capacity* glyph — shared by every transport type.
  static const String seat = '$_svgs/seat_read.svg';

  // ── Hotels ───────────────────────────────────────────────────────────────
  static const String search = '$_svgs/search.svg';
  static const String sort = '$_svgs/sort.svg';
  static const String star = '$_svgs/star_shine.svg';
  static const String nights = '$_svgs/helal.svg';
  static const String location = '$_svgs/location_on.svg';
  static const String city = '$_svgs/location_city.svg';
  static const String bed = '$_svgs/bed.svg';
  static const String roomType = '$_svgs/bedroom_child.svg';
  static const String calendar = '$_svgs/calender.svg';
  static const String map = '$_svgs/map.svg';

  // ── Activities ───────────────────────────────────────────────────────────
  /// Pin-point marker inside the read-only activity fields.
  static const String pinpoint = '$_svgs/my_location.svg';
  static const String meetingPoint = '$_pngs/Gathering_icon.png';

  /// "من الساعة" / "إلى الساعة" on an activity card. The first shares its
  /// glyph with the prayers activity kind.
  static const String clockFrom = prayers;
  static const String clockTo = '$_svgs/history.svg';

  /// Activity kind glyphs, also used by the legend bar.
  static const String rituals = '$_pngs/rituals.png';
  static const String stay = '$_svgs/night_shelter.svg';
  static const String prayers = '$_svgs/prayer_times.svg';

  // ── Offer prices ─────────────────────────────────────────────────────────
  static const String adult = '$_svgs/man.svg';
  static const String child = '$_svgs/child_hat.svg';
  static const String infant = '$_svgs/child_care.svg';

  // ── Photography / logos ──────────────────────────────────────────────────
  /// Route map printed under "تفاصيل موقع الوجهة".
  static const String routeMap = '$_pngs/map.png';

  /// Hotel location map printed under "الموقع على الخريطة".
  static const String hotelMap = '$_pngs/Site_image.png';

  /// Fallback cover for a hotel card and the hotel details header.
  static const String hotelPhoto = '$_pngs/hotel_card_image.png';

  /// Carrier logos shown next to "شركة المركبة".
  static const String airlineLogo = '$_pngs/syrian_airlines_company.png';
  static const String railwayLogo = '$_pngs/syrian_train_comany.png';
  static const String transportLogo = '$_pngs/vaciles_comany.png';

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
