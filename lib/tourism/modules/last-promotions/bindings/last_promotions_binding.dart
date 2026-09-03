import 'package:get/get.dart';

import '../controllers/last_promotions_controller.dart';

class LastPromotionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LastPromotionsController>(
      () => LastPromotionsController(),
    );
  }
}
