class ApiEndpoints {
  ApiEndpoints._();
  static const String host = String.fromEnvironment(
    'API_HOST',
    defaultValue: 'https://dev.skygate.site',
  );
  static const String baseUrl = '$host/api/v1/';
  static const String mediaPath = String.fromEnvironment(
    'MEDIA_PATH',
    defaultValue: '$host/storage/',
  );
  static String? mediaUrl(String? path) {
    final value = path?.trim();
    if (value == null || value.isEmpty) return null;
    if (value.startsWith('http://') || value.startsWith('https://')) {
      return value;
    }
    return '$mediaPath${value.startsWith('/') ? value.substring(1) : value}';
  }

  static const String login = 'auth/login';
  static const String register = 'auth/register';
  static const String refreshToken = 'auth/refresh';
  static const String logout = 'auth/logout';
  static const String forgotPassword = 'auth/forgot-password';
  static const String changePassword = 'auth/change-password';
  static const List<String> publicPaths = [
    login,
    register,
    forgotPassword,
    refreshToken,
  ];
  static bool isPublicPath(String path) => publicPaths.any(path.contains);
  static const String scanPassport = 'app/passport-ocr/scan';
  static const String pilgrims = 'app/pilgrims';
  static String pilgrim(int id) => 'app/pilgrims/$id';
  static const String pilgrimDocuments = 'app/pilgrim-documents';
  static const String uploadDocument = pilgrimDocuments;
  static const String documentTypes = 'app/document-types';
  static String trip(int id) => 'app/trips/$id';
  static const String tripsSearch = 'app/trips/search';
  static const String myTrips = 'app/my-trips';
  static const String activities = 'app/activities';
  static String activityAttendance(int id) => '$activities/$id/attendance';
  static String activityFeedback(int id) => '$activities/$id/feedback';
  static const String luggageTags = 'app/luggage-tags';
  static const String pilgrimTickets = 'app/pilgrim-tickets';
  static String pilgrimTicket(int id) => '$pilgrimTickets/$id';
  static const String visas = 'app/visas';
  static String pilgrimIdCard(int id) => 'app/pilgrims/$id/id-card';
  static String pilgrimIdCardPdf(int id) => 'app/pilgrims/$id/id-card-pdf';
  static const String bookings = 'app/bookings';
  static String booking(int id) => 'app/bookings/$id';
  static const String paymentMethods = 'app/payment-methods';
  static const String financialTransactions = 'app/financial-transactions';
  static const String home = 'app/home';
  static String readNotification(int id) => 'app/notifications/$id/read';
  static const String privateTripRequests = 'app/private-trip-requests';
  static String privateTripRequest(int id) => '$privateTripRequests/$id';
  static String cancelPrivateTripRequest(int id) =>
      '${privateTripRequest(id)}/cancel';
  static const String bookingChangeRequests = 'app/booking-change-requests';
  static String bookingChangeRequest(int id) => '$bookingChangeRequests/$id';
  static const String locationPings = 'app/location-pings';

  /// Read-only view of the active safe areas on the pilgrim's own trip.
  /// The `app/trip-geofences` routes are the leader's and answer 403 here.
  static const String tripSafeArea = 'app/trip-safe-area';
  static const String sosEvents = 'app/sos-events';
  static String sosEvent(int id) => '$sosEvents/$id';
  static const String lostItems = 'app/lost-items';
  static const String tripChat = 'app/trip-chat';
  static const String tripChatMessages = '$tripChat/messages';
  static const String tripChatRead = '$tripChat/read';
}
