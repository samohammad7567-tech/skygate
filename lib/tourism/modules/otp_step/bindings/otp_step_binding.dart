import 'package:get/get.dart';

import '../controllers/otp_step_controller.dart';

class OtpStepBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtpStepController>(() => OtpStepController());
  }
}
