import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sky_gate/app/core/utils/failures/base_failure.dart';
import 'package:sky_gate/app/core/utils/failures/failures.dart';
import 'package:sky_gate/app/core/utils/helpers/local_storage_helper.dart';
import 'package:sky_gate/app/core/utils/helpers/parse_helpers/failure_parser.dart';
import 'package:sky_gate/app/data/shared/shared_class.dart';
import 'package:sky_gate/app/modules/database/user_classes_database_helper.dart';
import 'package:sky_gate/app/modules/signin/repository/signin_repository.dart';
import 'package:sky_gate/app/routes/app_pages.dart';
import 'package:toastification/toastification.dart';


enum SignInStatus {initial, error, loading, success}

class SigninController extends GetxController {
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? mobileNum = "";

  RxBool? isPassword = true.obs;
  RxBool? isLoading = false.obs;

  SignInStatus signInStatus = SignInStatus.initial;
  Failure signInFailure = const CustomFailure(message: "Wrong Data !");

  late SignInRepository signInRepository;
  late LocalStorageHelper localStorageHelper;
  late UserClassesDatabaseHelper userClassDatabaseHelper;


  @override
  void onInit() {
    super.onInit();
    signInRepository = SignInRepository();
    localStorageHelper = Get.find<LocalStorageHelper>();
    userClassDatabaseHelper = Get.find<UserClassesDatabaseHelper>();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> signIn({BuildContext? context}) async {
    signInStatus = SignInStatus.loading;
    update();
    bool signInSuccess = false;

    (await signInRepository.signIn(mobile: mobileNum!, password: passwordController.text))
    .fold((left) {
      signInFailure = left;
      String? error = FailureParser.mapFailureToString(failure: left, context: context!);
      signInStatus = SignInStatus.error;
      update();
      signInSuccess = false;
      toastification.show(
        context: context,
        title: const Text("طلب تسجيل الدخول"),
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
          signInFailure = left;
          signInStatus = SignInStatus.error;
          update;
        }, (right) {
            if(right.code == "1") {
              signInSuccess = true;
              signInStatus = SignInStatus.success;
              update();
            }
        });
      } else {
        signInSuccess = false;
        signInFailure = CustomFailure(message: right.message!);
        signInStatus = SignInStatus.error;
        update();
        toastification.show(
          context: context,
          title: const Text("طلب تسجيل الدخول"),
          description: Text(right.message!),
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 8),
        );
      }

      if (signInSuccess == true) {
        signInStatus = SignInStatus.success;
        update();
        toastification.show(
          context: context,
          title: const Text("طلب تسجيل الدخول"),
          description: Text(right.message!),
          type: ToastificationType.success,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 8),
        );
        Get.offAllNamed(Routes.HOME);
      } else {
        signInStatus = SignInStatus.error;
        update();
      }
    });
  }

  Future<void> updateUserFCMToken() async {}
}
