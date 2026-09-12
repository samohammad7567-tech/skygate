/// Glyphs for "تفاصيل البطاقات" and the travel documents that hang off a
/// segment — visas and tickets.
///
/// A few of the design's glyphs have no export yet (download, link, serial
/// number, thumbs-up); those call sites draw the closest Material icon and
/// are listed in `need_to_download.md` at the repo root.
class CardAssets {
  CardAssets._();

  static const String _svgs = 'assets/images/svgs';
  static const String _pngs = 'assets/images/pngs';

  // ── Portraits ────────────────────────────────────────────────────────────
  static const String avatar = '$_pngs/avatar.png';

  // ── Tab glyphs ───────────────────────────────────────────────────────────
  static const String pilgrimCards = '$_svgs/ic_person.svg';
  static const String luggageCards = '$_svgs/trip.svg';
  static const String segmentDetails = '$_svgs/description.svg';
  static const String visas = '$_svgs/id_card.svg';
  static const String tickets = '$_svgs/confirmation_number.svg';

  // ── Document fields ──────────────────────────────────────────────────────
  static const String passport = '$_svgs/passport.svg';
  static const String tripNumber = '$_svgs/id_card.svg';
  static const String calendar = '$_svgs/calendar_today.svg';
  static const String hotel = '$_svgs/domain.svg';
  static const String phone = '$_svgs/phone_enabled.svg';
  static const String pilgrimName = '$_svgs/ic_person.svg';

  // ── Card faces ───────────────────────────────────────────────────────────
  static const String qr = '$_svgs/qr_code.svg';
  static const String emergency = '$_svgs/support_agent.svg';
  static const String brandMark = '$_svgs/logo_skygate_small.svg';

  /// Only the paths this registry is the first to claim; the rest are glyphs
  /// other flows already declare, and the asset test allows that sharing.
  static const List<String> all = [avatar, qr];
}
