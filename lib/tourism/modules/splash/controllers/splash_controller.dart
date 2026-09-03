import 'package:get/get.dart';
import 'package:skygate/tourism/data/shared/shared_class.dart';
import 'package:skygate/tourism/routes/app_pages.dart';
import '../../../core/handler/auth_handler.dart';
import '../../../core/handler/error_handler.dart';
import '../../../core/utils/helpers/http_helper.dart';
import '../../../core/utils/helpers/local_storage_helper.dart';
import '../../../data/provider/api_provider/auth_provider.dart';
import '../../../data/provider/storage_provider/local_auth_provider.dart';
import '../../../data/service/repository/auth_reposiory.dart';
import '../../../data/service/repository/language_repository.dart';
import 'package:video_player/video_player.dart';

class SplashController extends GetxController {
  final String videoUrl = "assets/videos/splash.mp4";
  late VideoPlayerController videoController;

  @override
  void onInit() {
    super.onInit();
    videoController = VideoPlayerController.asset(videoUrl)
      ..initialize().then((_) {
        update();
        videoController.play(); // Auto-play the video
        videoController.setLooping(false);
        // Listen for video completion
        videoController.addListener(checkVideoStatus);
      }); // Loop the video (optional)
    injectDependency();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    videoController.dispose();
    super.onClose();
  }

  void injectDependency() {
    Get.put(HttpHelper(), permanent: true);
    Get.put(ErrorHandler()..listenForErrors(), permanent: true);
    Get.put(LocalStorageHelper(), permanent: true);

    Get.put(LanguageRepository(), permanent: true);

    Get.put(
        AuthRepository(
            apiProvider: ApiAuthProvider(),
            localAuthProvider: LocalAuthProvider()),
        permanent: true);
    Get.put(AuthHandler()..listenForAuthState(), permanent: true);
  }

  void checkVideoStatus() {
    if (videoController.value.position >= videoController.value.duration) {
      // Video ended → Navigate to next screen
      if (SharedClass.targetPage == Routes.SPLASH) {
        Get.offAllNamed(Routes.START_PAGE);
      } else {
        Get.offAllNamed(SharedClass.targetPage);
      }
    }
  }
}
