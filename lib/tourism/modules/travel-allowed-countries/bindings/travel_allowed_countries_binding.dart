import 'package:get/get.dart';

import '../controllers/travel_allowed_countries_controller.dart';

class TravelAllowedCountriesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TravelAllowedCountriesController>(
      () => TravelAllowedCountriesController(),
    );
  }
}
