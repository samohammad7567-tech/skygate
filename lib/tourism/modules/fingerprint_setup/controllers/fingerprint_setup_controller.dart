import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:skygate/tourism/core/utils/helpers/local_storage_helper.dart';
import 'package:skygate/tourism/core/utils/helpers/parse_helpers/failure_parser.dart';
import 'package:skygate/tourism/data/shared/shared_class.dart';
import 'package:skygate/tourism/modules/fingerprint_setup/repository/fingerprint_setup_repository.dart';
import 'package:skygate/tourism/routes/app_pages.dart';
import 'package:toastification/toastification.dart';

class FingerprintSetupController extends GetxController {
  final LocalAuthentication localAuth = LocalAuthentication();
  bool canCheckBiometrics = false;
  bool biometricsEnabled = false;
  List<BiometricType> availableBiometrics = [];
  bool isAuthenticating = false;
  late LocalStorageHelper localStorageHelper;

  late FingerprintSetupRepository fingerprintSetupRepository;

  @override
  void onInit() {
    super.onInit();
    localStorageHelper = Get.find<LocalStorageHelper>();
    fingerprintSetupRepository = FingerprintSetupRepository();
    checkBiometrics();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }


  Future<void> checkBiometrics() async {
    try {
      canCheckBiometrics = await localAuth.canCheckBiometrics;
      availableBiometrics = await localAuth.getAvailableBiometrics();
      update();
    } catch (e) {
      debugPrint("Error checking biometrics: $e");
    }
  }

  Future<void> authenticate({BuildContext? context}) async {
    try {
      isAuthenticating = true;
      update();

      bool authenticated = await localAuth.authenticate(
        localizedReason: 'يرجى استخدام بصمة الأصبع للمصادقة.',
        options: const AuthenticationOptions(
          biometricOnly: true, // Only biometric, no device credentials
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
      if (authenticated) {
        final biometricsKey = secureRandomAlphanumeric16();
        SharedClass.biometricsKey = biometricsKey;
        SharedClass.biometricsEnabled = "true";
        await biometricsEnable(context: context);
        if(biometricsEnabled) {
          await localStorageHelper.store(path: "biometricsKey", data: SharedClass.biometricsKey);
          await localStorageHelper.store(path: "biometricsEnabled", data: SharedClass.biometricsEnabled);
          isAuthenticating = false;
          update();
          // Successful authentication - navigate to home or perform login
          Get.offAllNamed(Routes.HOME);
        }
      }
    } catch (e) {
      isAuthenticating = false;
      update();
      debugPrint("Authentication error: $e");
    }
  }


  Future<void> biometricsEnable({BuildContext? context}) async {
    (await fingerprintSetupRepository.fingerprintSetup())
        .fold((left) {
      String? error = FailureParser.mapFailureToString(failure: left, context: context!);
      biometricsEnabled = false;
      toastification.show(
        context: context,
        title: const Text("تفعيل الدخول بالبصمة"),
        description: Text(error),
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 8),
      );
    }, (right) async {
      if(right.code == "1") {
        biometricsEnabled = true;
        toastification.show(
          context: context,
          title: const Text("تفعيل الدخول بالبصمة"),
          description: Text(right.message!),
          type: ToastificationType.success,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 8),
        );
      } else {
        biometricsEnabled = false;
        toastification.show(
          context: context,
          title: const Text("تفعيل الدخول بالبصمة"),
          description: Text(right.message!),
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 8),
        );
      }
    });
  }

  String secureRandomAlphanumeric16() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random.secure();
    return String.fromCharCodes(
        Iterable.generate(
            16,
                (_) => chars.codeUnitAt(random.nextInt(chars.length))
        )
    );
  }

}
