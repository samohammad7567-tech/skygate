import 'package:get/get.dart';

import '../controllers/promotion_details_controller.dart';

class PromotionDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PromotionDetailsController>(
      () => PromotionDetailsController(),
    );
  }
}
