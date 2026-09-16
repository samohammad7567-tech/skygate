abstract class HttpStatus {
  static const int inactiveMember = -52;
  static const int notVerified = -24;
  static const int invalidInformation = -54;
}

abstract class NetworkRoutesControl {
  static const String mainUrl = 'https://skygate.site/';
  static const String imageUrl = '${mainUrl}storage/';

  static const String apiVersion = 'v1/';
  static const String api = '${mainUrl}api/$apiVersion';
  static const String register = "${api}auth/register";
  static const String login = "${api}auth/login";
  static const String biometricsLogin = "${api}auth/biometrics-login";
  static const String forgetPassword = "${api}auth/forget-password";
  static const String getUser = "${api}auth/get-user";
  static const String updateAccount = "${api}auth/update-profile";
  static const String deleteAccount = "${api}auth/delete-account";
  static const String updateFCMToken = "${api}auth/update-fcm-token";
  static const String updateUserLang = "${api}auth/update-user-lang";
  static const String biometricsEnable = "${api}auth/biometrics-enable";
  static const String logout = "${api}auth/logout";
  static const String sendOTP = "${api}auth/otp-send";
  static const String verifyOTP = "${api}auth/otp-verify";

  static const String createAirportTaxiRequest = "${api}airport-taxis/create";
  static const String getAirportTaxiRequests = "${api}airport-taxis/get-all";
  static const String getAllFAQs = "${api}faqs/get-all";
  static const String getAllPromotions = "${api}promotions/get-all";
  static const String getAllUserTrips = "${api}user-trips/get-all";
  static const String addTripNotes = "${api}user-trips/add-notes";
  static const String acceptTripConditions =
      "${api}user-trips/accept-conditions";
  static const String getAboutTravelInfos = "${api}about-travel-infos/get-all";
  static const String getTravelAllowedCountries =
      "${api}travel-allowed-countries/get-all";

  static const String getAllMessages = "${api}messages/get-all";
  static const String createMessage = "${api}messages/create";
  static const String getOneMessage = "${api}messages/get-one";

  static const String getAllAirports = "${api}airports/get-all";
  static const String getUserNotifications = "${api}notifications/get-all";
  static const String getFlightCompanies = "${api}flight-companies/get-all";
  static const String getCountries = "${api}countries/get-all";
  static const String getCities = "${api}cities/get-all";
  static const String getPaymentMethods = "${api}payment-methods/get-all";
  static const String searchRegularTrips = "${api}regular-trips/search";
  static const String getRegularTripByID = "${api}regular-trips/get-by-id";
  static const String getRegularTripsSameCompany =
      "${api}regular-trips/get-same-company";
  static const String getBookingRequests = "${api}bookings-requests/get-all";
  static const String getBookingRequestByID = "${api}bookings-requests/get-one";
  static const String createBookingRequest = "${api}bookings-requests/create";
  static const String cancelBookingRequest = "${api}bookings-requests/cancel";
  static const String payBookingRequest = "${api}bookings-requests/pay";
  static const String acceptBookingRequestConditions =
      "${api}bookings-requests/accept-conditions";
  static const String addPassports = "${api}bookings-requests/add-passports";
  static const String submitRefundRequest = "${api}refund-requests/create";
  static const String getOneRefundRequest = "${api}refund-requests/get-one";
  static const String submitChangeRequest = "${api}change-requests/create";
  static const String getOneChangeRequest = "${api}change-requests/get-one";
  static const String payChangeRequest = "${api}change-requests/pay";
}

abstract class AppConfig {
  static const appName = "Sky Gate";
  static const otpFieldLength = 7;
  static const maxImageSize = 2;
  static const customerCareTeam = 3;
  static const salesTeam = 2;
  static const appUserType = "app_user";
  static const adminUserType = "admin_user";

  static const arabicNationalities = ["سوري", "أجنبي"];
}
