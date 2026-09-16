import 'package:get/get.dart';

import '../controllers/my_trips_agenda_controller.dart';

class MyTripsAgendaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyTripsAgendaController>(() => MyTripsAgendaController());
  }
}
