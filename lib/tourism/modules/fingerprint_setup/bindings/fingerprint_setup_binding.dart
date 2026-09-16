import 'package:get/get.dart';

import '../controllers/fingerprint_setup_controller.dart';

class FingerprintSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FingerprintSetupController>(() => FingerprintSetupController());
  }
}
