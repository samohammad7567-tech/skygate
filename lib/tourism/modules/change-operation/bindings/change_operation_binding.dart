import 'package:get/get.dart';

import '../controllers/change_operation_controller.dart';

class ChangeOperationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChangeOperationController>(() => ChangeOperationController());
  }
}
