import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/core/utils/failures/base_failure.dart';
import 'package:skygate/tourism/core/utils/failures/failures.dart';
import 'package:skygate/tourism/core/utils/helpers/local_storage_helper.dart';
import 'package:skygate/tourism/core/utils/helpers/parse_helpers/failure_parser.dart';
import 'package:skygate/tourism/data/shared/shared_class.dart';
import 'package:skygate/tourism/modules/database/user_classes_database_helper.dart';
import 'package:skygate/tourism/modules/signin/repository/signin_repository.dart';
import 'package:skygate/tourism/routes/app_pages.dart';
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

    final result = await signInRepository.signIn(
        mobile: mobileNum!, password: passwordController.text);

    await result.fold((left) async {
      signInFailure = left;
      String? error =
          FailureParser.mapFailureToString(failure: left, context: context!);
      signInStatus = SignInStatus.error;
      update();
      _showToast(context: context, message: error, isError: true);
    }, (right) async {
      // Any code other than "1" (e.g. -15000 "no account / wrong mobile")
      // comes back with a null data payload, so it must never be unwrapped.
      if (right.code != "1" || right.data == null) {
        signInFailure = CustomFailure(message: right.message ?? "");
        signInStatus = SignInStatus.error;
        update();
        _showToast(
            context: context, message: right.message ?? "", isError: true);
        return;
      }

      await localStorageHelper.storeUserData(userModel: right.data!);

      // The fcm token update must not block the login itself.
      (await signInRepository.updateFCMToken(
              user_id: SharedClass.userId, fcmToken: SharedClass.fcmToken))
          .fold((left) {
        signInFailure = left;
      }, (_) {});

      signInStatus = SignInStatus.success;
      update();
      _showToast(
          context: context, message: right.message ?? "", isError: false);
      Get.offAllNamed(Routes.HOME);
    });
  }

  void _showToast(
      {BuildContext? context, required String message, required bool isError}) {
    if (context == null) return;
    toastification.show(
      context: context,
      title: const Text("طلب تسجيل الدخول"),
      description: Text(message),
      type: isError ? ToastificationType.error : ToastificationType.success,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 8),
    );
  }

  Future<void> updateUserFCMToken() async {}
}
