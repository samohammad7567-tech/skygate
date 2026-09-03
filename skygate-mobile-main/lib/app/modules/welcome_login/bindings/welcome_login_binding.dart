import 'package:get/get.dart';

import '../controllers/welcome_login_controller.dart';

class WelcomeLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WelcomeLoginController>(
      () => WelcomeLoginController(),
    );
  }
}
