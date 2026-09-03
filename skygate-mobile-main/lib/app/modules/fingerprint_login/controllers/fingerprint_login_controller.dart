import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sky_gate/app/core/utils/helpers/local_storage_helper.dart';
import 'package:sky_gate/app/core/utils/helpers/parse_helpers/failure_parser.dart';
import 'package:sky_gate/app/data/shared/shared_class.dart';
import 'package:sky_gate/app/modules/fingerprint_login/repository/fingerprint_login_repository.dart';
import 'package:sky_gate/app/modules/signin/repository/signin_repository.dart';
import 'package:sky_gate/app/routes/app_pages.dart';
import 'package:toastification/toastification.dart';

class FingerprintLoginController extends GetxController {
  final LocalAuthentication localAuth = LocalAuthentication();
  bool canCheckBiometrics = false;
  List<BiometricType> availableBiometrics = [];
  bool isAuthenticating = false;
  bool loginSuccess = false;
  late FingerprintLoginRepository fingerprintLoginRepository;
  late SignInRepository signInRepository;
  late LocalStorageHelper localStorageHelper;

  @override
  void onInit() {
    super.onInit();
    fingerprintLoginRepository = FingerprintLoginRepository();
    signInRepository = SignInRepository();
    localStorageHelper = Get.find<LocalStorageHelper>();
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
        await biometricsLogin(context: context);
      }
    } catch (e) {
      isAuthenticating = false;
      update();
      debugPrint("Authentication error: $e");
    }
  }
  
  Future<void> biometricsLogin({BuildContext? context}) async {
    (await fingerprintLoginRepository.fingerprintSignIn())
        .fold((left) {
      String? error = FailureParser.mapFailureToString(failure: left, context: context!);
      loginSuccess = false;
      isAuthenticating = false;
      update();
      toastification.show(
        context: context,
        title: const Text("تسجيل دخول بالبصمة"),
        description: Text(error),
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 8),
      );
    }, (right) async {
      if(right.code == "1") {
        await localStorageHelper.storeUserData(userModel: right.data!);
        (await signInRepository.updateFCMToken(user_id: SharedClass.userId, fcmToken: SharedClass.fcmToken))
            .fold((left) {
          loginSuccess = false;
          isAuthenticating = false;
          update();
        }, (right) {
          if(right.code == "1") {
            loginSuccess = true;
            isAuthenticating = false;
            update();
          }
        });
      } else {
        loginSuccess = false;
        isAuthenticating = false;
        update();
        toastification.show(
          context: context,
          title: const Text("تسجيل دخول بالبصمة"),
          description: Text(right.message!),
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 8),
        );
      }

      if (loginSuccess == true) {
        isAuthenticating = false;
        update();
        // Successful authentication - navigate to home or perform login
        Get.offAllNamed(Routes.HOME);
        toastification.show(
          context: Get.overlayContext,
          title: const Text("تسجيل دخول بالبصمة"),
          description: Text(right.message!),
          type: ToastificationType.success,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 8),
        );
      } else {
        loginSuccess = false;
      }
    });
  }
}
