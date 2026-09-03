import 'package:get/get.dart';

import '../controllers/account_waiting_controller.dart';

class AccountWaitingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountWaitingController>(
      () => AccountWaitingController(),
    );
  }
}
