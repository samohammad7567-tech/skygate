import 'dart:developer';
import 'package:get/get.dart';
import 'package:mrz_scanner_plus/mrz_scanner_plus.dart';
import 'package:flutter/material.dart';
import 'package:sky_gate/app/modules/signup/controllers/signup_controller.dart';
import 'package:toastification/toastification.dart';
import 'package:audioplayers/audioplayers.dart';

class CameraScanPage extends StatefulWidget {
  @override
  State<CameraScanPage> createState() => _CameraScanPageState();
}

class _CameraScanPageState extends State<CameraScanPage> {

  late SignupController registerController;
  final player = AudioPlayer();

  void _onMRZDetected(String imagePath, MRZResult mrzResult) async {
    DateTime passportExpiry = mrzResult.expiryDate;
    bool isPassportExpired = registerController.isExpiringWithinSixMonths(passportExpiry);
    if(isPassportExpired) {
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
    registerController.fullNameController.text = "${mrzResult.givenNames} ${mrzResult.surnames}";
    registerController.nationalNumberController.text = mrzResult.personalNumber;
    registerController.dobController.text = registerController.formatDate(mrzResult.birthDate);
    registerController.passportNumberController.text = mrzResult.documentNumber;
    registerController.passportExpiryDateController.text = registerController.formatDate(mrzResult.expiryDate);
    registerController.nationalityController.text = mrzResult.nationalityCountryCode;
    registerController.selectedNationality = mrzResult.nationalityCountryCode;
    registerController.genderController.text = mrzResult.sex.name;
    registerController.selectedGender = mrzResult.sex.name;
    registerController.update();

    await player.play(AssetSource("sounds/beep.wav"));
    
    toastification.show(
      style: ToastificationStyle.fillColored,
      type: ToastificationType.success,
      title: const Text("جواز السفر"),
      description: const Text("تم قراءة معلومات جواز السفر بنجاح."),
      autoCloseDuration: const Duration(seconds: 5),
      context: context,
    );

    Get.back();
  }

  @override
  void initState() {
    super.initState();
    registerController = Get.find<SignupController>();
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