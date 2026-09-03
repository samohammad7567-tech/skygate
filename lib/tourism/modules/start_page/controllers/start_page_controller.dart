import 'package:get/get.dart';
import 'package:skygate/tourism/routes/app_pages.dart';
import 'package:video_player/video_player.dart';

class StartPageController extends GetxController {

  final String videoUrl = "assets/videos/welcome.mp4";
  late VideoPlayerController videoController;

  @override
  void onInit() {
    super.onInit();
    videoController = VideoPlayerController.asset(videoUrl)
      ..initialize().then((_) {
        update();
        videoController.play(); // Auto-play the video
        videoController.setLooping(true);
        // Listen for video completion
        // videoController.addListener(checkVideoStatus);
      });
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

  void checkVideoStatus() {
    if (videoController.value.position >= videoController.value.duration) {
      // Video ended → Navigate to next screen
      Get.offAllNamed(Routes.WELCOME_LOGIN);
    }
  }

}
