import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:sky_gate/app/core/utils/helpers/http_helper.dart';
import 'package:sky_gate/app/core/utils/helpers/local_storage_helper.dart';
import 'package:sky_gate/app/modules/database/user_classes_database_helper.dart';
import 'package:sky_gate/app/modules/language/language_controller.dart';
import 'package:sky_gate/app/modules/main/controllers/main_controller.dart';
import 'package:sky_gate/app/modules/notifications/controllers/notifications_controller.dart';
import './app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await EasyLocalization.ensureInitialized();
  Get.put(LocalStorageHelper(), permanent: true);
  Get.put(UserClassesDatabaseHelper(), permanent: true);
  Get.put(HttpHelper(), permanent: true);
  final languageController = Get.put(LanguageController(), permanent: true);
  Get.put(MainController()..init(), permanent: true);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final notificationsController =
      Get.put(NotificationsController(), permanent: true);
  await notificationsController.flutterLocalNotificationsInitiate();
  await notificationsController.getFCMToken();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path:
          'assets/translations', // <-- change the path of the translation files
      fallbackLocale: const Locale('en'),
      startLocale: Locale(languageController.appLanguage),
      child: App(),
    ),
  );
}
