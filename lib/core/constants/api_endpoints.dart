/// Every backend path used by the app. No inline URL strings in features.
///
/// Paths mirror the OpenAPI document: the host plus `/api/v1/` is the base, and
/// every path below is written relative to it — `auth/...` for the two public
/// credential endpoints, `app/...` for everything the app calls afterwards.
class ApiEndpoints {
  ApiEndpoints._();

  /// Host the app talks to, without a trailing slash.
  ///
  /// The OpenAPI document ships no `servers` entry, so this falls back to a
  /// placeholder. Point a build at the real backend without touching code:
  ///
  /// ```bash
  /// flutter run --dart-define=API_HOST=https://staging.example.com
  /// ```
  static const String host = String.fromEnvironment(
    'API_HOST',
    defaultValue: 'https://dev.skygate.site',
  );

  /// Base URL for every call. Public endpoints simply go out without an
  /// `Authorization` header — the document has no separate guest host.
  static const String baseUrl = '$host/api/v1/';

  /// Prefix for relative media paths returned by the API.
  static const String mediaPath = '$host/storage/';

  // ── Auth ─────────────────────────────────────────────────────────────────
  /// `POST auth/login` — takes `mobile` and `password`.
  static const String login = 'auth/login';

  /// `POST auth/register` — takes the eleven profile and passport fields.
  static const String register = 'auth/register';

  /// Not in the OpenAPI document; kept for the interceptor's retry path and
  /// the logout button until the backend publishes them.
  static const String refreshToken = 'auth/refresh';
  static const String logout = 'auth/logout';

  /// Sends the reset link / OTP for "هل نسيت كلمة المرور ؟". Not in the
  /// OpenAPI document either.
  static const String forgotPassword = 'auth/forgot-password';

  /// The endpoints called without a session.
  ///
  /// A 401 from one of these means the credentials were rejected, not that a
  /// session ran out — so neither [AuthInterceptor] nor [ApiError] treats them
  /// the way it treats an authenticated call. Kept here so both read the same
  /// list.
  static const List<String> publicPaths = [
    login,
    register,
    forgotPassword,
    refreshToken,
  ];

  /// Whether [path] is one of [publicPaths]. Takes the full request path,
  /// which carries the `/api/v1/` prefix the constants above leave off.
  static bool isPublicPath(String path) => publicPaths.any(path.contains);

  // ── Pilgrims ─────────────────────────────────────────────────────────────
  /// `POST app/passport-ocr/scan` — multipart `passport_image`, max 5 MB. The
  /// API returns the parsed MRZ.
  static const String scanPassport = 'app/passport-ocr/scan';

  /// `POST app/pilgrims` — creates one pilgrim from a scanned or typed
  /// passport and answers with the id `app/bookings` seats its rooms with.
  static const String pilgrims = 'app/pilgrims';

  /// `POST app/pilgrim-documents` — multipart `pilgrim_id`,
  /// `document_type_id` and `file`.
  static const String uploadDocument = 'app/pilgrim-documents';

  // ── Trips ────────────────────────────────────────────────────────────────
  /// `GET app/trips/{id}` — one trip with its packages, hotels, itinerary and
  /// staff. Every journey-details screen and both booking wizards read from
  /// this single call.
  static String trip(int id) => 'app/trips/$id';

  /// `GET app/activities` — the day-by-day programme of the pilgrim's trip.
  static const String activities = 'app/activities';

  // ── Booking ──────────────────────────────────────────────────────────────
  /// `POST app/bookings` — `trip_id` plus `rooms[]`, each room naming its
  /// `package_id` and the pilgrims seated in it.
  static const String bookings = 'app/bookings';

  /// `GET app/bookings/{id}` — one booking. `BookingResource` carries only an
  /// id, a status, a total and `draft_expires_at`, so "المدفوعات" reads its
  /// total here and takes the rest from what the caller hands it.
  static String booking(int id) => 'app/bookings/$id';

  // ── Payments ─────────────────────────────────────────────────────────────
  /// `GET app/payment-methods` — the options of "طريقة التحويل", each with the
  /// bullet list of steps the payer follows.
  static const String paymentMethods = 'app/payment-methods';

  /// `POST app/financial-transactions` — multipart `booking_id`,
  /// `payment_method_id`, `amount`, and optionally `currency`,
  /// `reference_number` and a `receipt` image of at most 2 MB.
  static const String financialTransactions = 'app/financial-transactions';

  /// `POST app/financial-transactions/{id}/receipt` — attaches the receipt to
  /// a transaction that was created without one.
  static String transactionReceipt(int id) =>
      'app/financial-transactions/$id/receipt';

  // ── Home ─────────────────────────────────────────────────────────────────
  // The pre-booking browse funnel the home screen was built against is not in
  // the OpenAPI document. The pill row, the offer carousel and the services
  // grid are all served from local catalogues — `TravelCategoryModel`,
  // `OfferModel` and `ServiceModel` — so the only path the screen still calls
  // is the custom-trip form below, which the backend has yet to publish.

  /// Submits the "اطلب رحلتك الخاصة" form. Not in the OpenAPI document; the
  /// published `POST app/private-trip-requests` takes head counts, dates,
  /// hotels and room types the form never asks for.
  static const String customTripRequest = 'custom-trips';

  // ── Published, not wired yet ─────────────────────────────────────────────
  // These paths exist in the OpenAPI document but have no screen in the app
  // yet, so they are deliberately left out until one is built:
  //
  //   GET  app/trips                           — the home browse list
  //   POST app/private-trip-requests           — "اطلب رحلتك الخاصة"
  //   GET  app/bookings                        — "رحلاتي" tab
  //   POST app/booking-change-requests         — booking amendment
  //   GET  app/notifications                   — the bell
  //   POST app/notifications/{id}/read
  //   GET  app/room-assignments                — room allocation
  //   POST app/sos-events                      — field SOS button
  //   POST app/activities/{id}/attendance      — field attendance
  //   POST app/activities/{id}/feedback        — field feedback
  //   PUT  app/pilgrims/{id}                   — "حسابي" profile edit
  //   GET  app/trip-chat, app/visas, app/luggage-tags, app/lost-items,
  //        app/pilgrim-tickets, app/pilgrims/{id}/id-card, …
}
