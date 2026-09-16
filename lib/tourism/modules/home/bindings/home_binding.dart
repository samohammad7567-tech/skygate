import 'package:get/get.dart';
import 'package:skygate/tourism/modules/account/controllers/account_controller.dart';
import 'package:skygate/tourism/modules/home-tab/controllers/home_tab_controller.dart';
import 'package:skygate/tourism/modules/my-trips/controllers/my_trips_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());

    Get.lazyPut<AccountController>(() => AccountController());
    Get.lazyPut<HomeTabController>(() => HomeTabController());
    Get.lazyPut<MyTripsController>(() => MyTripsController());
  }
}
