import 'package:get/get.dart';
import 'package:sky_gate/app/core/utils/helpers/http_helper.dart';
import 'package:sky_gate/app/core/utils/helpers/local_storage_helper.dart';
import 'package:sky_gate/app/modules/database/user_classes_database_helper.dart';
import 'package:sky_gate/app/modules/language/language_controller.dart';
import 'package:sky_gate/app/modules/notifications/controllers/notifications_controller.dart';
import 'modules/logout/controllers/logout_controller.dart';

class RootBinding implements Bindings {
  /// TODO: you can put here all the general controllers that you need them to be used by the whole app.
  @override
  void dependencies() {
    Get.put(LogoutController(), permanent: true);
    Get.put(NotificationsController(), permanent: true);
    Get.put(HttpHelper(), permanent: true);
    Get.put(LocalStorageHelper(), permanent: true);
    Get.put(UserClassesDatabaseHelper(), permanent: true);
    Get.put(LanguageController(), permanent: true);
  }
}
