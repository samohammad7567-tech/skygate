class VipTripAssets {
  VipTripAssets._();

  static const String _svgs = 'assets/images/svgs';
  static const String _pngs = 'assets/images/pngs';

  // ── Page chrome ──────────────────────────────────────────────────────────
  static const String menu = '$_svgs/menu.svg';
  static const String arrowBack = '$_svgs/profile_arrow_back.svg';

  // ── Step 1 — "حدد عدد الأشخاص" ───────────────────────────────────────────
  static const String adult = '$_svgs/vip_man.svg';
  static const String child = '$_svgs/vip_child_hat.svg';
  static const String infant = '$_svgs/vip_child_care.svg';

  // ── Step 2 — "حدد مدة الرحلة" ────────────────────────────────────────────
  static const String calendar = '$_svgs/calendar.svg';
  static const String crescent = '$_svgs/helal.svg';

  // ── Step 3 — "اختر عدد الغرف و أنواعها" ──────────────────────────────────
  static const String bed = '$_svgs/bed.svg';
  static const String roomBed = '$_svgs/vip_bedroom_child.svg';
  static const String emptyRooms = '$_svgs/freepik.svg';
  static const String emptyRoomsLamp = '$_svgs/freepik_lamp_inject.svg';
  static const String emptyRoomsPlant = '$_svgs/freepik_plant_inject.svg';
  static const String info = '$_svgs/vip_info.svg';

  // ── Steps 4 & 5 — the hotel cards ────────────────────────────────────────
  static const String hotelPhoto = '$_pngs/image.png';
  static const String location = '$_svgs/location.svg';
  static const String star = '$_svgs/star_5.svg';
  static const String starLarge = '$_svgs/star.svg';

  // ── Step 6 — "متطلبات أخرى" ──────────────────────────────────────────────
  static const String pencil = '$_svgs/pencil.svg';

  // ── Confirmation & cancellation ──────────────────────────────────────────
  static const String check = '$_svgs/ok.svg';
  static const String delete = '$_svgs/delete.svg';
  static const List<String> all = [
    menu,
    arrowBack,
    adult,
    child,
    infant,
    calendar,
    crescent,
    bed,
    roomBed,
    emptyRooms,
    emptyRoomsLamp,
    emptyRoomsPlant,
    info,
    hotelPhoto,
    location,
    star,
    starLarge,
    pencil,
    check,
    delete,
  ];
}
