import 'package:get/get.dart';
import 'package:skygate/tourism/core/utils/helpers/local_storage_helper.dart';
import 'package:skygate/tourism/data/shared/shared_class.dart';
import 'package:skygate/tourism/modules/database/user_classes_database_helper.dart';
import 'package:skygate/tourism/routes/app_pages.dart';

class BrowseNotificationsController extends GetxController {

  final localStorageHelper = Get.find<LocalStorageHelper>();
  final userClassDatabaseHelper = UserClassesDatabaseHelper();

  @override
  void onInit() {
    super.onInit();
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
    SharedClass.userId = "";
    SharedClass.loggedUserMobile = "";
    SharedClass.loggedUserEmail = "";
    SharedClass.loggedUsername = "";
    SharedClass.apiToken = "";

    await localStorageHelper.delete(path: "userKey");
    await localStorageHelper.delete(path: "userId");
    await localStorageHelper.delete(path: "mobile");
    await localStorageHelper.delete(path: "email");
    await localStorageHelper.delete(path: "fullName");
    await localStorageHelper.delete(path: "accountType");
    await localStorageHelper.delete(path: "relatedSchool");

    Get.offAllNamed(Routes.SPLASH);
  }
}
