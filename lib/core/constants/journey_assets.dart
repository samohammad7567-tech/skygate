class JourneyAssets {
  JourneyAssets._();

  static const String _svgs = 'assets/images/svgs';
  static const String _jpgs = 'assets/images/jpgs';
  static const String _pngs = 'assets/images/pngs';

  // ── Package overview ─────────────────────────────────────────────────────
  static const String supervisors = '$_svgs/booking_type_icon.svg';
  static const String makkah = '$_svgs/makka.svg';
  static const String madinah = '$_svgs/mosque.svg';
  static const String routes = '$_svgs/conversion_path.svg';
  static const String hotel = '$_svgs/domain.svg';
  static const String activities = madinah;

  // ── Transport ────────────────────────────────────────────────────────────
  static const String plane = '$_svgs/flight.svg';
  static const String bus = '$_svgs/local_taxi.svg';
  static const String train = '$_svgs/train.svg';
  static const String ship = '$_svgs/boat.svg';
  static const String planeModel = '$_svgs/flight_takeoff.svg';
  static const String busModel = '$_svgs/garage.svg';
  static const String trainModel = '$_svgs/bus_railway.svg';
  static const String shipModel = '$_svgs/directions_boat.svg';
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
  static const String pinpoint = '$_svgs/my_location.svg';
  static const String meetingPoint = '$_pngs/gathering_icon.png';
  static const String clockFrom = prayers;
  static const String clockTo = '$_svgs/history.svg';
  static const String rituals = '$_pngs/rituals.png';
  static const String stay = '$_svgs/night_shelter.svg';
  static const String prayers = '$_svgs/prayer_times.svg';

  // ── Offer prices ─────────────────────────────────────────────────────────
  static const String adult = '$_svgs/man.svg';
  static const String child = '$_svgs/child_hat.svg';
  static const String infant = '$_svgs/child_care.svg';

  // ── Photography / logos ──────────────────────────────────────────────────
  static const String routeMap = '$_pngs/map.png';
  static const String hotelMap = '$_pngs/site_image.png';
  static const String hotelPhoto = '$_pngs/hotel_card_image.png';
  static const String hotelPhotoRoom = '$_jpgs/hotel_room.jpg';
  static const String hotelPhotoLobby = '$_jpgs/hotel_lobby.jpg';
  static const String hotelPhotoExterior = '$_jpgs/hotel_exterior.jpg';
  static const List<String> hotelPhotoFallbacks = [
    hotelPhoto,
    hotelPhotoRoom,
    hotelPhotoLobby,
    hotelPhotoExterior,
  ];
  static const String airlineLogo = '$_pngs/syrian_airlines_company.png';
  static const String railwayLogo = '$_pngs/syrian_train_comany.png';
  static const String transportLogo = '$_pngs/vaciles_comany.png';
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
