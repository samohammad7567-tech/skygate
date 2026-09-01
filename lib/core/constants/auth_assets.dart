/// Assets used by the login / signup flow, exported to `assets/images/auth/`.
///
/// Load them with `AppImage`, which picks the SVG or raster decoder from the
/// file extension.
class AuthAssets {
  AuthAssets._();

  static const String _root = 'assets/images/auth';
  static const String _svg = '$_root/svgs';
  static const String _png = '$_root/png';

  // ── Backdrop & brand ─────────────────────────────────────────────────────
  /// Makkah photo behind every auth screen.
  static const String background = '$_root/back_ground.png';

  /// Sky Gate wordmark shown in the floating header card.
  static const String logo = '$_svg/logo.svg';

  /// Success illustration on "تم إنشاء الحساب".
  static const String successCheck =
      '$_png/center_image_correct_icon_with_stars.png';

  // ── Chrome ───────────────────────────────────────────────────────────────
  static const String arrowBack = '$_svg/arrow_back.svg';
  static const String correctIcon = '$_svg/correct_icon.svg';
  static const String upload = '$_svg/upload.svg';
  static const String addAccount = '$_svg/add_account.svg';

  /// Passport scanner viewfinder brackets. Placement is physical, not
  /// directional — the bracket shapes do not mirror under RTL.
  static const String cornerTopLeft = '$_svg/top_left.svg';
  static const String cornerTopRight = '$_svg/top_right.svg';
  static const String cornerBottomLeft = '$_svg/buttom_left.svg';
  static const String cornerBottomRight = '$_svg/buttom_right.svg';

  /// Frame drawn on the "use the camera" scan trigger.
  static const String imageScanner = '$_svg/image_scanner.svg';

  // ── Form field icons ─────────────────────────────────────────────────────
  static const String profile = '$_svg/profile.svg';
  static const String accountCircle = '$_svg/account_circle.svg';
  static const String phone = '$_svg/phone_enabled.svg';
  static const String mail = '$_svg/mail.svg';
  static const String visibility = '$_svg/visibility.svg';
  static const String calendar = '$_svg/calendar.svg';
  static const String man = '$_svg/man.svg';
  static const String globe = '$_svg/globel.svg';
  static const String passport = '$_svg/passport.svg';
  static const String idCard = '$_svg/id_card.svg';
  static const String assignmentGlobe = '$_svg/assignment_globe.svg';

  // ── "ملفات المعتمر" document icons ───────────────────────────────────────
  static const String familyRestroom = '$_svg/family_restroom.svg';
  static const String vaccines = '$_svg/vaccines.svg';
  static const String familyGroup = '$_svg/family_group.svg';
  static const String localPolice = '$_svg/local_police.svg';
  static const String menuBook = '$_svg/menu_book.svg';
  static const String personBook = '$_svg/person_book.svg';

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
