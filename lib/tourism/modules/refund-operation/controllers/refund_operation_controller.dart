import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/core/utils/failures/base_failure.dart';
import 'package:skygate/tourism/core/utils/failures/http/http_failure.dart';
import 'package:skygate/tourism/core/utils/helpers/parse_helpers/failure_parser.dart';
import 'package:skygate/tourism/data/shared/shared_class.dart';
import 'package:skygate/tourism/modules/my-bookings-requests/models/booking_request_model.dart';
import 'package:skygate/tourism/modules/my-trips/models/condition_model.dart';
import 'package:skygate/tourism/modules/refund-operation/models/refund_request_model.dart';
import 'package:skygate/tourism/modules/refund-operation/repository/accept_booking_request_conditions_repository.dart';
import 'package:skygate/tourism/modules/refund-operation/repository/get_booking_request_repository.dart';
import 'package:skygate/tourism/modules/refund-operation/repository/get_refund_request_repository.dart';
import 'package:skygate/tourism/modules/refund-operation/repository/submit_refund_request_repository.dart';
import 'package:skygate/tourism/modules/user/repository/get_user_repository.dart';
import 'package:skygate/tourism/modules/user/user_model.dart';
import 'package:toastification/toastification.dart';

enum SubmitRefundRequestStatus { initial, error, loading, success }

enum GetRefundRequestStatus { initial, error, loading, success }

enum AcceptRequestConditionsStatus { initial, error, loading, success }

