import 'package:get/get.dart';
import 'package:skygate/tourism/modules/signup/controllers/signup_controller.dart';

import '../controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(
      () => SplashController(),
    );
    Get.lazyPut<SignupController>(
          () => SignupController(),
    );
  }
}
