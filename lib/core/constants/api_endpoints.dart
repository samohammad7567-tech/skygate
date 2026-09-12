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

  // ── Auth ─────────────────────────────────────────────────────────────────
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

  // ── Pilgrims ─────────────────────────────────────────────────────────────
  static const String scanPassport = 'app/passport-ocr/scan';
  static const String pilgrims = 'app/pilgrims';
  static String pilgrim(int id) => 'app/pilgrims/$id';
  static const String pilgrimDocuments = 'app/pilgrim-documents';
  static const String uploadDocument = pilgrimDocuments;
  static const String documentTypes = 'app/document-types';

  // ── Trips ────────────────────────────────────────────────────────────────
  static String trip(int id) => 'app/trips/$id';
  static const String tripsSearch = 'app/trips/search';

  /// "رحلاتي" — the pilgrim's own trips, one tab per `filter[status]`
  /// (`current`, `upcoming`, `past`). The filter is required by the API.
  static const String myTrips = 'app/my-trips';
  static const String activities = 'app/activities';

  /// The two field actions on an activity card: "تأكيد الحضور" posts
  /// `{status: present}`, and the rating sheet posts `{rating, comment}`.
  static String activityAttendance(int id) => '$activities/$id/attendance';
  static String activityFeedback(int id) => '$activities/$id/feedback';

  // ── Trip cards & travel documents ────────────────────────────────────────
  // What "تفاصيل البطاقات" and the تأشيرات / تذاكر tabs read. Each row names
  // the pilgrim it belongs to through `booking_pilgrim_id`, so the screens
  // fetch the whole trip's set once and group it per pilgrim.
  static const String luggageTags = 'app/luggage-tags';
  static const String pilgrimTickets = 'app/pilgrim-tickets';
  static String pilgrimTicket(int id) => '$pilgrimTickets/$id';
  static const String visas = 'app/visas';
  static String pilgrimIdCard(int id) => 'app/pilgrims/$id/id-card';
  static String pilgrimIdCardPdf(int id) => 'app/pilgrims/$id/id-card-pdf';

  // ── Booking ──────────────────────────────────────────────────────────────
  static const String bookings = 'app/bookings';
  static String booking(int id) => 'app/bookings/$id';

  // ── Payments ─────────────────────────────────────────────────────────────
  static const String paymentMethods = 'app/payment-methods';
  static const String financialTransactions = 'app/financial-transactions';

  // ── Home ─────────────────────────────────────────────────────────────────
  static const String home = 'app/home';
  static String readNotification(int id) => 'app/notifications/$id/read';

  // ── Private trip requests ────────────────────────────────────────────────
  static const String privateTripRequests = 'app/private-trip-requests';
  static String privateTripRequest(int id) => '$privateTripRequests/$id';
  static String cancelPrivateTripRequest(int id) =>
      '${privateTripRequest(id)}/cancel';

  // ── Booking amendment requests ───────────────────────────────────────────
  // "طلبات تعديل الحجوزات" — the pilgrim's standing requests to change a
  // booking they already hold.
  static const String bookingChangeRequests = 'app/booking-change-requests';
  static String bookingChangeRequest(int id) => '$bookingChangeRequests/$id';

  // ── Map / geo-tracking ───────────────────────────────────────────────────
  static const String locationPings = 'app/location-pings';
  static const String tripGeofences = 'app/trip-geofences';
  static const String geofenceBreaches = '$tripGeofences/breaches';
  static const String sosEvents = 'app/sos-events';
  static String sosEvent(int id) => '$sosEvents/$id';

  // ── Lost items ───────────────────────────────────────────────────────────
  static const String lostItems = 'app/lost-items';

  // ── Live support chat ────────────────────────────────────────────────────
  static const String tripChat = 'app/trip-chat';
  static const String tripChatMessages = '$tripChat/messages';
  static const String tripChatRead = '$tripChat/read';

  // ── Published, not wired yet ─────────────────────────────────────────────
  // These paths exist in the OpenAPI document but have no caller in the app,
  // so they are deliberately left out until a screen needs one:
  //
  //   GET  app/trips                            — paginated trip list; every
  //                                               screen reads its trips from
  //                                               `app/home` or `trips/search`
  //   GET  app/notifications                    — paging past the first batch
  //                                               `app/home` already carries
  //   GET  app/document-types/required          — the subset a pilgrim still
  //                                               owes; the full catalogue is
  //                                               filtered client-side instead
  //   POST app/financial-transactions/{id}/receipt
  //                                             — late receipt attach; the app
  //                                               always sends the receipt with
  //                                               the transaction itself
  //   POST app/private-trip-requests/{id}/accept
  //   POST app/private-trip-requests/{id}/reject
  //                                             — the two answers to a quote.
  //                                               The design only lets a pilgrim
  //                                               withdraw a request, so wiring
  //                                               them would invent a flow the
  //                                               mockups do not have.
  //   GET  app/room-assignments                 — room allocation
  //   POST app/booking-change-requests          — raising an amendment. The
  //                                               mockups only list and open
  //                                               existing requests, so the
  //                                               submit flow has no design to
  //                                               build against yet.
}
