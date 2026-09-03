import 'package:get/get.dart';
import '../../../data/service/repository/auth_reposiory.dart';

class HomeController extends GetxController {
  late IUserRepository userRepository;

  @override
  void onInit() {
    userRepository = Get.find<AuthRepository>() as IUserRepository;

    super.onInit();
  }


  @override
  void onClose() {}
}

class IUserRepository {
}
