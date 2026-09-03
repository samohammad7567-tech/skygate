import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:mrz_scanner_plus/mrz_scanner_plus.dart';
import 'package:skygate/tourism/modules/my-bookings-requests/controllers/my_bookings_requests_controller.dart';
import 'package:skygate/tourism/modules/my-bookings-requests/models/passport_model.dart';

import 'package:toastification/toastification.dart';
import 'package:audioplayers/audioplayers.dart';

class PassportScannerView extends StatefulWidget {
  const PassportScannerView({super.key});

  @override
  State<PassportScannerView> createState() => _PassportScannerViewState();
}

class _PassportScannerViewState extends State<PassportScannerView> {
  late MyBookingsRequestsController registerController;
  final player = AudioPlayer();

  void _onMRZDetected(String imagePath, MRZResult mrzResult) async {
    DateTime passportExpiry = mrzResult.expiryDate;
    bool isPassportExpired =
        registerController.isExpiringWithinSixMonths(passportExpiry);
    if (isPassportExpired) {
      toastification.show(
        style: ToastificationStyle.fillColored,
        type: ToastificationType.info,
        title: const Text("تنبيه متعلق بجواز السفر"),
        description: const Text("إن جواز السفر لديك قد شارف على الانتهاء"),
        autoCloseDuration: const Duration(seconds: 5),
        context: context,
      );
    }

    log('MRZ Result: ${mrzResult.toJson()}');
    log('Image Path: $imagePath');
    registerController.fullNameController.text =
        "${mrzResult.givenNames} ${mrzResult.surnames}";
    registerController.nationalNumberController.text = mrzResult.personalNumber;
    registerController.dobController.text =
        registerController.formatDate(mrzResult.birthDate);
    registerController.passportNumberController.text = mrzResult.documentNumber;
    registerController.passportExpiryDateController.text =
        registerController.formatDate(mrzResult.expiryDate);
    registerController.nationalityController.text =
        mrzResult.nationalityCountryCode;
    registerController.selectedNationality = mrzResult.nationalityCountryCode;
    registerController.genderController.text = mrzResult.sex.name;
    registerController.selectedGender = mrzResult.sex.name;
    registerController.update();

    await player.play(AssetSource("sounds/beep.wav"));

    // Create passport model
    PassportModel newPassport = PassportModel(
      firstName: mrzResult.givenNames,
      lastName: mrzResult.surnames,
      nationalNumber: mrzResult.personalNumber,
      dateOfBirth: registerController.formatDate(mrzResult.birthDate),
      passportNumber: mrzResult.documentNumber,
      passportExpiryDate: registerController.formatDate(mrzResult.expiryDate),
      nationality: mrzResult.nationalityCountryCode,
      gender: mrzResult.sex.name,
    );

    // Try to add passport and check if it's a duplicate
    bool wasAdded = registerController.addPassport(newPassport);

    if (wasAdded) {
      toastification.show(
        style: ToastificationStyle.fillColored,
        type: ToastificationType.success,
        title: const Text("جواز السفر"),
        description: const Text("تم قراءة معلومات جواز السفر بنجاح."),
        autoCloseDuration: const Duration(seconds: 5),
        context: context,
      );
      Get.back();
    } else {
      toastification.show(
        style: ToastificationStyle.fillColored,
        type: ToastificationType.warning,
        title: const Text("جواز السفر"),
        description: const Text("هذا الجواز موجود مسبقاً في القائمة."),
        autoCloseDuration: const Duration(seconds: 5),
        context: context,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    registerController = Get.find<MyBookingsRequestsController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CameraView(
        mode: CameraMode.scan,
        onMRZDetected: _onMRZDetected,
      ),
    );
  }
}
