import 'package:get/get.dart';

import '../controllers/customer_care_support_controller.dart';

class CustomerCareSupportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomerCareSupportController>(
      () => CustomerCareSupportController(),
    );
  }
}
