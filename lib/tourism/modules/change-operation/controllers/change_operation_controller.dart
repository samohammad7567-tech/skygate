import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/core/extentions/extentions.dart';
import 'package:skygate/tourism/core/utils/failures/base_failure.dart';
import 'package:skygate/tourism/core/utils/failures/http/http_failure.dart';
import 'package:skygate/tourism/core/utils/helpers/parse_helpers/failure_parser.dart';
import 'package:skygate/tourism/data/shared/shared_class.dart';
import 'package:skygate/tourism/modules/change-operation/bindings/change_operation_binding.dart';
import 'package:skygate/tourism/modules/change-operation/models/change_request_model.dart';
import 'package:skygate/tourism/modules/change-operation/repositories/get_change_request_repository.dart';
import 'package:skygate/tourism/modules/change-operation/repositories/get_regular_trips_repository.dart';
import 'package:skygate/tourism/modules/change-operation/repositories/pay_change_request_repository.dart';
import 'package:skygate/tourism/modules/change-operation/repositories/submit_change_request_repository.dart';
import 'package:skygate/tourism/modules/change-operation/views/after_payment_method_view.dart';
import 'package:skygate/tourism/modules/change-operation/views/change_operation_last_step_view.dart';
import 'package:skygate/tourism/modules/change-operation/views/change_request_result_view.dart';
import 'package:skygate/tourism/modules/change-operation/views/ticket_edit_success_view.dart';
import 'package:skygate/tourism/modules/my-bookings-requests/models/booking_request_model.dart';
import 'package:skygate/tourism/modules/my-bookings-requests/models/payment_method_model.dart';
import 'package:skygate/tourism/modules/my-bookings-requests/repository/get_payment_methods_repository.dart';
import 'package:skygate/tourism/modules/my-trips-agenda/models/trip_model.dart';
import 'package:skygate/tourism/modules/my-trips/models/condition_model.dart';
import 'package:skygate/tourism/modules/refund-operation/repository/accept_booking_request_conditions_repository.dart';
import 'package:skygate/tourism/modules/refund-operation/repository/get_booking_request_repository.dart';
import 'package:skygate/tourism/modules/user/repository/get_user_repository.dart';
import 'package:skygate/tourism/modules/user/user_model.dart';
import 'package:toastification/toastification.dart';

enum SubmitChangeRequestStatus { initial, error, loading, success }

enum PayChangeRequestStatus { initial, error, loading, success }

enum GetChangeRequestStatus { initial, error, loading, success }

enum GetPaymentMethodsStatus { initial, error, loading, success }

enum GetUserStatus { initial, error, loading, success }

enum AcceptRequestConditionsStatus { initial, error, loading, success }

