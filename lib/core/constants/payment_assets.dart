class PaymentAssets {
  PaymentAssets._();

  static const String _svgs = 'assets/images/svgs';
  static const String _pngs = 'assets/images/pngs';
  static const String calendar = '$_svgs/today.svg';
  static const String upcoming = '$_svgs/flight_takeoff.svg';
  static const String duePayment = '$_svgs/credit_card_clock.svg';
  static const String done = '$_svgs/check_circle.svg';
  static const String plane = '$_svgs/travel.svg';
  static const String hotel = '$_svgs/domain.svg';
  static const String train = '$_svgs/train.svg';
  static const String ship = '$_svgs/sailing.svg';
  static const String bus = '$_svgs/local_taxi.svg';
  static const String group = '$_svgs/group.svg';
  static const List<String> inclusions = [
    plane,
    hotel,
    train,
    ship,
    bus,
    madinah,
  ];
  static const String bookingTicket = '$_svgs/confirmation_number.svg';
  static const String dollar = '$_svgs/attach_money.svg';
  static const String syrianPound = '$_svgs/payments.svg';
  static const String info = '$_svgs/info.svg';
  static const String upload = '$_svgs/upload.svg';
  static const String shamCash = '$_pngs/sham_cash.png';
  static const String alHaram = '$_pngs/haram.png';
  static const String genericMethod = syrianPound;
  static const String routes = '$_svgs/conversion_path.svg';
  static const String offers = '$_svgs/redeem.svg';
  static const String makkah = '$_svgs/makkah.svg';
  static const String madinah = '$_svgs/mosque.svg';
  static const String arrowBack = '$_svgs/arrow_back.svg';
  static const String starBurst = '$_svgs/star_burst.svg';
  static const List<String> all = [
    calendar,
    upcoming,
    duePayment,
    done,
    ...inclusions,
    bookingTicket,
    dollar,
    syrianPound,
    info,
    upload,
    shamCash,
    alHaram,
    routes,
    offers,
    group,
    makkah,
    arrowBack,
    starBurst,
  ];
}
