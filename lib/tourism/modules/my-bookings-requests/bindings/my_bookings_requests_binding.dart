import 'package:get/get.dart';

import '../controllers/my_bookings_requests_controller.dart';

class MyBookingsRequestsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyBookingsRequestsController>(
      () => MyBookingsRequestsController(),
    );
  }
}
