/// Assets used by the login / signup flow, exported to `assets/images/auth/`.
///
/// Load them with `AppImage`, which picks the SVG or raster decoder from the
/// file extension.
class AuthAssets {
  AuthAssets._();

  static const String _svgs = 'assets/images/svgs';
  static const String _pngs = 'assets/images/pngs';

  // ── Backdrop & brand ─────────────────────────────────────────────────────
  /// Makkah photo behind every auth screen.
  static const String background = '$_pngs/auth_background.png';

  /// Sky Gate wordmark shown in the floating header card.
  static const String logo = '$_svgs/logo.svg';

  /// Success illustration on "تم إنشاء الحساب".
  static const String successCheck =
      '$_pngs/center_image_correct_icon_with_stars.png';

  // ── Chrome ───────────────────────────────────────────────────────────────
  static const String arrowBack = '$_svgs/arrow_back.svg';
  static const String correctIcon = '$_svgs/correct_icon.svg';
  static const String upload = '$_svgs/upload.svg';
  static const String addAccount = '$_svgs/add_account.svg';

  /// Passport scanner viewfinder brackets. Placement is physical, not
  /// directional — the bracket shapes do not mirror under RTL.
  static const String cornerTopLeft = '$_svgs/top_left.svg';
  static const String cornerTopRight = '$_svgs/top_right.svg';
  static const String cornerBottomLeft = '$_svgs/buttom_left.svg';
  static const String cornerBottomRight = '$_svgs/buttom_right.svg';

  /// Frame drawn on the "use the camera" scan trigger.
  static const String imageScanner = '$_svgs/image_scanner.svg';

  // ── Form field icons ─────────────────────────────────────────────────────
  static const String profile = '$_svgs/profile.svg';
  static const String accountCircle = '$_svgs/account_circle.svg';
  static const String phone = '$_svgs/phone_enabled.svg';
  static const String mail = '$_svgs/mail.svg';
  static const String visibility = '$_svgs/visibility.svg';
  static const String calendar = '$_svgs/calendar.svg';
  static const String man = '$_svgs/man.svg';
  static const String globe = '$_svgs/globel.svg';
  static const String passport = '$_svgs/passport.svg';
  static const String idCard = '$_svgs/id_card.svg';
  static const String assignmentGlobe = '$_svgs/assignment_globe.svg';

  // ── "ملفات المعتمر" document icons ───────────────────────────────────────
  static const String familyRestroom = '$_svgs/family_restroom.svg';
  static const String vaccines = '$_svgs/vaccines.svg';
  static const String familyGroup = '$_svgs/family_group.svg';
  static const String localPolice = '$_svgs/local_police.svg';
  static const String menuBook = '$_svgs/menu_book.svg';
  static const String personBook = '$_svgs/person_book.svg';

  /// Every asset above, for bundle smoke tests.
  static const List<String> all = [
    background,
    logo,
    successCheck,
    arrowBack,
    correctIcon,
    upload,
    addAccount,
    cornerTopLeft,
    cornerTopRight,
    cornerBottomLeft,
    cornerBottomRight,
    imageScanner,
    profile,
    accountCircle,
    phone,
    mail,
    visibility,
    calendar,
    man,
    globe,
    passport,
    idCard,
    assignmentGlobe,
    familyRestroom,
    vaccines,
    familyGroup,
    localPolice,
    menuBook,
    personBook,
  ];
}
