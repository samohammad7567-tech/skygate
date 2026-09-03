import 'package:get/get.dart';
import 'package:sky_gate/app/modules/my-bookings-requests/views/confirm_booking_condiiton_view.dart';

import '../modules/account-waiting/bindings/account_waiting_binding.dart';
import '../modules/account-waiting/views/account_waiting_view.dart';
import '../modules/account/bindings/account_binding.dart';
import '../modules/account/views/account_view.dart';
import '../modules/airport-map/bindings/airport_map_binding.dart';
import '../modules/airport-map/views/airport_map_view.dart';
import '../modules/airport-taxi/bindings/airport_taxi_binding.dart';
import '../modules/airport-taxi/views/airport_taxi_view.dart';
import '../modules/airport-taxi/views/map_view.dart';
import '../modules/change-operation/bindings/change_operation_binding.dart';
import '../modules/change-operation/views/change_operation_view.dart';
import '../modules/coming-soon/bindings/coming_soon_binding.dart';
import '../modules/coming-soon/views/coming_soon_view.dart';
import '../modules/customer-care-support/bindings/customer_care_support_binding.dart';
import '../modules/customer-care-support/views/customer_care_support_view.dart';
import '../modules/edit_profile/bindings/edit_profile_binding.dart';
import '../modules/edit_profile/views/edit_profile_view.dart';
import '../modules/faqs/bindings/faqs_binding.dart';
import '../modules/faqs/views/faqs_view.dart';
import '../modules/fingerprint_login/bindings/fingerprint_login_binding.dart';
import '../modules/fingerprint_login/views/fingerprint_login_view.dart';
import '../modules/fingerprint_setup/bindings/fingerprint_setup_binding.dart';
import '../modules/fingerprint_setup/views/fingerprint_setup_view.dart';
import '../modules/forget_password/bindings/forget_password_binding.dart';
import '../modules/forget_password/views/forget_password_view.dart';
import '../modules/forget_password/views/otp_code_view.dart';
import '../modules/home-tab/bindings/home_tab_binding.dart';
import '../modules/home-tab/views/home_tab_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/last-promotions/bindings/last_promotions_binding.dart';
import '../modules/last-promotions/views/last_promotions_view.dart';
import '../modules/logout/bindings/logout_binding.dart';
import '../modules/logout/views/logout_view.dart';
import '../modules/my-bookings-requests/bindings/my_bookings_requests_binding.dart';
import '../modules/my-bookings-requests/views/add_passports_view.dart';
import '../modules/my-bookings-requests/views/choose_payment_method_view.dart';
import '../modules/my-bookings-requests/views/confirm_booking_request_view.dart';
import '../modules/my-bookings-requests/views/my_bookings_requests_view.dart';
import '../modules/my-bookings-requests/views/passport_scanner_view.dart';
import '../modules/my-bookings-requests/views/payment_method_details_view.dart';
import '../modules/my-trips-agenda/bindings/my_trips_agenda_binding.dart';
import '../modules/my-trips-agenda/views/choose_departure_trip_view.dart';
import '../modules/my-trips-agenda/views/choose_return_trip_view.dart';
import '../modules/my-trips-agenda/views/confirm_regular_trip_view.dart';
import '../modules/my-trips-agenda/views/confirm_special_trip_view.dart';
import '../modules/my-trips-agenda/views/my_trips_agenda_view.dart';
import '../modules/my-trips-agenda/views/non_regular_trip_view.dart';
import '../modules/my-trips-agenda/views/review_trip_view.dart';
import '../modules/my-trips/bindings/my_trips_binding.dart';
import '../modules/my-trips/views/add_trip_notes_view.dart';
import '../modules/my-trips/views/my_trips_edit_view.dart';
import '../modules/my-trips/views/my_trips_view.dart';
import '../modules/my-trips/views/ticket_conditions_view.dart';
import '../modules/my-trips/views/ticket_reminder_view.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/otp_step/bindings/otp_step_binding.dart';
import '../modules/otp_step/views/otp_step_view.dart';
import '../modules/promotion-details/bindings/promotion_details_binding.dart';
import '../modules/promotion-details/views/promotion_details_view.dart';
import '../modules/refund-operation/bindings/refund_operation_binding.dart';
import '../modules/refund-operation/views/refund_operation_view.dart';
import '../modules/reset_password/bindings/reset_password_binding.dart';
import '../modules/reset_password/views/reset_password_view.dart';
import '../modules/sales-support/bindings/sales_support_binding.dart';
import '../modules/sales-support/views/sales_support_view.dart';
import '../modules/signin/bindings/signin_binding.dart';
import '../modules/signin/views/signin_view.dart';
import '../modules/signup/bindings/signup_binding.dart';
import '../modules/signup/views/passport_scanner.dart';
import '../modules/signup/views/signup_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/start_page/bindings/start_page_binding.dart';
import '../modules/start_page/views/start_page_view.dart';
import '../modules/support/bindings/support_binding.dart';
import '../modules/support/views/support_view.dart';
import '../modules/travel-allowed-countries/bindings/travel_allowed_countries_binding.dart';
import '../modules/travel-allowed-countries/views/travel_allowed_countries_view.dart';
import '../modules/travel-info/bindings/travel_info_binding.dart';
import '../modules/travel-info/views/travel_info_view.dart';
import '../modules/update_password/bindings/update_password_binding.dart';
import '../modules/update_password/views/update_password_view.dart';
import '../modules/welcome_login/bindings/welcome_login_binding.dart';
import '../modules/welcome_login/views/welcome_login_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static String INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SIGNIN,
      page: () => SigninView(),
      binding: SigninBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.PASSPORT_SCANNER,
      page: () => PassportScanner(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.FORGET_PASSWORD,
      page: () => ForgetPasswordView(),
      binding: ForgetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.RESET_PASSWORD,
      page: () => const ResetPasswordView(),
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.UPDATE_PASSWORD,
      page: () => const UpdatePasswordView(),
      binding: UpdatePasswordBinding(),
    ),
    GetPage(
      name: _Paths.WELCOME_LOGIN,
      page: () => WelcomeLoginView(),
      binding: WelcomeLoginBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: _Paths.FAQS,
      page: () => FaqsView(),
      binding: FaqsBinding(),
    ),
    GetPage(
      name: _Paths.LOGOUT,
      page: () => const LogoutView(),
      binding: LogoutBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS,
      page: () => NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: _Paths.HOME_TAB,
      page: () => HomeTabView(),
      binding: HomeTabBinding(),
    ),
    GetPage(
      name: _Paths.ACCOUNT,
      page: () => AccountView(),
      binding: AccountBinding(),
    ),
    GetPage(
      name: _Paths.START_PAGE,
      page: () => StartPageView(),
      binding: StartPageBinding(),
    ),
    GetPage(
      name: _Paths.MY_TRIPS,
      page: () => MyTripsView(),
      binding: MyTripsBinding(),
    ),
    GetPage(
      name: _Paths.TICKET_REMINDER,
      page: () => TicketReminderView(),
      binding: MyTripsBinding(),
    ),
    GetPage(
      name: _Paths.TICKET_CONDITIONS,
      page: () => TicketConditionsView(),
      binding: MyTripsBinding(),
    ),
    GetPage(
      name: _Paths.ADD_TRIP_NOTES,
      page: () => AddTripNotesView(),
      binding: MyTripsBinding(),
    ),
    GetPage(
      name: _Paths.MY_TRIPS_EDIT,
      page: () => MyTripsEditView(),
      binding: MyTripsBinding(),
    ),
    GetPage(
      name: _Paths.SUPPORT,
      page: () => SupportView(),
      binding: SupportBinding(),
    ),
    GetPage(
      name: _Paths.TRAVEL_INFO,
      page: () => TravelInfoView(),
      binding: TravelInfoBinding(),
    ),
    GetPage(
      name: _Paths.TRAVEL_ALLOWED_COUNTRIES,
      page: () => TravelAllowedCountriesView(),
      binding: TravelAllowedCountriesBinding(),
    ),
    GetPage(
      name: _Paths.AIRPORT_TAXI,
      page: () => AirportTaxiView(),
      binding: AirportTaxiBinding(),
    ),
    GetPage(
      name: _Paths.MAP_VIEW,
      page: () => MapView(),
      binding: AirportTaxiBinding(),
    ),
    GetPage(
      name: _Paths.CUSTOMER_CARE_SUPPORT,
      page: () => CustomerCareSupportView(),
      binding: CustomerCareSupportBinding(),
    ),
    GetPage(
      name: _Paths.SALES_SUPPORT,
      page: () => SalesSupportView(),
      binding: SalesSupportBinding(),
    ),
    GetPage(
      name: _Paths.LAST_PROMOTIONS,
      page: () => LastPromotionsView(),
      binding: LastPromotionsBinding(),
    ),
    GetPage(
      name: _Paths.PROMOTION_DETAILS,
      page: () => PromotionDetailsView(),
      binding: PromotionDetailsBinding(),
    ),
    GetPage(
      name: _Paths.AIRPORT_MAP,
      page: () => AirportMapView(),
      binding: AirportMapBinding(),
    ),
    GetPage(
      name: _Paths.MY_TRIPS_AGENDA,
      page: () => MyTripsAgendaView(),
      binding: MyTripsAgendaBinding(),
    ),
    GetPage(
      name: _Paths.CHOOSE_DEPARTURE_TRIP,
      page: () => ChooseDepartureTripView(),
      binding: MyTripsAgendaBinding(),
    ),
    GetPage(
      name: _Paths.CHOOSE_RETURN_TRIP,
      page: () => ChooseReturnTripView(),
      binding: MyTripsAgendaBinding(),
    ),
    GetPage(
      name: _Paths.CONFIRM_REGULAR_TRIP,
      page: () => ConfirmRegularTripView(),
      binding: MyTripsAgendaBinding(),
    ),
    GetPage(
      name: _Paths.CONFIRM_SPECIAL_TRIP,
      page: () => ConfirmSpecialTripView(),
      binding: MyTripsAgendaBinding(),
    ),
    GetPage(
      name: _Paths.NON_REGULAR_TRIP,
      page: () => NonRegularTripView(),
      binding: MyTripsAgendaBinding(),
    ),
    GetPage(
      name: _Paths.REVIEW_TRIP,
      page: () => ReviewTripView(),
      binding: MyTripsAgendaBinding(),
    ),
    GetPage(
      name: _Paths.COMING_SOON,
      page: () => const ComingSoonView(),
      binding: ComingSoonBinding(),
    ),
    GetPage(
      name: _Paths.ACCOUNT_WAITING,
      page: () => const AccountWaitingView(),
      binding: AccountWaitingBinding(),
    ),
    GetPage(
      name: _Paths.FINGERPRINT_LOGIN,
      page: () => FingerprintLoginView(),
      binding: FingerprintLoginBinding(),
    ),
    GetPage(
      name: _Paths.FINGERPRINT_SETUP,
      page: () => FingerprintSetupView(),
      binding: FingerprintSetupBinding(),
    ),
    GetPage(
      name: _Paths.MY_BOOKINGS_REQUESTS,
      page: () => MyBookingsRequestsView(),
      binding: MyBookingsRequestsBinding(),
    ),
    GetPage(
      name: _Paths.CHOOSE_PAYMENT_METHOD,
      page: () => ChoosePaymentMethodView(),
      binding: MyBookingsRequestsBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT_METHOD_DETAILS,
      page: () => PaymentMethodDetailsView(),
      binding: MyBookingsRequestsBinding(),
    ),
    GetPage(
      name: _Paths.CONFIRM_BOOKING_REQUEST,
      page: () => ConfirmBookingRequestView(),
      binding: MyBookingsRequestsBinding(),
    ),
    GetPage(
      name: _Paths.OTP_STEP,
      page: () => const OtpStepView(),
      binding: OtpStepBinding(),
    ),
    GetPage(
      name: _Paths.OTP_VERIFY,
      page: () => OTPCodeView(),
      binding: ForgetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.REFUND_OPERATION,
      page: () => RefundOperationView(),
      binding: RefundOperationBinding(),
    ),
    GetPage(
      name: _Paths.CHANGE_OPERATION,
      page: () => ChangeOperationView(),
      binding: ChangeOperationBinding(),
    ),
    GetPage(
        name: _Paths.CONFIRM_BOOKING_CONDITION,
        page: () => ConfirmBookingCondiitonView(),
        binding: MyBookingsRequestsBinding()),
    GetPage(
        name: _Paths.ADD_PASSPORTS_VIEW,
        page: () => AddPassportsView(),
        binding: MyBookingsRequestsBinding()),
    GetPage(
        name: _Paths.PASSPORT_SCANNER_VIEW,
        page: () => PassportScannerView(),
        binding: MyBookingsRequestsBinding()),
  ];
}
