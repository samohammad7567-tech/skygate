import 'dart:io';

import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skygate/tourism/core/utils/failures/base_failure.dart';
import 'package:skygate/tourism/core/utils/failures/http/http_failure.dart';
import 'package:skygate/tourism/modules/my-bookings-requests/models/booking_request_model.dart';
import 'package:flutter/material.dart';
import 'package:skygate/tourism/modules/my-bookings-requests/repository/get_bookings_requests_repository.dart';
import 'package:skygate/tourism/modules/my-bookings-requests/models/payment_method_model.dart';
import 'package:skygate/tourism/modules/my-bookings-requests/models/passport_model.dart';
import 'package:skygate/tourism/modules/my-bookings-requests/repository/cancel_booking_request_repository.dart';
import 'package:skygate/tourism/modules/my-bookings-requests/repository/get_payment_methods_repository.dart';
import 'package:skygate/tourism/modules/my-bookings-requests/repository/pay_booking_request_repository.dart';
import 'package:skygate/tourism/modules/my-bookings-requests/repository/accept_booking_conditions_repository.dart';
import 'package:skygate/tourism/modules/my-bookings-requests/repository/add_passports_repository.dart';

enum GetBookingsRequestsDataStatus { initial, loading, error, success }

enum GetPaymentMethodsDataStatus { initial, loading, error, success }

enum CancelBookingsRequestStatus { initial, loading, error, success }

enum PayBookingsRequestStatus { initial, loading, error, success }

enum AcceptBookingConditionsStatus { initial, loading, error, success }

enum AddPassportsStatus { initial, loading, error, success }

enum CameraPermissionStatus { loading, granted, denied }

class MyBookingsRequestsController extends GetxController {
  GetBookingsRequestsDataStatus getBookingsRequestsDataStatus =
      GetBookingsRequestsDataStatus.initial;
  Failure getBookingsRequestsDataFailure = const ServerFailure();
  GetPaymentMethodsDataStatus getPaymentMethodsDataStatus =
      GetPaymentMethodsDataStatus.initial;
  Failure getPaymentMethodsDataFailure = const ServerFailure();
  CancelBookingsRequestStatus cancelBookingsRequestStatus =
      CancelBookingsRequestStatus.initial;
  Failure cancelBookingsRequestFailure = const ServerFailure();
  PayBookingsRequestStatus payBookingsRequestStatus =
      PayBookingsRequestStatus.initial;
  Failure payBookingsRequestFailure = const ServerFailure();
  AcceptBookingConditionsStatus acceptBookingConditionsStatus =
      AcceptBookingConditionsStatus.initial;
  Failure acceptBookingConditionsFailure = const ServerFailure();
  AddPassportsStatus addPassportsStatus = AddPassportsStatus.initial;
  Failure addPassportsFailure = const ServerFailure();

  late GetBookingsRequestsRepository getBookingsRequestsRepository;
  late CancelBookingRequestRepository cancelBookingRequestRepository;
  late PayBookingRequestRepository payBookingRequestRepository;
  late GetPaymentMethodsRepository getPaymentMethodsRepository;
  late AcceptBookingConditionsRepository acceptBookingConditionsRepository;
  late AddPassportsRepository addPassportsRepository;

  List<BookingRequestModel> bookingsRequestsList = [];
  List<PaymentMethodModel> paymentMethodsList = [];
  List<PassportModel> passports = [];
  List<File> passportFiles = [];

  String? selectedPaymentMethod = "";
  int? selectedBookingRequestID = -1;
  BookingRequestModel? selectedBookingRequest;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController nationalNumberController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController passportNumberController = TextEditingController();
  TextEditingController passportExpiryDateController = TextEditingController();
  TextEditingController nationalityController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  String? selectedGender = "";
  String? selectedNationality = "";

  @override
  void onInit() async {
    super.onInit();
    getBookingsRequestsRepository = GetBookingsRequestsRepository();
    cancelBookingRequestRepository = CancelBookingRequestRepository();
    payBookingRequestRepository = PayBookingRequestRepository();
    getPaymentMethodsRepository = GetPaymentMethodsRepository();
    acceptBookingConditionsRepository = AcceptBookingConditionsRepository();
    addPassportsRepository = AddPassportsRepository();
    await getBookingsRequestsData();
  }



