import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/core/theme/app_colors.dart';
import 'package:skygate/tourism/global_widgets/loading_widget.dart';
import 'package:video_player/video_player.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  final splashController = Get.find<SplashController>();

  SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      init: splashController,
      builder: (splashController) {
        return splashController.videoController.value.isInitialized
            ? AspectRatio(
                aspectRatio: splashController.videoController.value.aspectRatio,
                child: VideoPlayer(splashController.videoController),
              )
            : Container(
                color: Colors.white,
                child: Center(
                  child: LoadingWidget(color: AppColors.blue, size: 40.0),
                ),
              );
      },
    );
  }
}
