import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:sky_gate/app/core/extentions/extentions.dart';
import 'package:sky_gate/app/core/theme/app_colors.dart';
import 'package:sky_gate/app/core/utils/constants/constants.dart';
import 'package:sky_gate/app/core/utils/failures/base_failure.dart';
import 'package:sky_gate/app/core/utils/failures/http/http_failure.dart';
import 'package:sky_gate/app/data/shared/shared_class.dart';
import 'package:sky_gate/app/modules/airport-taxi/models/airport_model.dart';
import 'package:sky_gate/app/modules/airport-taxi/repository/get_airports_repository.dart';
import 'package:sky_gate/app/modules/my-trips-agenda/models/city_model.dart';
import 'package:sky_gate/app/modules/my-trips-agenda/models/trip_model.dart';
import 'package:sky_gate/app/modules/my-trips-agenda/params/search_trips_params.dart';
import 'package:sky_gate/app/modules/my-trips-agenda/params/submit_booking_request_params.dart';
import 'package:sky_gate/app/modules/my-trips-agenda/repository/get_cities_repository.dart';
import 'package:sky_gate/app/modules/my-trips-agenda/repository/search_regular_trips_repository.dart';
import 'package:sky_gate/app/modules/my-trips-agenda/repository/submit_booking_request_repository.dart';
import 'package:sky_gate/app/routes/app_pages.dart';

enum GetAirportsDataStatus { initial, error, loading, success }

enum GetCitiesDataStatus { initial, error, loading, success }

enum SearchTripsDataStatus { initial, loading, error, success }

enum SubmitBookingRequestStatus { initial, loading, error, success }

class MyTripsAgendaController extends GetxController {
  bool isOneWay = true;

  TextEditingController departureDateController = TextEditingController();
  TextEditingController returnDateController = TextEditingController();
  TextEditingController passengersCountController = TextEditingController();
  TextEditingController childrenCountController =
      TextEditingController(text: "0");
  TextEditingController babiesCountController =
      TextEditingController(text: "0");
  TextEditingController adultsCountController =
      TextEditingController(text: "0");

  String? selectedDeparturePlace = "";
  String? selectedArrivalPlace = "";
  String? selectedPassengersCount = "";
  String? selectedNationality = "";
  String? selectedCurrency = "";
  String? selectedTripLevel = "";

  GetAirportsDataStatus getAirportsDataStatus = GetAirportsDataStatus.initial;
  Failure getAirportsDataFailure = const ServerFailure();
  SearchTripsDataStatus searchTripsDataStatus = SearchTripsDataStatus.initial;
  Failure searchTripsDataFailure = const ServerFailure();
  GetCitiesDataStatus getCitiesDataStatus = GetCitiesDataStatus.initial;
  Failure getCitiesDataFailure = const ServerFailure();
  SubmitBookingRequestStatus submitBookingRequestStatus =
      SubmitBookingRequestStatus.initial;
  Failure submitBookingRequestFailure = const ServerFailure();

  late GetAirportsRepository getAirportsRepository;
  late SearchRegularTripsRepository searchRegularTripsRepository;
  late GetCitiesRepository getCitiesRepository;
  late SubmitBookingRequestRepository submitBookingRequestRepository;

  List<DropdownMenuItem<String>> departureAirportsDropdownItems = [];
  List<DropdownMenuItem<String>> departureCitiesDropdownItems = [];
  List<DropdownMenuItem<String>> arrivalAirportsDropdownItems = [];
  List<DropdownMenuItem<String>> arrivalCitiesDropdownItems = [];
  List<DropdownMenuItem<String>> passengersCountDropdownItems = [];
  List<DropdownMenuItem<String>> nationalityDropdownItems = [];
  List<DropdownMenuItem<String>> currencyDropdownItems = [];
  List<DropdownMenuItem<String>> tripLevelDropdownItems = [];
  List<AirportModel> airports = [];
  List<CityModel> cities = [];

  List<TripModel> firstWayTrips = [];
  List<TripModel> firstWayTripsFiltered = [];
  List<TripModel> secondWayTrips = [];
  List<TripModel> secondWayTripsFiltered = [];

  int children = 0;
  int infants = 0;
  int adults = 0;

  int? selectedFirstWayTripID = -1;
  int? selectedFirstWayCardIndex = -1;
  int? selectedFirstWayFlightCompanyID = -1;
  int? selectedSecondWayTripID = -1;
  int? selectedSecondWayCardIndex = -1;

  late DateTime currentDate;

