import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/core/handler/auth_handler.dart';
import 'package:skygate/tourism/core/handler/error_handler.dart';
import 'package:skygate/tourism/core/utils/helpers/http_helper.dart';
import 'package:skygate/tourism/core/utils/helpers/local_storage_helper.dart';
import 'package:skygate/tourism/data/provider/api_provider/auth_provider.dart';
import 'package:skygate/tourism/data/provider/storage_provider/local_auth_provider.dart';
import 'package:skygate/tourism/data/service/repository/auth_reposiory.dart';
import 'package:skygate/tourism/data/service/repository/language_repository.dart';
import 'package:skygate/tourism/data/shared/shared_class.dart';
import 'package:skygate/tourism/firebase_options.dart';
import 'package:skygate/tourism/modules/database/user_classes_database_helper.dart';
import 'package:skygate/tourism/modules/language/language_controller.dart';
import 'package:skygate/tourism/modules/logout/controllers/logout_controller.dart';
import 'package:skygate/tourism/modules/main/controllers/main_controller.dart';
import 'package:skygate/tourism/modules/notifications/controllers/notifications_controller.dart';
import 'package:skygate/tourism/routes/app_pages.dart';

class TourismBootstrap {
  TourismBootstrap._();
  static Future<void>? _bootstrap;

  static bool get isInitialized => _bootstrap != null;

  static Future<void> ensureInitialized() {
    return _bootstrap ??= _initialize().catchError((Object error) {
      // Don't cache a failed boot: without this, every later tap would get the
      // same rejected future back and the module could never recover.
      _bootstrap = null;
      throw error;
    });
  }

  static String get entryRoute {
    final target = SharedClass.targetPage;
    if (target.isEmpty || target == Routes.SPLASH) return Routes.START_PAGE;
    return target;
  }

  static Future<void> _initialize() async {
    // Helpers and repositories the module resolves with `Get.find`.
    Get.put(LocalStorageHelper(), permanent: true);
    Get.put(UserClassesDatabaseHelper(), permanent: true);
    Get.put(HttpHelper(), permanent: true);
    Get.put(ErrorHandler()..listenForErrors(), permanent: true);
    Get.put(LanguageRepository(), permanent: true);
    Get.put(
      AuthRepository(
        apiProvider: ApiAuthProvider(),
        localAuthProvider: LocalAuthProvider(),
      ),
      permanent: true,
    );
    Get.put(LogoutController(), permanent: true);

    // The module keeps its own language flag; seed it from storage so it
    // agrees with the locale EasyLocalization already applied to the shell.
    await Get.put(LanguageController(), permanent: true).initLanguage();

    // Resolves the stored session — must finish before [entryRoute] is read.
    await Get.put(MainController(), permanent: true).ensureInitialized();

    await _initializePushMessaging();

    // Registered last: it redirects on every auth-state change, so it must not
    // be listening before the module owns the screen.
    Get.put(AuthHandler()..listenForAuthState(), permanent: true);
  }

  static Future<void> _initializePushMessaging() async {
    final notifications = Get.put(NotificationsController(), permanent: true);
    try {
      await _initializeFirebase();
      await notifications.flutterLocalNotificationsInitiate();
      await notifications.getFCMToken();
    } catch (error, stackTrace) {
      log(
        'Push messaging unavailable — continuing without it: $error',
        name: 'TourismBootstrap',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  static Future<void> _initializeFirebase() async {
    if (Firebase.apps.isNotEmpty) return;
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
