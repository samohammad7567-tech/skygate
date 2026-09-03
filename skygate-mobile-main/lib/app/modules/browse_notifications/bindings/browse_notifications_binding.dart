import 'package:get/get.dart';

import '../controllers/browse_notifications_controller.dart';

class BrowseNotificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BrowseNotificationsController>(
      () => BrowseNotificationsController(),
    );
  }
}
