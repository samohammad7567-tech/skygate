import 'package:get/get.dart';

import '../controllers/sales_support_controller.dart';

class SalesSupportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SalesSupportController>(() => SalesSupportController());
  }
}