class RefundOperationController extends GetxController
    with GetSingleTickerProviderStateMixin {
  String? bookingID = "";
  String? refundType = "";
  final String? status = "refund-operation";

  late TabController tabController;

  BookingRequestModel bookingRequest = BookingRequestModel();
  RefundRequestModel refundRequest = RefundRequestModel(
      refund_amount: "",
      refund_type: "",
      cancel_penalty: "",
      currency: "",
      plane_missing_penalty: "");
  UserModel userModel = UserModel();
  ConditionModel firstWayConditions = ConditionModel();
  ConditionModel returnConditions = ConditionModel();
  bool? isConditionsAccepted = false;

  double? penaltyTotalSum = 0.0;

  SubmitRefundRequestStatus submitRefundRequestStatus =
      SubmitRefundRequestStatus.initial;
  AcceptRequestConditionsStatus acceptRequestConditionsStatus =
      AcceptRequestConditionsStatus.initial;
  GetRefundRequestStatus getRefundRequestStatus =
      GetRefundRequestStatus.initial;
  Failure getRefundRequestFailure = const ServerFailure();

  GetBookingRequestRepository getBookingRequestRepository =
      GetBookingRequestRepository();
  GetUserRepository getUserRepository = GetUserRepository();
  AcceptBookingRequestConditionsRepository
      acceptBookingRequestConditionsRepository =
      AcceptBookingRequestConditionsRepository();
  SubmitRefundRequestRepository submitRefundRequestRepository =
      SubmitRefundRequestRepository();
  GetRefundRequestRepository getRefundRequestRepository =
      GetRefundRequestRepository();

  @override
  Future<void> onInit() async {
    super.onInit();
    bookingID = Get.arguments["id"];
    await getBookingsRequest();
    await getUser();
    if (bookingRequest.is_one_way == "0") {
      tabController = TabController(length: 2, vsync: this);
    } else {
      tabController = TabController(length: 1, vsync: this);
    }

    if (bookingRequest.status == "refund-operation") {
      await getRefundRequest();
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getBookingsRequest() async {
    (await getBookingRequestRepository.getBookingsRequest(id: bookingID))
        .fold((left) {}, (right) async {
      if (right.code == "1") {
        bookingRequest = right.data!;
        firstWayConditions = bookingRequest.first_way_conditions!;
        returnConditions = bookingRequest.return_conditions!;
        isConditionsAccepted =
            (bookingRequest.conditions_accepted == "0") ? false : true;
      } else {}
    });
  }

  Future<void> getUser() async {
    final token = SharedClass.apiToken;
    final userID = SharedClass.userId;

    (await getUserRepository.getUserByID(token: token, userID: userID))
        .fold((left) {}, (right) {
      if (right.code == "1") {
        userModel = right.data!;
      }
    });
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
        .fold((left) {
      acceptRequestConditionsStatus = AcceptRequestConditionsStatus.success;
      update();
      String? error =
          FailureParser.mapFailureToString(failure: left, context: context!);
      toastification.show(
        context: context,
        title: const Text("قبول شروط الطلب"),
        description: Text(error),
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 8),
      );
    }, (right) async {
      if (right.code == "1") {
        acceptRequestConditionsStatus = AcceptRequestConditionsStatus.success;
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
        acceptRequestConditionsStatus = AcceptRequestConditionsStatus.success;
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
    });
  }

  Future<void> submitRefundRequest({BuildContext? context}) async {
    submitRefundRequestStatus = SubmitRefundRequestStatus.loading;
    update();

    (await submitRefundRequestRepository.submitRefundRequest(
            booking_request_number: bookingRequest.request_number,
            refund_type: refundType))
        .fold((left) {
      submitRefundRequestStatus = SubmitRefundRequestStatus.success;
      update();
      String? error =
          FailureParser.mapFailureToString(failure: left, context: context!);
      toastification.show(
        context: context,
        title: const Text("تسجيل طلب استرداد"),
        description: Text(error),
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 8),
      );
    }, (right) async {
      if (right.code == "1") {
        submitRefundRequestStatus = SubmitRefundRequestStatus.success;
        update();
        toastification.show(
          context: Get.overlayContext,
          title: const Text("تسجيل طلب استرداد"),
          description: Text(right.message!),
          type: ToastificationType.success,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 8),
        );
        Get.back();
      } else {
        submitRefundRequestStatus = SubmitRefundRequestStatus.success;
        update();
        toastification.show(
          context: context,
          title: const Text("تسجيل طلب استرداد"),
          description: Text(right.message!),
          type: ToastificationType.info,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 8),
        );
      }
    });
  }

  Future<void> getRefundRequest() async {
    getRefundRequestStatus = GetRefundRequestStatus.loading;
    update();

    (await getRefundRequestRepository.getRefundRequest(
            booking_request_number: bookingRequest.request_number))
        .fold((left) {
      getRefundRequestFailure = left;
      getRefundRequestStatus = GetRefundRequestStatus.error;
      update();
    }, (right) async {
      if (right.code == "1") {
        refundRequest = right.data!;
        if (refundRequest.plane_missing_penalty!.contains(".")) {
          penaltyTotalSum = double.parse(refundRequest.plane_missing_penalty!) +
              double.parse(refundRequest.cancel_penalty!);
        } else if (refundRequest.plane_missing_penalty == null ||
            refundRequest.plane_missing_penalty == "") {
          penaltyTotalSum = 0.0;
        } else {
          penaltyTotalSum =
              double.parse(refundRequest.plane_missing_penalty! + ".00") +
                  double.parse(refundRequest.cancel_penalty! + ".00");
        }

        getRefundRequestStatus = GetRefundRequestStatus.success;
        update();
      } else {
        getRefundRequestStatus = GetRefundRequestStatus.success;
        update();
      }
    });
  }

  String getRefundResultMsgPageTitle() {
    if (refundRequest.status == "1") {
      return "طلبك قيد المعالجة";
    } else if (refundRequest.status == "2") {
      return "طلبك قيد التنفيذ";
    } else if (refundRequest.status == "3") {
      return "تم تأكيد طلبك";
    } else {
      return "طلبك قيد المعالجة";
    }
  }

  Widget getRefundResultMsgPageContent() {
    if (refundRequest.status == "1") {
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
            Image.asset("assets/images/tick.png"),
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
    } else if (refundRequest.status == "2") {
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
            Image.asset("assets/images/tick.png"),
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
    } else if (refundRequest.status == "3") {
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
            Image.asset("assets/images/tick.png"),
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
            Image.asset("assets/images/tick.png"),
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
}
