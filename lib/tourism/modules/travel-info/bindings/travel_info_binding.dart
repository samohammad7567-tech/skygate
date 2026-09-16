import 'package:get/get.dart';

import '../controllers/travel_info_controller.dart';

class TravelInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TravelInfoController>(() => TravelInfoController());
  }
}
