import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import "package:get/get.dart";
import 'package:permission_handler/permission_handler.dart';
import 'package:skygate/tourism/core/theme/app_colors.dart';
import 'package:skygate/tourism/global_widgets/loading_widget.dart';
import 'package:skygate/tourism/modules/signup/views/camera_page.dart';
import '../controllers/signup_controller.dart';

class PassportScanner extends GetView<SignupController> {
  PassportScanner({super.key});

  final registerController = Get.find<SignupController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: SvgPicture.asset(
          "assets/images/svgs/big_logo.svg",
          width: 104.0.w,
        ),
        centerTitle: true,
      ),
      body: GetBuilder<SignupController>(
        init: registerController,
        builder: (registerController) {
          if (registerController.cameraPermissionStatus ==
              CameraPermissionStatus.loading) {
            return LoadingWidget(color: AppColors.blue, size: 20.0);
          } else if (registerController.cameraPermissionStatus ==
              CameraPermissionStatus.denied) {
            openAppSettings();
            return Container();
          } else {
            return CameraScanPage();
          }
        },
      ),
    );
  }
}
