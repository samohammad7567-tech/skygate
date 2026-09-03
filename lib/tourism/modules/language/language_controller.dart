import 'dart:developer';
import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:skygate/tourism/core/utils/failures/failures.dart';
import 'package:skygate/tourism/core/utils/helpers/local_storage_helper.dart';
import 'package:skygate/tourism/data/shared/shared_class.dart';
import 'package:skygate/tourism/modules/language/language_repository.dart';

class LanguageController extends GetxController{
  bool loading=false;
  LocalStorageHelper localStorageHelper = LocalStorageHelper();
  // just give init value in case of first time app run.
  // String appLanguage = Get.deviceLocale!.languageCode;
  String appLanguage = "ar";

  late LanguageRepository languageRepository;

  @override
  void onInit() async {
    super.onInit();
    languageRepository = LanguageRepository();
    await initLanguage();
  }

  Future<void> initLanguage() async {
    final storedLang = await readStoredLangdata();
    if(storedLang != "") {
      appLanguage = storedLang;
    }
    log("From LanguageController appLanguage: ${appLanguage}");
  }

  Future<String> readStoredLangdata() async {
    try {
      final data = await localStorageHelper.read(path: "appLang");
      return data;
    } on Failure catch(e) {
      return "";
    }
  }

  Future<void> changeAppLang({required BuildContext ctx}) async {
    if (appLanguage == "en") {
      await Get.updateLocale(const Locale('ar', 'AR'));
      appLanguage = "ar";
      ctx.setLocale(Locale(appLanguage));
      final result = await localStorageHelper.store(path: "appLang", data: "ar");
      log("***********FROM CHANGE APP LANG***********");
      log("*****appLang =  ${appLanguage}");
      log("********Language Store Function returned  ${result}");
      await updateUserLangBackend();
      update();
      return;
    }

    if (appLanguage == 'ar') {
      await Get.updateLocale(Locale('en', 'US'));
      appLanguage = "en";
      ctx.setLocale(Locale(appLanguage));
      final result = await localStorageHelper.store(path: "appLang", data: "en");
      log("***********FROM CHANGE APP LANG***********");
      log("*****appLang =  ${appLanguage}");
      log("********Language Store Function returned  ${result}");
      await updateUserLangBackend();
      update();
      return;
    }
  }

  Future<void> updateUserLangBackend() async {
    (await languageRepository.updateUserLang(
        user_id: SharedClass.userId,
        lang: appLanguage,
    )).fold((left) async {
        await updateUserLangBackend();
    }, (right) {
        if(right.code == "1") {
          log("User Language update successfully.");
        } else {
          log(right.message!);
        }
    });
  }
}