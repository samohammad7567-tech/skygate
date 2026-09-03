import 'package:get/get.dart';

import '../controllers/refund_operation_controller.dart';

class RefundOperationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RefundOperationController>(
      () => RefundOperationController(),
    );
  }
}