class ChangeOperationController extends GetxController
    with GetSingleTickerProviderStateMixin {
  String? bookingID = "";
  String? changeType = "";
  final String? status = "change-operation";

  late TabController tabController;

  BookingRequestModel bookingRequest = BookingRequestModel();
  ChangeRequestModel changeRequest = ChangeRequestModel(
    change_type: "",
    change_penalty: "",
    currency: "",
    plane_missing_penalty: "",
  );
  UserModel userModel = UserModel();
  ConditionModel firstWayConditions = ConditionModel();
  ConditionModel returnConditions = ConditionModel();
  TripModel regularTrip = TripModel();
  List<TripModel> tripsList = [];
  List<TripModel> tripsListFiltered = [];
  List<PaymentMethodModel> paymentMethodsList = [];
  bool? isConditionsAccepted = false;

  double? penaltyTotalSum = 0.0;
  int? numberOfStages = 1;

  late DateTime currentDate;
  int? selectedFirstWayTripID = -1;
  int? selectedFirstWayCardIndex = -1;
  int? selectedFirstWayFlightCompanyID = -1;
  int? selectedSecondWayTripID = -1;
  int? selectedSecondWayCardIndex = -1;
  String? selectedPaymentMethod = "";

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

  SubmitChangeRequestStatus submitChangeRequestStatus =
      SubmitChangeRequestStatus.initial;
  PayChangeRequestStatus payChangeRequestStatus =
      PayChangeRequestStatus.initial;
  AcceptRequestConditionsStatus acceptRequestConditionsStatus =
      AcceptRequestConditionsStatus.initial;
  GetChangeRequestStatus getChangeRequestStatus =
      GetChangeRequestStatus.initial;
  GetPaymentMethodsStatus getPaymentMethodsStatus =
      GetPaymentMethodsStatus.initial;
  GetUserStatus getUserStatus = GetUserStatus.initial;
  Failure getChangeRequestFailure = const ServerFailure();
  Failure getUserFailure = const ServerFailure();
  Failure getPaymentMethodsFailure = const ServerFailure();
  Failure payChangeRequestFailure = const ServerFailure();

  GetBookingRequestRepository getBookingRequestRepository =
      GetBookingRequestRepository();
  GetUserRepository getUserRepository = GetUserRepository();
  AcceptBookingRequestConditionsRepository
  acceptBookingRequestConditionsRepository =
      AcceptBookingRequestConditionsRepository();
  SubmitChangeRequestRepository submitChangeRequestRepository =
      SubmitChangeRequestRepository();
  GetChangeRequestRepository getChangeRequestRepository =
      GetChangeRequestRepository();
  PayChangeRequestRepository payChangeRequestRepository =
      PayChangeRequestRepository();
  GetRegularTripsRepository getRegularTripsRepository =
      GetRegularTripsRepository();
  GetPaymentMethodsRepository getPaymentMethodsRepository =
      GetPaymentMethodsRepository();

  @override
  Future<void> onInit() async {
    super.onInit();
    bookingID = Get.arguments["id"];
    await getBookingsRequest();
    await getRegularTrip();
    await getRegularTripsSameCompany();
    if (bookingRequest.is_one_way == "0") {
      tabController = TabController(length: 2, vsync: this);
    } else {
      tabController = TabController(length: 1, vsync: this);
    }

    if (bookingRequest.status == "change-operation") {
      await getChangeRequest();
      await getPaymentMethodsData();
    }

    await getUser();
    currentDate = DateTime.now();
    detectNavigationPath();
  }



  void detectNavigationPath() {
    if (changeRequest.status == "1") {
      Get.off(
        () => ChangeOperationLastStepView(),
        binding: ChangeOperationBinding(),
        arguments: {"id": bookingID},
      );
    } else if (changeRequest.status == "2") {
      if ((changeRequest.payment_method != null &&
          changeRequest.payment_method != "")) {
        Get.off(
          () => AfterPaymentMethodView(),
          binding: ChangeOperationBinding(),
          arguments: {"id": bookingID},
        );
      } else {
        Get.off(
          () => ChangeRequestResultView(),
          binding: ChangeOperationBinding(),
          arguments: {"id": bookingID},
        );
      }
    } else if (changeRequest.status == "3") {
      Get.off(
        () => TicketEditSuccessView(),
        binding: ChangeOperationBinding(),
        arguments: {"id": bookingID},
      );
    } else {
      return;
    }
  }

  Future<void> getBookingsRequest() async {
    (await getBookingRequestRepository.getBookingsRequest(id: bookingID)).fold(
      (left) {},
      (right) async {
        if (right.code == "1") {
          bookingRequest = right.data!;
          firstWayConditions = bookingRequest.first_way_conditions!;
          returnConditions = bookingRequest.return_conditions!;
          isConditionsAccepted = (bookingRequest.conditions_accepted == "0")
              ? false
              : true;
        } else {}
      },
    );
  }

  Future<void> getRegularTrip() async {
    (await getRegularTripsRepository.getRegularTripByID(
      trip_id: bookingRequest.regular_trip_id,
    )).fold((left) {}, (right) async {
      if (right.code == "1") {
        regularTrip = right.data!;
      } else {}
    });
  }

  Future<void> getRegularTripsSameCompany() async {
    (await getRegularTripsRepository.getRegularTripsSameCompany(
      company_id: regularTrip.flight_company!.id.toString(),
    )).fold((left) {}, (right) async {
      if (right.code == "1") {
        tripsList = right.data!;
      } else {}
    });
  }

  Future<void> getUser() async {
    final token = SharedClass.apiToken;
    final userID = SharedClass.userId;

    getUserStatus = GetUserStatus.loading;
    update();

    (await getUserRepository.getUserByID(token: token, userID: userID)).fold(
      (left) {
        getUserFailure = left;
        getUserStatus = GetUserStatus.success;
        update();
      },
      (right) {
        if (right.code == "1") {
          userModel = right.data!;
          getUserStatus = GetUserStatus.success;
          update();
        }
      },
    );
  }

  String getTripTypeText() {
    if (bookingRequest.is_one_way == "1") {
      return "هذه التذكرة ذهاب فقط";
    } else {
      return "هذه التذكرة ذهاب - عودة";
    }
  }

  Future<void> acceptRequestConditions({BuildContext? context}) async {
    acceptRequestConditionsStatus = AcceptRequestConditionsStatus.loading;
    update();

    (await acceptBookingRequestConditionsRepository
            .acceptBookingRequestConditions(booking_request_id: bookingID))
        .fold(
          (left) {
            acceptRequestConditionsStatus =
                AcceptRequestConditionsStatus.success;
            update();
            String? error = FailureParser.mapFailureToString(
              failure: left,
              context: context!,
            );
            toastification.show(
              context: context,
              title: const Text("قبول شروط الطلب"),
              description: Text(error),
              type: ToastificationType.error,
              style: ToastificationStyle.fillColored,
              autoCloseDuration: const Duration(seconds: 8),
            );
          },
          (right) async {
            if (right.code == "1") {
              acceptRequestConditionsStatus =
                  AcceptRequestConditionsStatus.success;
              isConditionsAccepted = true;
              update();
              toastification.show(
                context: Get.overlayContext,
                title: const Text("قبول شروط الطلب"),
                description: Text(right.message!),
                type: ToastificationType.success,
                style: ToastificationStyle.fillColored,
                autoCloseDuration: const Duration(seconds: 8),
              );
              Get.back();
            } else {
              acceptRequestConditionsStatus =
                  AcceptRequestConditionsStatus.success;
              update();
              toastification.show(
                context: context,
                title: const Text("قبول شروط الطلب"),
                description: Text(right.message!),
                type: ToastificationType.info,
                style: ToastificationStyle.fillColored,
                autoCloseDuration: const Duration(seconds: 8),
              );
            }
          },
        );
  }

  Future<void> submitChangeRequest({BuildContext? context}) async {
    submitChangeRequestStatus = SubmitChangeRequestStatus.loading;
    update();

    (await submitChangeRequestRepository.submitChangeRequest(
      booking_request_number: bookingRequest.request_number,
      change_type: changeType,
      first_way_trip_id: selectedFirstWayTripID.toString(),
      return_trip_id: selectedSecondWayTripID.toString(),
    )).fold(
      (left) {
        submitChangeRequestStatus = SubmitChangeRequestStatus.error;
        update();
        String? error = FailureParser.mapFailureToString(
          failure: left,
          context: context!,
        );
        toastification.show(
          context: context,
          title: const Text("تسجيل طلب التعديل"),
          description: Text(error),
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 8),
        );
      },
      (right) async {
        if (right.code == "1") {
          submitChangeRequestStatus = SubmitChangeRequestStatus.success;
          update();
          toastification.show(
            context: Get.overlayContext,
            title: const Text("تسجيل طلب التعديل"),
            description: Text(right.message!),
            type: ToastificationType.success,
            style: ToastificationStyle.fillColored,
            autoCloseDuration: const Duration(seconds: 8),
          );
          Get.to(() => ChangeOperationLastStepView());
        } else {
          submitChangeRequestStatus = SubmitChangeRequestStatus.success;
          update();
          toastification.show(
            context: context,
            title: const Text("تسجيل طلب التعديل"),
            description: Text(right.message!),
            type: ToastificationType.info,
            style: ToastificationStyle.fillColored,
            autoCloseDuration: const Duration(seconds: 8),
          );
        }
      },
    );
  }

  Future<void> getChangeRequest() async {
    getChangeRequestStatus = GetChangeRequestStatus.loading;
    update();

    (await getChangeRequestRepository.getChangeRequest(
      booking_request_number: bookingRequest.request_number,
    )).fold(
      (left) {
        getChangeRequestFailure = left;
        getChangeRequestStatus = GetChangeRequestStatus.error;
        update();
      },
      (right) async {
        if (right.code == "1") {
          changeRequest = right.data!;
          if (changeRequest.plane_missing_penalty!.contains(".")) {
            penaltyTotalSum =
                double.parse(changeRequest.plane_missing_penalty!) +
                double.parse(changeRequest.change_penalty!) +
                double.parse(changeRequest.cost_difference!);
          } else if (changeRequest.plane_missing_penalty == null ||
              changeRequest.plane_missing_penalty == "") {
            penaltyTotalSum = 0.0;
          } else {
            penaltyTotalSum =
                double.parse("${changeRequest.plane_missing_penalty!}.00") +
                double.parse("${changeRequest.change_penalty!}.00") +
                double.parse("${changeRequest.cost_difference!}.00");
          }

          getChangeRequestStatus = GetChangeRequestStatus.success;
          update();
        } else {
          getChangeRequestStatus = GetChangeRequestStatus.success;
          update();
        }
      },
    );
  }

  String getChangeResultMsgPageTitle() {
    if (changeRequest.status == "1") {
      return "طلبك قيد المعالجة";
    } else if (changeRequest.status == "2") {
      return "طلبك قيد التنفيذ";
    } else if (changeRequest.status == "3") {
      return "تم تأكيد طلبك";
    } else {
      return "طلبك قيد المعالجة";
    }
  }

  Widget getChangeResultMsgPageContent() {
    if (changeRequest.status == "1") {
      return Container(
        width: 376.0.w,
        height: 250.0.h,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(bottom: 60.0.h)),
            Image.asset("assets/images/pngs/tick.png"),
            Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
            SizedBox(
              width: 276.0.w,
              child: Text(
                'سوف تصلك التفاصيل خلال وقت قصير',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF195AA7),
                  fontSize: 13.0,
                  fontWeight: FontWeight.w400,
                  height: 1.69,
                ),
              ),
            ),
          ],
        ),
      );
    } else if (changeRequest.status == "2") {
      return Container(
        width: 376.0.w,
        height: 400.0.h,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(bottom: 60.0.h)),
            Image.asset("assets/images/pngs/tick.png"),
            Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
            SizedBox(
              width: 276.0.w,
              child: Text(
                'قد يستغرق الطلب من 10 الى 25 يوم',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF195AA7),
                  fontSize: 13.0,
                  fontWeight: FontWeight.w400,
                  height: 1.69,
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 60.0.h)),
            SizedBox(
              width: 276.0.w,
              child: Text(
                'ملاحظة هامة',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF195AA7),
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400,
                  height: 1.10,
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
            SizedBox(
              width: 276.0.w,
              child: Text(
                'في حال وجود وجود اي استفسارات الرجاء التواصل مع خدمة العملاء',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF195AA7),
                  fontSize: 13.0,
                  fontWeight: FontWeight.w400,
                  height: 1.69,
                ),
              ),
            ),
          ],
        ),
      );
    } else if (changeRequest.status == "3") {
      return Container(
        width: 376.0.w,
        height: 400.0.h,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(bottom: 60.0.h)),
            Image.asset("assets/images/pngs/tick.png"),
            Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
            SizedBox(
              width: 276.0.w,
              child: Text(
                'قد تم تأكيد طلبك، يمكنك زيارة المكتب لاستكمال الإجراءات.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF195AA7),
                  fontSize: 13.0,
                  fontWeight: FontWeight.w400,
                  height: 1.69,
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 60.0.h)),
            SizedBox(
              width: 276.0.w,
              child: Text(
                'ملاحظة هامة',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF195AA7),
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400,
                  height: 1.10,
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
            SizedBox(
              width: 276.0.w,
              child: Text(
                'في حال وجود وجود اي استفسارات الرجاء التواصل مع خدمة العملاء',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF195AA7),
                  fontSize: 13.0,
                  fontWeight: FontWeight.w400,
                  height: 1.69,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        width: 376.0.w,
        height: 250.0.h,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(bottom: 60.0.h)),
            Image.asset("assets/images/pngs/tick.png"),
            Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
            SizedBox(
              width: 276.0.w,
              child: Text(
                'سوف تصلك التفاصيل خلال وقت قصير',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF195AA7),
                  fontSize: 13.0,
                  fontWeight: FontWeight.w400,
                  height: 1.69,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  void navigateDays(int offset, bool selectReturnTripPage) {
    currentDate = currentDate.add(Duration(days: offset));
    isTripWithinDate(selectReturnTripPage);
    update();
  }

  void isTripWithinDate(bool selectReturnTripPage) {
    tripsListFiltered = [];
    if (selectReturnTripPage) {
      for (var element in tripsList) {
        final startDate = DateTime.tryParse(element.repeat_start_date!);
        final endDate = DateTime.tryParse(element.repeat_end_date!);
        final isInDateRange =
            currentDate.isAfter(startDate!.subtract(const Duration(days: 1))) &&
            currentDate.isBefore(endDate!.add(const Duration(days: 1)));
        final dayName = currentDate.getDayName(locale: 'en').toLowerCase();
        log("From CHeck trip repeat function = $dayName");
        if (isInDateRange &&
            element.repeat_days!.contains(dayName) &&
            (element.flight_company!.id == selectedFirstWayFlightCompanyID)) {
          tripsListFiltered.add(element);
        }
      }
    } else {
      for (var element in tripsList) {
        final startDate = DateTime.tryParse(element.repeat_start_date!);
        final endDate = DateTime.tryParse(element.repeat_end_date!);
        final isInDateRange =
            currentDate.isAfter(startDate!.subtract(const Duration(days: 1))) &&
            currentDate.isBefore(endDate!.add(const Duration(days: 1)));
        final dayName = currentDate.getDayName(locale: 'en').toLowerCase();
        log("From CHeck trip repeat function = $dayName");
        if (isInDateRange && element.repeat_days!.contains(dayName)) {
          tripsListFiltered.add(element);
        }
      }
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
        color = Colors.red;
      } else {
        color = Colors.transparent;
      }
    } else {
      if (selectedSecondWayCardIndex == index) {
        color = Colors.red;
      } else {
        color = Colors.transparent;
      }
    }

    return color;
  }

  String getTripPrice({TripModel? trip}) {
    String? totalPrice = "";
    int? cc = 0;
    int? bc = 0;
    int? ac = 0;
    if (bookingRequest.is_one_way == "1") {
      if (bookingRequest.currency == "دولار أمريكي") {
        if (bookingRequest.trip_level == "سياحية") {
          cc = int.tryParse(trip!.one_way_child_cost_dollar!);
          bc = int.tryParse(trip.one_way_baby_cost_dollar!);
          ac = int.tryParse(trip.one_way_adult_cost_dollar!);
        } else {
          cc = int.tryParse(trip!.one_way_business_child_cost_dollar!);
          bc = int.tryParse(trip.one_way_business_baby_cost_dollar!);
          ac = int.tryParse(trip.one_way_business_adult_cost_dollar!);
        }
        final cn = int.parse(bookingRequest.children_number!);
        final bn = int.parse(bookingRequest.babies_number!);
        final an = int.parse(bookingRequest.adults_number!);

        final tp = (cc! * cn) + (bc! * bn) + (ac! * an);
        totalPrice = "$tp \$";
      } else {
        if (bookingRequest.trip_level == "سياحية") {
          cc = int.tryParse(trip!.one_way_child_cost_syp!);
          bc = int.tryParse(trip.one_way_baby_cost_syp!);
          ac = int.tryParse(trip.one_way_adult_cost_syp!);
        } else {
          cc = int.tryParse(trip!.one_way_business_child_cost_syp!);
          bc = int.tryParse(trip.one_way_business_baby_cost_syp!);
          ac = int.tryParse(trip.one_way_business_adult_cost_syp!);
        }

        final cn = int.parse(bookingRequest.children_number!);
        final bn = int.parse(bookingRequest.babies_number!);
        final an = int.parse(bookingRequest.adults_number!);

        final tp = (cc! * cn) + (bc! * bn) + (ac! * an);
        totalPrice = "$tp ليرة سورية ";
      }
    } else {
      if (bookingRequest.currency == "دولار أمريكي") {
        if (bookingRequest.trip_level == "سياحية") {
          cc = int.tryParse(trip!.two_way_child_cost_dollar!);
          bc = int.tryParse(trip.two_way_baby_cost_dollar!);
          ac = int.tryParse(trip.two_way_adult_cost_dollar!);
        } else {
          cc = int.tryParse(trip!.two_way_business_child_cost_dollar!);
          bc = int.tryParse(trip.two_way_business_baby_cost_dollar!);
          ac = int.tryParse(trip.two_way_business_adult_cost_dollar!);
        }

        final cn = int.parse(bookingRequest.children_number!);
        final bn = int.parse(bookingRequest.babies_number!);
        final an = int.parse(bookingRequest.adults_number!);

        final tp = (cc! * cn) + (bc! * bn) + (ac! * an);
        totalPrice = "$tp \$";
      } else {
        if (bookingRequest.trip_level == "سياحية") {
          cc = int.tryParse(trip!.two_way_child_cost_syp!);
          bc = int.tryParse(trip.two_way_baby_cost_syp!);
          ac = int.tryParse(trip.two_way_adult_cost_syp!);
        } else {
          cc = int.tryParse(trip!.two_way_business_child_cost_syp!);
          bc = int.tryParse(trip.two_way_business_baby_cost_syp!);
          ac = int.tryParse(trip.two_way_business_adult_cost_syp!);
        }

        final cn = int.parse(bookingRequest.children_number!);
        final bn = int.parse(bookingRequest.babies_number!);
        final an = int.parse(bookingRequest.adults_number!);

        final tp = (cc! * cn) + (bc! * bn) + (ac! * an);
        totalPrice = "$tp ليرة سورية ";
      }
    }

    return totalPrice;
  }

  Future<void> payChangeRequest() async {
    payChangeRequestStatus = PayChangeRequestStatus.loading;
    update();

    (await payChangeRequestRepository.payChangeRequest(
      payment_method: selectedPaymentMethod,
      booking_request_number: bookingRequest.request_number,
    )).fold(
      (left) {
        payChangeRequestFailure = left;
        payChangeRequestStatus = PayChangeRequestStatus.error;
        update();
      },
      (right) async {
        if (right.code == "1") {
          payChangeRequestStatus = PayChangeRequestStatus.success;
          update();
          Get.to(() => AfterPaymentMethodView());
        } else {
          payChangeRequestStatus = PayChangeRequestStatus.success;
          update();
        }
      },
    );
  }

  Future<void> getPaymentMethodsData() async {
    getPaymentMethodsStatus = GetPaymentMethodsStatus.loading;
    update();

    (await getPaymentMethodsRepository.getPaymentMethods()).fold(
      (left) {
        getPaymentMethodsFailure = left;
        getPaymentMethodsStatus = GetPaymentMethodsStatus.error;
        update();
      },
      (right) async {
        if (right.code == "1") {
          getPaymentMethodsStatus = GetPaymentMethodsStatus.success;
          update();
          paymentMethodsList = right.data!;
        } else {
          paymentMethodsList = [];
          getPaymentMethodsStatus = GetPaymentMethodsStatus.success;
          update();
        }
      },
    );
  }

  void onPaymentMethodSelect({int? id, String? paymentMethod}) {
    selectedPaymentMethod = paymentMethod;
    update();
  }
}