  final PageController pageController = PageController(viewportFraction: 2.0);
  final List<String> arabicWeekdays = [
    'الإثنين', // Monday
    'الثلاثاء', // Tuesday
    'الأربعاء', // Wednesday
    'الخميس', // Thursday
    'الجمعة', // Friday
    'السبت', // Saturday
    'الأحد', // Sunday
  ];
  final List<String> arabicMonths = [
    'كانون الثاني', // Jan
    'شباط', // Feb
    'آذار', // Mar
    'نيسان', // Apr
    'أيار', // May
    'حزيران', // June
    'تموز', // July
    'آب', // Aug
    'أيلول', // SEP
    'تشرين الأول', // Oct
    'تشرين الثاني', // Nov
    'كانون الأول', // Dec
  ];

  final dateMaskFormatter = MaskTextInputFormatter(
    mask: '##-##-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.eager,
  );

  @override
  void onInit() async {
    super.onInit();
    tripLevelDropdownItems = [
      DropdownMenuItem(
        value: "سياحية",
        child: Text("سياحية",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0)),
      ),
      DropdownMenuItem(
        value: "رجال الأعمال",
        child: Text("رجال الأعمال",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0)),
      ),
    ];

    currencyDropdownItems = [
      DropdownMenuItem(
        value: "ليرة سورية",
        child: Text("ليرة سورية",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0)),
      ),
      DropdownMenuItem(
        value: "دولار أمريكي",
        child: Text("دولار أمريكي",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0)),
      ),
    ];

    AppConfig.arabicNationalities.forEach((element) {
      nationalityDropdownItems.add(
        DropdownMenuItem(
          value: "${element}",
          child: Text("${element}",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0)),
        ),
      );
    });
    getAirportsRepository = GetAirportsRepository();
    searchRegularTripsRepository = SearchRegularTripsRepository();
    getCitiesRepository = GetCitiesRepository();
    submitBookingRequestRepository = SubmitBookingRequestRepository();
    // await getAirportsData();
    await getCitiesData();
    // airports.forEach((element) {
    //   departureAirportsDropdownItems.add(DropdownMenuItem(
    //       value: "${element.name} - ${element.city}",
    //       child: Text("${element.name} - ${element.city}"),));
    //
    //   arrivalAirportsDropdownItems.add(DropdownMenuItem(
    //     value: "${element.name} - ${element.city}",
    //     child: Text("${element.name} - ${element.city}"),));
    //   });

    cities.forEach((element) {
      departureCitiesDropdownItems.add(DropdownMenuItem(
        value: "${element.city}",
        child: Text("${element.city}"),
      ));

      arrivalCitiesDropdownItems.add(DropdownMenuItem(
        value: "${element.city}",
        child: Text("${element.city}"),
      ));
    });

    currentDate = DateTime.now();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    departureDateController.dispose();
    returnDateController.dispose();
    pageController.dispose();
    passengersCountController.dispose();
    childrenCountController.dispose();
    adultsCountController.dispose();
    babiesCountController.dispose();
    super.onClose();
  }

  void setTripDirection({bool? oneWay}) {
    isOneWay = oneWay!;
    update();
  }

  // Parse "0 طفل 5 رضيع 2 بالغ" back into numbers
  void parseText() {
    children = int.parse(childrenCountController.text.isEmpty
        ? "0"
        : childrenCountController.text);
    infants = int.parse(
        babiesCountController.text.isEmpty ? "0" : babiesCountController.text);
    adults = int.parse(
        adultsCountController.text.isEmpty ? "0" : adultsCountController.text);
  }

  void navigateDays(int offset, bool selectReturnTripPage) {
    currentDate = currentDate.add(Duration(days: offset));
    isTripWithinDate(selectReturnTripPage);
    update();
  }

  void isTripWithinDate(bool selectReturnTripPage) {
    if (selectReturnTripPage == true) {
      secondWayTripsFiltered = [];
      secondWayTrips.forEach((element) {
        // Parse trip's date range
        final startDate = DateTime.tryParse(element.repeat_start_date!);
        final endDate = DateTime.tryParse(element.repeat_end_date!);

        // Check if selected date is within range
        final isInDateRange =
            currentDate.isAfter(startDate!.subtract(const Duration(days: 1))) &&
                currentDate.isBefore(endDate!.add(const Duration(days: 1)));

        // Check day of week (if trip has specific days)
        final dayName = currentDate.getDayName(locale: 'en').toLowerCase();
        log("From CHeck trip repeat function = ${dayName}");
        if (isInDateRange &&
            element.repeat_days!.contains(dayName) &&
            (element.flight_company!.id == selectedFirstWayFlightCompanyID)) {
          secondWayTripsFiltered.add(element);
        }
      });
    } else {
      firstWayTripsFiltered = [];
      firstWayTrips.forEach((element) {
        // Parse trip's date range
        final startDate = DateTime.tryParse(element.repeat_start_date!);
        final endDate = DateTime.tryParse(element.repeat_end_date!);

        // Check if selected date is within range
        final isInDateRange =
            currentDate.isAfter(startDate!.subtract(const Duration(days: 1))) &&
                currentDate.isBefore(endDate!.add(const Duration(days: 1)));

        // Check day of week (if trip has specific days)
        final dayName = currentDate.getDayName(locale: 'en').toLowerCase();
        log("From CHeck trip repeat function = ${dayName}");
        if (isInDateRange && element.repeat_days!.contains(dayName)) {
          firstWayTripsFiltered.add(element);
        }
      });
    }
  }

  void selectFirstWayTrip({int? tripID, int? flightCompanyID, int? index}) {
    selectedFirstWayTripID = tripID;
    selectedFirstWayFlightCompanyID = flightCompanyID;
    selectedFirstWayCardIndex = index;

    update();
  }

  void selectSecondWayTrip({int? tripID, int? index}) {
    selectedSecondWayTripID = tripID;
    selectedSecondWayCardIndex = index;

    update();
  }

  Color checkTripCardBorderColor({int? index, bool? isFirstWay}) {
    Color color = Colors.transparent;
    if (isFirstWay == true) {
      if (selectedFirstWayCardIndex == index) {
        color = AppColors.blue;
      } else {
        color = Colors.transparent;
      }
    } else {
      if (selectedSecondWayCardIndex == index) {
        color = AppColors.blue;
      } else {
        color = Colors.transparent;
      }
    }

    return color;
  }

  TripModel getTripData({bool? isFirstWay}) {
    if (isFirstWay == true) {
      final index =
          firstWayTrips.indexWhere((item) => item.id == selectedFirstWayTripID);
      return firstWayTrips[index];
    } else {
      if (isOneWay == true) {
        return TripModel(
          trip_number: "--",
          departure_time: "--",
          arrival_time: "--",
        );
      } else {
        final index = secondWayTrips
            .indexWhere((item) => item.id == selectedSecondWayTripID);
        return secondWayTrips[index];
      }
    }
  }

  String getTripPriceForTripReview({bool? isFirstWay}) {
    String? totalPrice = "";
    if (isFirstWay == true) {
      final index =
          firstWayTrips.indexWhere((item) => item.id == selectedFirstWayTripID);
      final trip = firstWayTrips[index];
      if (selectedCurrency == "دولار أمريكي") {
        final cc = int.parse(trip.one_way_child_cost_dollar!);
        final bc = int.parse(trip.one_way_baby_cost_dollar!);
        final ac = int.parse(trip.one_way_adult_cost_dollar!);
        final cn = children;
        final bn = infants;
        final an = adults;

        final tp = (cc * cn) + (bc * bn) + (ac * an);
        totalPrice = "$tp \$";
      } else {
        final cc = int.parse(trip.one_way_child_cost_syp!);
        final bc = int.parse(trip.one_way_baby_cost_syp!);
        final ac = int.parse(trip.one_way_adult_cost_syp!);
        final cn = children;
        final bn = infants;
        final an = adults;

        final tp = (cc * cn) + (bc * bn) + (ac * an);
        totalPrice = "$tp ليرة سورية ";
      }
    } else {
      if (isOneWay == true) {
        final index = firstWayTrips
            .indexWhere((item) => item.id == selectedFirstWayTripID);
        final trip = firstWayTrips[index];

        if (selectedCurrency == "دولار أمريكي") {
          final cc = int.parse(trip.one_way_child_cost_dollar!);
          final bc = int.parse(trip.one_way_baby_cost_dollar!);
          final ac = int.parse(trip.one_way_adult_cost_dollar!);
          final cn = children;
          final bn = infants;
          final an = adults;

          final tp = (cc * cn) + (bc * bn) + (ac * an);
          totalPrice = "$tp \$";
        } else {
          final cc = int.parse(trip.one_way_child_cost_syp!);
          final bc = int.parse(trip.one_way_baby_cost_syp!);
          final ac = int.parse(trip.one_way_adult_cost_syp!);
          final cn = children;
          final bn = infants;
          final an = adults;

          final tp = (cc * cn) + (bc * bn) + (ac * an);
          totalPrice = "$tp ليرة سورية ";
        }
      } else {
        final index = secondWayTrips
            .indexWhere((item) => item.id == selectedSecondWayTripID);
        final trip = secondWayTrips[index];

        if (selectedCurrency == "دولار أمريكي") {
          final cc = int.parse(trip.two_way_child_cost_dollar!);
          final bc = int.parse(trip.two_way_baby_cost_dollar!);
          final ac = int.parse(trip.two_way_adult_cost_dollar!);
          final cn = children;
          final bn = infants;
          final an = adults;

          final tp = (cc * cn) + (bc * bn) + (ac * an);
          totalPrice = "$tp \$";
        } else {
          final cc = int.parse(trip.two_way_child_cost_syp!);
          final bc = int.parse(trip.two_way_baby_cost_syp!);
          final ac = int.parse(trip.two_way_adult_cost_syp!);
          final cn = children;
          final bn = infants;
          final an = adults;

          final tp = (cc * cn) + (bc * bn) + (ac * an);
          totalPrice = "$tp ليرة سورية ";
        }
      }
    }

    return totalPrice;
  }

  Future<void> getAirportsData() async {
    getAirportsDataStatus = GetAirportsDataStatus.loading;
    update();
    (await getAirportsRepository.getAirports()).fold((left) {
      getAirportsDataFailure = left;
      getAirportsDataStatus = GetAirportsDataStatus.error;
      update();
    }, (right) async {
      if (right.code == "1") {
        airports = right.data!;
        getAirportsDataStatus = GetAirportsDataStatus.success;
        update();
      } else {
        airports = [];
        getAirportsDataStatus = GetAirportsDataStatus.success;
        update();
      }
    });
  }

  Future<void> getCitiesData() async {
    getCitiesDataStatus = GetCitiesDataStatus.loading;
    update();
    (await getCitiesRepository.getCities()).fold((left) {
      getAirportsDataFailure = left;
      getCitiesDataStatus = GetCitiesDataStatus.error;
      update();
    }, (right) async {
      if (right.code == "1") {
        cities = right.data!;
        getCitiesDataStatus = GetCitiesDataStatus.success;
        update();
      } else {
        cities = [];
        getCitiesDataStatus = GetCitiesDataStatus.success;
        update();
      }
    });
  }

  Future<void> searchRegularTrips() async {
    searchTripsDataStatus = SearchTripsDataStatus.loading;
    update();

    SearchTripsParams params = SearchTripsParams(
      arrival_city: selectedArrivalPlace,
      departure_city: selectedDeparturePlace,
      departure_date: departureDateController.text,
      is_round_trip: (isOneWay) ? "false" : "true",
      return_date: returnDateController.text,
    );

    (await searchRegularTripsRepository.searchTrips(params: params)).fold(
        (left) {
      searchTripsDataFailure = left;
      searchTripsDataStatus = SearchTripsDataStatus.error;
      update();
    }, (right) async {
      if (right.code == "1") {
        firstWayTrips = right.data!.first_way_trips!;
        secondWayTrips = right.data!.return_trips!;
        searchTripsDataStatus = SearchTripsDataStatus.success;

        // final stringDate = departureDateController.text.split('-').reversed.join('-');
        final stringDate = departureDateController.text.trim();

        final formatter = DateFormat('yyyy-MM-dd', 'en');
        final formattedDate = formatter.parse(stringDate);

        currentDate = formattedDate;

        // Populate firstWayTripsFiltered based on current date
        isTripWithinDate(false);

        update();
        Get.toNamed(Routes.CHOOSE_DEPARTURE_TRIP);
      } else {
        firstWayTrips = [];
        secondWayTrips = [];
        firstWayTripsFiltered = [];
        secondWayTripsFiltered = [];
        searchTripsDataStatus = SearchTripsDataStatus.success;
        update();
        Get.toNamed(Routes.NON_REGULAR_TRIP);
      }
    });
  }

  Future<void> submitBookingRequest(
      {String? isRegularTrip, String? regularTripID}) async {
    submitBookingRequestStatus = SubmitBookingRequestStatus.loading;
    update();

    SubmitBookingRequestParams params = SubmitBookingRequestParams(
        related_user: SharedClass.userId,
        is_regular_trip: isRegularTrip,
        regular_trip_id: regularTripID,
        departure_place: selectedDeparturePlace,
        arrival_place: selectedArrivalPlace,
        is_one_way: (isOneWay == true) ? "1" : "0",
        departure_date: departureDateController.text,
        return_date: returnDateController.text,
        trip_level: selectedTripLevel,
        adults_number: adults.toString(),
        children_number: children.toString(),
        status: "waiting-price",
        total_cost: "0.0",
        currency: selectedCurrency,
        babies_number: infants.toString(),
        nationality: selectedNationality,
        payment_method: "");

    (await submitBookingRequestRepository.submit(params: params)).fold((left) {
      submitBookingRequestFailure = left;
      submitBookingRequestStatus = SubmitBookingRequestStatus.error;
      update();
    }, (right) async {
      if (right.code == "1") {
        submitBookingRequestStatus = SubmitBookingRequestStatus.success;
        update();
        if (isRegularTrip == "false") {
          Get.toNamed(Routes.CONFIRM_SPECIAL_TRIP);
        } else {
          Get.toNamed(Routes.CONFIRM_REGULAR_TRIP);
        }
      } else {
        submitBookingRequestStatus = SubmitBookingRequestStatus.success;
        update();
      }
    });
  }

  String getTripPrice({TripModel? trip}) {
    String? totalPrice = "";
    int? cc = 0;
    int? bc = 0;
    int? ac = 0;
    if (isOneWay == true) {
      if (selectedCurrency == "دولار أمريكي") {
        if (selectedTripLevel == "سياحية") {
          cc = int.tryParse(trip!.one_way_child_cost_dollar!);
          bc = int.tryParse(trip.one_way_baby_cost_dollar!);
          ac = int.tryParse(trip.one_way_adult_cost_dollar!);
        } else {
          cc = int.tryParse(trip!.one_way_business_child_cost_dollar!);
          bc = int.tryParse(trip.one_way_business_baby_cost_dollar!);
          ac = int.tryParse(trip.one_way_business_adult_cost_dollar!);
        }
        final cn = children;
        final bn = infants;
        final an = adults;

        final tp = (cc! * cn) + (bc! * bn) + (ac! * an);
        totalPrice = "$tp \$";
      } else {
        if (selectedTripLevel == "سياحية") {
          cc = int.tryParse(trip!.one_way_child_cost_syp!);
          bc = int.tryParse(trip.one_way_baby_cost_syp!);
          ac = int.tryParse(trip.one_way_adult_cost_syp!);
        } else {
          cc = int.tryParse(trip!.one_way_business_child_cost_syp!);
          bc = int.tryParse(trip.one_way_business_baby_cost_syp!);
          ac = int.tryParse(trip.one_way_business_adult_cost_syp!);
        }

        final cn = children;
        final bn = infants;
        final an = adults;

        final tp = (cc! * cn) + (bc! * bn) + (ac! * an);
        totalPrice = "$tp ليرة سورية ";
      }
    } else {
      if (selectedCurrency == "دولار أمريكي") {
        if (selectedTripLevel == "سياحية") {
          cc = int.tryParse(trip!.two_way_child_cost_dollar!);
          bc = int.tryParse(trip.two_way_baby_cost_dollar!);
          ac = int.tryParse(trip.two_way_adult_cost_dollar!);
        } else {
          cc = int.tryParse(trip!.two_way_business_child_cost_dollar!);
          bc = int.tryParse(trip.two_way_business_baby_cost_dollar!);
          ac = int.tryParse(trip.two_way_business_adult_cost_dollar!);
        }

        final cn = children;
        final bn = infants;
        final an = adults;

        final tp = (cc! * cn) + (bc! * bn) + (ac! * an);
        totalPrice = "$tp \$";
      } else {
        if (selectedTripLevel == "سياحية") {
          cc = int.tryParse(trip!.two_way_child_cost_syp!);
          bc = int.tryParse(trip.two_way_baby_cost_syp!);
          ac = int.tryParse(trip.two_way_adult_cost_syp!);
        } else {
          cc = int.tryParse(trip!.two_way_business_child_cost_syp!);
          bc = int.tryParse(trip.two_way_business_baby_cost_syp!);
          ac = int.tryParse(trip.two_way_business_adult_cost_syp!);
        }

        final cn = children;
        final bn = infants;
        final an = adults;

        final tp = (cc! * cn) + (bc! * bn) + (ac! * an);
        totalPrice = "$tp ليرة سورية ";
      }
    }

    return totalPrice;
  }
}