  bool addPassport(PassportModel passport) {
    if (passportFiles.isNotEmpty) {
      Get.snackbar(
        "تنبيه",
        "لا يمكنك إضافة جوازات ممسوحة بالكاميرا أثناء وجود ملفات مرفقة. يرجى إزالة الملفات المرفقة أولاً.",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
      return false;
    }

    debugPrint("Adding passport: ${passport.passportNumber}");
    bool isDuplicate = passports.any(
      (existingPassport) =>
          existingPassport.passportNumber == passport.passportNumber,
    );

    debugPrint("Is duplicate: $isDuplicate");
    if (isDuplicate) {
      Get.snackbar(
        "خطأ",
        "جواز السفر ${passport.passportNumber} موجود مسبقاً",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
      return false; // Duplicate found
    }
    try {
      debugPrint("Parsing expiry date: ${passport.passportExpiryDate}");
      List<String> dateParts = passport.passportExpiryDate.split('/');
      if (dateParts.length != 3) {
        throw FormatException('Invalid date format');
      }

      int day = int.parse(dateParts[0]);
      int month = int.parse(dateParts[1]);
      int year = int.parse(dateParts[2]);

      DateTime expiryDate = DateTime(year, month, day);
      DateTime now = DateTime.now();

      debugPrint("Expiry date: $expiryDate, Now: $now");
      if (expiryDate.isBefore(now)) {
        debugPrint("Passport is expired");
        Get.snackbar(
          "خطأ",
          "جواز السفر ${passport.passportNumber} منتهي الصلاحية. لا يمكن إضافته.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
        return false; // Expired passport
      }
      if (isExpiringWithinSixMonths(expiryDate)) {
        debugPrint("Passport expires within 6 months");
        Get.snackbar(
          "تحذير",
          "جواز السفر ${passport.passportNumber} سينتهي خلال 6 أشهر",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      debugPrint("Error parsing date: $e");
      Get.snackbar(
        "خطأ",
        "تاريخ انتهاء صلاحية جواز السفر ${passport.passportNumber} غير صحيح",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false; // Invalid date
    }
    debugPrint("Adding passport to list");
    passports.add(passport);
    update();
    debugPrint("Passport added successfully");
    return true; // Successfully added
  }

  Future<void> removePassport(int index) async {
    if (index < 0 || index >= passports.length) return;

    final passport = passports[index];
    if (passport.fileUrl.isNotEmpty) {
      (await addPassportsRepository.removePassportFiles(
        bookingRequestId: selectedBookingRequest?.id.toString(),
        deletedIndices: [index],
      )).fold(
        (left) {
          Get.snackbar(
            "خطأ",
            "فشل حذف ملف الجواز. يرجى المحاولة مرة أخرى.",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
        },
        (right) async {
          if (right.code == "1") {
            passports.removeAt(index);
            update();
            await getBookingsRequestsData();
          } else {
            Get.snackbar(
              "خطأ",
              "فشل حذف ملف الجواز. يرجى المحاولة مرة أخرى.",
              backgroundColor: Colors.red,
              colorText: Colors.white,
              duration: const Duration(seconds: 3),
            );
          }
        },
      );
    } else {
      passports.removeAt(index);
      update();
    }
  }

  void clearPassports() {
    passports.clear();
    update();
  }

  void setPassportFiles(List<File> files) {
    passportFiles = files;
    update();
  }

  void addPassportFiles(List<File> files) {
    passportFiles.addAll(files);
    update();
  }

  void clearPassportFiles() {
    passportFiles.clear();
    update();
  }

  void removePassportFile(int index) {
    passportFiles.removeAt(index);
    update();
  }

  void loadPassportsFromSelectedBooking() {
    passports.clear();
    if (selectedBookingRequest?.passports != null &&
        selectedBookingRequest!.passports!.isNotEmpty) {
      passports.addAll(selectedBookingRequest!.passports!);
      update();
    }
  }

  CameraPermissionStatus cameraPermissionStatus =
      CameraPermissionStatus.loading;
  Future<void> getCameraPermission() async {
    final perm = await Permission.camera.request();

    if (perm.isGranted) {
      cameraPermissionStatus = CameraPermissionStatus.granted;
      update();
    } else {
      cameraPermissionStatus = CameraPermissionStatus.denied;
      update();
    }
  }

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  bool isExpiringWithinSixMonths(DateTime expiryDate) {
    final now = DateTime.now();
    final sixMonthsFromNow = DateTime(now.year, now.month + 6, now.day);

    return expiryDate.isBefore(sixMonthsFromNow) ||
        expiryDate.isAtSameMomentAs(sixMonthsFromNow);
  }

  Color getRequestStatusColor({String? status}) {
    if (status == "waiting-price") {
      return const Color(0xFF4594F1);
    } else if (status == "waiting-confirm") {
      return const Color(0xFFEF7E1C);
    } else if (status == "cancelled") {
      return const Color(0xFFE7181B);
    } else if (status == "refund-operation") {
      return const Color(0xFFA45AF4);
    } else if (status == "change-operation") {
      return const Color(0xFF143202);
    } else {
      return const Color(0xFF02AF14);
    }
  }

  String getRequestStatusString({String? status}) {
    if (status == "waiting-price") {
      return "بانتظار تحديد السعر";
    } else if (status == "waiting-confirm") {
      return "بانتظار التثبيت";
    } else if (status == "cancelled") {
      return "ملغي";
    } else if (status == "change-operation") {
      return "عملية تعديل";
    } else if (status == "refund-operation") {
      return "عملية استرداد";
    } else {
      return "مؤكد";
    }
  }

  void onPaymentMethodSelect({int? id, String? paymentMethod}) {
    selectedPaymentMethod = paymentMethod;
    selectedBookingRequestID = id;
    update();
  }

  Future<void> getBookingsRequestsData() async {
    getBookingsRequestsDataStatus = GetBookingsRequestsDataStatus.loading;
    update();

    (await getBookingsRequestsRepository.getBookingsRequests()).fold(
      (left) {
        getBookingsRequestsDataStatus = GetBookingsRequestsDataStatus.error;
        update();
      },
      (right) async {
        if (right.code == "1") {
          bookingsRequestsList = right.data!;
          getBookingsRequestsDataStatus = GetBookingsRequestsDataStatus.success;
          update();
        } else {
          bookingsRequestsList = [];
          getBookingsRequestsDataStatus = GetBookingsRequestsDataStatus.success;
          update();
        }
      },
    );
  }

  Future<void> cancelBookingRequest({String? bookingRequestID}) async {
    cancelBookingsRequestStatus = CancelBookingsRequestStatus.loading;
    update();

    (await cancelBookingRequestRepository.cancel(
      booking_request_id: bookingRequestID,
    )).fold(
      (left) {
        cancelBookingsRequestFailure = left;
        cancelBookingsRequestStatus = CancelBookingsRequestStatus.error;
        update();
      },
      (right) async {
        if (right.code == "1") {
          cancelBookingsRequestStatus = CancelBookingsRequestStatus.success;
          update();
        } else {
          cancelBookingsRequestStatus = CancelBookingsRequestStatus.success;
          update();
        }
      },
    );
  }

  Future<void> payBookingRequest() async {
    payBookingsRequestStatus = PayBookingsRequestStatus.loading;
    update();
    debugPrint("selectedPaymentMethod: $selectedPaymentMethod");
    (await payBookingRequestRepository.pay(
      payment_method: selectedPaymentMethod,
      bookingRequestID: selectedBookingRequestID.toString(),
    )).fold(
      (left) {
        payBookingsRequestFailure = left;
        payBookingsRequestStatus = PayBookingsRequestStatus.error;
        update();
      },
      (right) async {
        if (right.code == "1") {
          payBookingsRequestStatus = PayBookingsRequestStatus.success;
          update();
        } else {
          payBookingsRequestStatus = PayBookingsRequestStatus.success;
          update();
        }
      },
    );
  }

  Future<void> getPaymentMethodsData() async {
    getPaymentMethodsDataStatus = GetPaymentMethodsDataStatus.loading;
    update();

    (await getPaymentMethodsRepository.getPaymentMethods()).fold(
      (left) {
        getPaymentMethodsDataFailure = left;
        getPaymentMethodsDataStatus = GetPaymentMethodsDataStatus.error;
        update();
      },
      (right) async {
        if (right.code == "1") {
          getPaymentMethodsDataStatus = GetPaymentMethodsDataStatus.success;
          update();
          paymentMethodsList = right.data!;
        } else {
          paymentMethodsList = [];
          getPaymentMethodsDataStatus = GetPaymentMethodsDataStatus.success;
          update();
        }
      },
    );
  }

  bool getPaymentButtonCondition({String? status}) {
    if ((status != "cancelled") &&
        (status != "waiting-price") &&
        (status != "confirmed") &&
        (status != "refund-operation") &&
        (status != "change-operation")) {
      return true;
    } else {
      return false;
    }
  }

  bool getRefundButtonCondition({String? status}) {
    if ((status != "cancelled") &&
        (status != "waiting-price") &&
        (status != "waiting-confirm") &&
        (status != "refund-operation") &&
        (status != "change-operation")) {
      return true;
    } else {
      return false;
    }
  }

  bool getChangeButtonCondition({String? status, String? isRegularTrip}) {
    if ((status != "cancelled") &&
        (status != "waiting-price") &&
        (status != "waiting-confirm") &&
        (status != "refund-operation") &&
        (status != "change-operation") &&
        (isRegularTrip != "0")) {
      return true;
    } else {
      return false;
    }
  }

  bool getCancelButtonCondition({String? status}) {
    if ((status != "cancelled") &&
        (status != "refund-operation") &&
        (status != "change-operation")) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> acceptBookingConditions({String? bookingRequestId}) async {
    acceptBookingConditionsStatus = AcceptBookingConditionsStatus.loading;
    update();

    (await acceptBookingConditionsRepository.acceptConditions(
      bookingRequestId: bookingRequestId,
    )).fold(
      (left) {
        acceptBookingConditionsFailure = left;
        acceptBookingConditionsStatus = AcceptBookingConditionsStatus.error;
        update();
      },
      (right) async {
        if (right.code == "1") {
          acceptBookingConditionsStatus = AcceptBookingConditionsStatus.success;
          update();
          await getBookingsRequestsData();
        } else {
          acceptBookingConditionsStatus = AcceptBookingConditionsStatus.error;
          update();
        }
      },
    );
  }

  Future<void> addPassportsToBookingRequest({String? bookingRequestId}) async {
    addPassportsStatus = AddPassportsStatus.loading;
    update();
    final hasScannedPassports =
        passports.isNotEmpty &&
        !passports.every(
          (p) => p.fileUrl.isNotEmpty && p.passportNumber.isEmpty,
        );
    final hasBackendFilePassports =
        passports.isNotEmpty &&
        passports.every(
          (p) => p.fileUrl.isNotEmpty && p.passportNumber.isEmpty,
        );
    if (hasScannedPassports && passportFiles.isEmpty) {
      (await addPassportsRepository.addPassports(
        bookingRequestId: bookingRequestId,
        passports: passports,
      )).fold(
        (left) {
          addPassportsFailure = left;
          addPassportsStatus = AddPassportsStatus.error;
          update();
        },
        (right) async {
          if (right.code == "1") {
            addPassportsStatus = AddPassportsStatus.success;
            update();
            await getBookingsRequestsData();
          } else {
            addPassportsStatus = AddPassportsStatus.error;
            update();
          }
        },
      );
    } else if (passportFiles.isNotEmpty) {
      (await addPassportsRepository.uploadPassportFiles(
        bookingRequestId: bookingRequestId,
        passportFiles: passportFiles,
      )).fold(
        (left) {
          addPassportsFailure = left;
          addPassportsStatus = AddPassportsStatus.error;
          update();
        },
        (right) async {
          if (right.code == "1") {
            addPassportsStatus = AddPassportsStatus.success;
            update();
            await getBookingsRequestsData();
          } else {
            addPassportsStatus = AddPassportsStatus.error;
            update();
          }
        },
      );
    } else if (hasBackendFilePassports && passportFiles.isEmpty) {
      addPassportsStatus = AddPassportsStatus.success;
      update();
      await getBookingsRequestsData();
    } else {
      addPassportsStatus = AddPassportsStatus.error;
      update();
    }
  }
}
