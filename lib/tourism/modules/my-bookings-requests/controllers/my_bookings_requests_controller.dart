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
  // Files mode: attached passport images / PDFs.
  // This list is mutually exclusive with [passports] when sending to backend.
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

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  bool addPassport(PassportModel passport) {
    // Prevent mixing scan mode with files mode.
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

    print("Adding passport: ${passport.passportNumber}");

    // Check if passport already exists by passport number
    bool isDuplicate = passports.any((existingPassport) =>
        existingPassport.passportNumber == passport.passportNumber);

    print("Is duplicate: $isDuplicate");
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

    // Check if passport has expired
    try {
      print("Parsing expiry date: ${passport.passportExpiryDate}");

      // Parse date from format "day/month/year" (e.g., "15/12/2025")
      List<String> dateParts = passport.passportExpiryDate.split('/');
      if (dateParts.length != 3) {
        throw FormatException('Invalid date format');
      }

      int day = int.parse(dateParts[0]);
      int month = int.parse(dateParts[1]);
      int year = int.parse(dateParts[2]);

      DateTime expiryDate = DateTime(year, month, day);
      DateTime now = DateTime.now();

      print("Expiry date: $expiryDate, Now: $now");

      // Check if passport has expired
      if (expiryDate.isBefore(now)) {
        print("Passport is expired");
        Get.snackbar(
          "خطأ",
          "جواز السفر ${passport.passportNumber} منتهي الصلاحية. لا يمكن إضافته.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
        return false; // Expired passport
      }

      // Check if passport expires within 6 months (warning)
      if (isExpiringWithinSixMonths(expiryDate)) {
        print("Passport expires within 6 months");
        Get.snackbar(
          "تحذير",
          "جواز السفر ${passport.passportNumber} سينتهي خلال 6 أشهر",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      print("Error parsing date: $e");
      Get.snackbar(
        "خطأ",
        "تاريخ انتهاء صلاحية جواز السفر ${passport.passportNumber} غير صحيح",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false; // Invalid date
    }

    // Add passport if all validations pass
    print("Adding passport to list");
    passports.add(passport);
    update();
    print("Passport added successfully");
    return true; // Successfully added
  }

  Future<void> removePassport(int index) async {
    if (index < 0 || index >= passports.length) return;

    final passport = passports[index];

    // If this is a backend file passport (has fileUrl), remove it via API
    if (passport.fileUrl.isNotEmpty) {
      // Remove by index from backend
      (await addPassportsRepository.removePassportFiles(
        bookingRequestId: selectedBookingRequest?.id.toString(),
        deletedIndices: [index],
      ))
          .fold((left) {
        // Show error message
        Get.snackbar(
          "خطأ",
          "فشل حذف ملف الجواز. يرجى المحاولة مرة أخرى.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }, (right) async {
        if (right.code == "1") {
          // Successfully removed from backend, now remove from local list
          passports.removeAt(index);
          update();

          // Refresh the bookings list to get updated data
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
      });
    } else {
      // Scanned passport - just remove from local list
      passports.removeAt(index);
      update();
    }
  }

  void clearPassports() {
    passports.clear();
    update();
  }

  /// Replace the list of attached passport files (images/PDFs).
  ///
  /// This is used for the "files mode". While [passportFiles] is not empty,
  /// the user should NOT add scanned passports to avoid mixing modes.
  void setPassportFiles(List<File> files) {
    passportFiles = files;
    update();
  }

  /// Append additional passport files to the existing list (multi-select).
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

    (await getBookingsRequestsRepository.getBookingsRequests()).fold((left) {
      getBookingsRequestsDataStatus = GetBookingsRequestsDataStatus.error;
      update();
    }, (right) async {
      if (right.code == "1") {
        bookingsRequestsList = right.data!;
        getBookingsRequestsDataStatus = GetBookingsRequestsDataStatus.success;
        update();
      } else {
        bookingsRequestsList = [];
        getBookingsRequestsDataStatus = GetBookingsRequestsDataStatus.success;
        update();
      }
    });
  }

  Future<void> cancelBookingRequest({String? bookingRequestID}) async {
    cancelBookingsRequestStatus = CancelBookingsRequestStatus.loading;
    update();

    (await cancelBookingRequestRepository.cancel(
            booking_request_id: bookingRequestID))
        .fold((left) {
      cancelBookingsRequestFailure = left;
      cancelBookingsRequestStatus = CancelBookingsRequestStatus.error;
      update();
    }, (right) async {
      if (right.code == "1") {
        cancelBookingsRequestStatus = CancelBookingsRequestStatus.success;
        update();
      } else {
        cancelBookingsRequestStatus = CancelBookingsRequestStatus.success;
        update();
      }
    });
  }

  Future<void> payBookingRequest() async {
    payBookingsRequestStatus = PayBookingsRequestStatus.loading;
    update();
    print("selectedPaymentMethod: $selectedPaymentMethod");
    (await payBookingRequestRepository.pay(
            payment_method: selectedPaymentMethod,
            bookingRequestID: selectedBookingRequestID.toString()))
        .fold((left) {
      payBookingsRequestFailure = left;
      payBookingsRequestStatus = PayBookingsRequestStatus.error;
      update();
    }, (right) async {
      if (right.code == "1") {
        payBookingsRequestStatus = PayBookingsRequestStatus.success;
        update();
      } else {
        payBookingsRequestStatus = PayBookingsRequestStatus.success;
        update();
      }
    });
  }

  Future<void> getPaymentMethodsData() async {
    getPaymentMethodsDataStatus = GetPaymentMethodsDataStatus.loading;
    update();

    (await getPaymentMethodsRepository.getPaymentMethods()).fold((left) {
      getPaymentMethodsDataFailure = left;
      getPaymentMethodsDataStatus = GetPaymentMethodsDataStatus.error;
      update();
    }, (right) async {
      if (right.code == "1") {
        getPaymentMethodsDataStatus = GetPaymentMethodsDataStatus.success;
        update();
        paymentMethodsList = right.data!;
      } else {
        paymentMethodsList = [];
        getPaymentMethodsDataStatus = GetPaymentMethodsDataStatus.success;
        update();
      }
    });
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
            bookingRequestId: bookingRequestId))
        .fold((left) {
      acceptBookingConditionsFailure = left;
      acceptBookingConditionsStatus = AcceptBookingConditionsStatus.error;
      update();
    }, (right) async {
      if (right.code == "1") {
        acceptBookingConditionsStatus = AcceptBookingConditionsStatus.success;
        update();
        // Refresh the bookings list to get updated data
        await getBookingsRequestsData();
      } else {
        acceptBookingConditionsStatus = AcceptBookingConditionsStatus.error;
        update();
      }
    });
  }

  Future<void> addPassportsToBookingRequest({String? bookingRequestId}) async {
    addPassportsStatus = AddPassportsStatus.loading;
    update();

    // Check if passports are scanned (have passportNumber) or backend files (only fileUrl)
    final hasScannedPassports = passports.isNotEmpty &&
        !passports.every((p) => p.fileUrl.isNotEmpty && p.passportNumber.isEmpty);
    final hasBackendFilePassports = passports.isNotEmpty &&
        passports.every((p) => p.fileUrl.isNotEmpty && p.passportNumber.isEmpty);

    // Decide which mode to use based on current state:
    // - JSON/scan mode: scanned passports (have passportNumber), no local files.
    // - Files mode: local files OR backend file passports + new local files.
    if (hasScannedPassports && passportFiles.isEmpty) {
      // Scanned passports mode - send JSON
      (await addPassportsRepository.addPassports(
              bookingRequestId: bookingRequestId, passports: passports))
          .fold((left) {
        addPassportsFailure = left;
        addPassportsStatus = AddPassportsStatus.error;
        update();
      }, (right) async {
        if (right.code == "1") {
          addPassportsStatus = AddPassportsStatus.success;
          update();

          // Refresh the bookings list to get updated data
          await getBookingsRequestsData();
        } else {
          addPassportsStatus = AddPassportsStatus.error;
          update();
        }
      });
    } else if (passportFiles.isNotEmpty) {
      // Files mode - upload local files (will merge with backend files if they exist)
      (await addPassportsRepository.uploadPassportFiles(
              bookingRequestId: bookingRequestId, passportFiles: passportFiles))
          .fold((left) {
        addPassportsFailure = left;
        addPassportsStatus = AddPassportsStatus.error;
        update();
      }, (right) async {
        if (right.code == "1") {
          addPassportsStatus = AddPassportsStatus.success;
          update();

          // Refresh the bookings list to get updated data
          await getBookingsRequestsData();
        } else {
          addPassportsStatus = AddPassportsStatus.error;
          update();
        }
      });
    } else if (hasBackendFilePassports && passportFiles.isEmpty) {
      // Only backend file passports, nothing new to upload
      // Passports are already on the server, so we can proceed without calling API
      addPassportsStatus = AddPassportsStatus.success;
      update();
      
      // Refresh the bookings list to get updated data
      await getBookingsRequestsData();
    } else {
      // Invalid state: both empty
      addPassportsStatus = AddPassportsStatus.error;
      update();
    }
  }
}
