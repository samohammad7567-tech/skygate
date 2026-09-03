import 'package:get/get.dart';
import 'package:skygate/tourism/data/shared/shared_class.dart';

import '../../../routes/app_pages.dart';

class LogoutController extends GetxController {

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

  Future<void> firebaseLogout() async {
    SharedClass.userId = '';
    SharedClass.secretCode = '';
    SharedClass.lang = '1';
    SharedClass.apiToken = "";
    SharedClass.loggedUsername = "";
    SharedClass.loggedUserEmail = "";
    SharedClass.loggedUserLocation = "";
    SharedClass.loggedUserMobile = "";
    SharedClass.wallet = "0";
    Get.offAllNamed(Routes.WELCOME_LOGIN);
  }
}
