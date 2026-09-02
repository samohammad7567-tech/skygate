/// Assets used by "رحلاتي" and the payments flow, exported to
/// `assets/images/Payment/`.
///
/// Load them with `AppImage`, which picks the SVG or raster decoder from the
/// file extension. Every glyph is a single-colour SVG, so call sites re-tint
/// them from the theme.
class PaymentAssets {
  PaymentAssets._();

  static const String _svgs = 'assets/images/svgs';
  static const String _pngs = 'assets/images/pngs';

  // ── "رحلاتي" tabs ────────────────────────────────────────────────────────
  /// "الحالية", and the calendar glyph on a trip card's date chips.
  static const String calendar = '$_svgs/today.svg';

  /// "تحتاج دفعة", and the glyph on the payments section tile.
  static const String duePayment = '$_svgs/credit_card_clock.svg';

  /// "المنتهية", and the tick on a settled instalment.
  static const String done = '$_svgs/check_circle.svg';

  // ── Trip card inclusions ─────────────────────────────────────────────────
  /// The row of glyphs above a trip card's title, in the order it prints them.
  static const String plane = '$_svgs/travel.svg';
  static const String hotel = '$_svgs/domain.svg';
  static const String train = '$_svgs/train.svg';
  static const String ship = '$_svgs/sailing.svg';
  static const String bus = '$_svgs/local_taxi.svg';
  static const String group = '$_svgs/group.svg';

  /// The six inclusions a trip card lists, in design order (RTL: plane first).
  static const List<String> inclusions = [
    plane,
    hotel,
    train,
    ship,
    bus,
    group,
  ];

  // ── "حجوزاتي و المدفوعات" ────────────────────────────────────────────────
  /// Ticket glyph on the "تفاصيل الحجز" tile of the trip overview.
  static const String bookingTicket = '$_svgs/confirmation_number.svg';

  // ── Payment sheet ────────────────────────────────────────────────────────
  /// "دولار USD" — the currency options of "نوع المبلغ المحول".
  static const String dollar = '$_svgs/attach_money.svg';

  /// "ليرة سورية SYP".
  static const String syrianPound = '$_svgs/payments.svg';

  /// Leading glyph of the sheet's blue instruction note.
  static const String info = '$_svgs/info.svg';

  /// Arrow inside the dashed "صورة إيصال الحوالة" drop zone.
  static const String upload = '$_svgs/upload.svg';

  /// Logos shown on a payment method card until `GET app/payment-methods`
  /// returns an `image` for it. Resolved by name in [PaymentMethodModel].
  static const String shamCash = '$_pngs/sham_cash.png';
  static const String alHaram = '$_pngs/haram.png';

  // ── Trip overview section tiles ──────────────────────────────────────────
  static const String routes = '$_svgs/conversion_path.svg';
  static const String offers = '$_svgs/redeem.svg';
  static const String makkah = '$_svgs/makkah.svg';
  static const String madinah = '$_svgs/mosque.svg';

  // ── Chrome ───────────────────────────────────────────────────────────────
  static const String arrowBack = '$_svgs/arrow_back.svg';

  /// Sparkle scattered behind the "تأكيد الدفع" tick.
  static const String starBurst = '$_svgs/star_burst.svg';

  /// Every asset above, for bundle smoke tests.
  static const List<String> all = [
    calendar,
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
    makkah,
    madinah,
    arrowBack,
    starBurst,
  ];
}
