import 'package:get/get.dart';

import '../controllers/fingerprint_login_controller.dart';

class FingerprintLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FingerprintLoginController>(() => FingerprintLoginController());
  }
}
