import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sky_gate/app/core/utils/helpers/local_storage_helper.dart';
import 'package:sky_gate/app/core/utils/helpers/parse_helpers/failure_parser.dart';
import 'package:sky_gate/app/modules/account/repository/account_repository.dart';
import 'package:sky_gate/app/modules/database/user_classes_database_helper.dart';
import 'package:sky_gate/app/routes/app_pages.dart';
import 'package:toastification/toastification.dart';


class AccountController extends GetxController {
  final localStorageHelper = Get.find<LocalStorageHelper>();
  late UserClassesDatabaseHelper userClassDatabaseHelper;
  late AccountRepository accountRepository;

  RxBool? logoutLoading = false.obs;
  RxBool? deleteAccountLoading = false.obs;


  @override
  void onInit() async {
    super.onInit();
    userClassDatabaseHelper = Get.find<UserClassesDatabaseHelper>();
    accountRepository = AccountRepository();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> logoutUser() async {
    logoutLoading!.value = true;
    update();

    (await accountRepository.logoutUser())
        .fold((left) {
      logoutLoading!.value = false;
      update();
    }, (right) async {
      if(right.code == "1") {
        await localStorageHelper.deleteUserData();
        logoutLoading!.value = false;
        update();
        Get.offAllNamed(Routes.SPLASH);

      } else if (right.code == "-15000") {
        logoutLoading!.value = false;
        update();
      } else {
        logoutLoading!.value = false;
        update();
      }
    });
  }

  Future<void> deleteUserProfile({BuildContext? context}) async {
    deleteAccountLoading!.value = true;
    update();

    (await accountRepository.deleteUserProfile())
    .fold((left) {
      deleteAccountLoading!.value = false;
      update();
      String? error = FailureParser.mapFailureToString(failure: left, context: context!);
      toastification.show(
        context: context,
        title: const Text("طلب حذف الحساب"),
        description: Text(error),
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 8),
      );
    }, (right) async {
      if(right.code == "1") {
        await localStorageHelper.deleteUserData();
        deleteAccountLoading!.value = false;
        update();
        toastification.show(
          context: context,
          title: const Text("طلب حذف الحساب"),
          description: Text(right.message!),
          type: ToastificationType.success,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 8),
        );
      } else if (right.code == "-15000") {
        deleteAccountLoading!.value = false;
        update();
        toastification.show(
          context: context,
          title: const Text("طلب حذف الحساب"),
          description: Text(right.message!),
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 8),
        );
      } else {
        deleteAccountLoading!.value = false;
        update();
      }
    });
  }
}
