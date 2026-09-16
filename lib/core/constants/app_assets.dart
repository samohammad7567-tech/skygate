class AppAssets {
  AppAssets._();

  static const String _svgs = 'assets/images/svgs';
  static const String _pngs = 'assets/images/pngs';
  static const String logo = '$_svgs/logo.svg';
  static const String onboarding1 = '$_pngs/onboarding_1.png';
  static const String onboarding2 = '$_pngs/onboarding_2.png';
  static const String onboarding3 = '$_pngs/onboarding_3.png';
  static const String onboarding4 = '$_pngs/onboarding_4.png';
  static const String onboarding5 = '$_pngs/onboarding_5.png';
  static const List<String> onboarding = [
    onboarding1,
    onboarding2,
    onboarding3,
    onboarding4,
    onboarding5,
  ];
  static const String placeholder = '$_pngs/placeholder.png';
  static const String emptyTrips = '$_pngs/empty_trips.png';
  static const String emptyNotifications = '$_pngs/empty_notifications.png';
  static const String emptySearch = '$_pngs/empty_search.png';
  static const String emptyBookings = '$_pngs/empty_bookings.png';
  static const List<String> all = [logo, placeholder, ...onboarding];
}
