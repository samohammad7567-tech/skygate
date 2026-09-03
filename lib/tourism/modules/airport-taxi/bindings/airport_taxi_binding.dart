import 'package:get/get.dart';

import '../controllers/airport_taxi_controller.dart';

class AirportTaxiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AirportTaxiController>(
      () => AirportTaxiController(),
    );
  }
}
