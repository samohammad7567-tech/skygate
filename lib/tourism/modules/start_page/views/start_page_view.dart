import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/global_widgets/custom_button.dart';
import 'package:skygate/tourism/routes/app_pages.dart';
import 'package:video_player/video_player.dart';
import '../controllers/start_page_controller.dart';

class StartPageView extends GetView<StartPageController> {
  StartPageView({super.key});

  final startPageController = Get.find<StartPageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          GetBuilder<StartPageController>(
            init: startPageController,
            builder: (startPageController) {
              return AspectRatio(
                aspectRatio:
                    startPageController.videoController.value.aspectRatio,
                child: VideoPlayer(startPageController.videoController),
              );
            },
          ),
          PositionedDirectional(
            top: 105.0.h,
            child: SvgPicture.asset("assets/images/big-logo-white.svg"),
          ),
          PositionedDirectional(
            top: 517.0.h,
            child: Text(
              "مرحبا بك في تجربة سفر ذكية",
              style: context.textTheme.titleSmall!.copyWith(
                fontSize: 24.0,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
          PositionedDirectional(
            top: 586.0.h,
            child: SizedBox(
              width: 235.0.w,
              child: CustomButton(
                onTap: () {
                  Get.offAllNamed(Routes.SIGNIN);
                },
                btnColor: Colors.white,
                addShadow: false,
                child: Text(
                  "ابدأ الآن",
                  style: context.textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.w900,
                    fontFamily: "Inter",
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
