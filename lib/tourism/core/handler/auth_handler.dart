import 'package:get/get.dart';
import '../../data/service/repository/auth_reposiory.dart';
import '../../routes/app_pages.dart';

class AuthHandler {
  void listenForAuthState() {
    AuthRepository authRepository = Get.find<AuthRepository>();
    authRepository.getAuthState().listen((authState) {
      switch (authState) {
        case AuthenticationState.unknown:
          break;
        case AuthenticationState.unauthenticated:
          Get.offAllNamed(Routes.SIGNIN);
          break;
        case AuthenticationState.authenticated:
          Get.offAllNamed(Routes.HOME);
          break;
        case AuthenticationState.firstTime:
          Get.offAllNamed(Routes.WELCOME_LOGIN);
          break;
      }
    });
  }
}
