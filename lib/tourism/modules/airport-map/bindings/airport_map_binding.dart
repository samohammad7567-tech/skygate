import 'package:get/get.dart';

import '../controllers/airport_map_controller.dart';

class AirportMapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AirportMapController>(
      () => AirportMapController(),
    );
  }
}
