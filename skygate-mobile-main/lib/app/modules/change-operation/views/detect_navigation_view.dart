import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sky_gate/app/core/theme/app_colors.dart';
import 'package:sky_gate/app/global_widgets/error_panel.dart';
import 'package:sky_gate/app/global_widgets/loading_widget.dart';
import 'package:sky_gate/app/modules/change-operation/controllers/change_operation_controller.dart';

class DetectNavigationView extends GetView<ChangeOperationController> {
  DetectNavigationView({super.key});

  final changeOperationController = Get.find<ChangeOperationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: false,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        centerTitle: true,
        elevation: 0.0,
        title: SvgPicture.asset(
          "assets/images/big-logo.svg",
          width: 105.0.w,
          height: 47.0.h,
        ),
      ),
      body: GetBuilder<ChangeOperationController>(
        init: changeOperationController,
        builder: (changeOperationController) {
          if (changeOperationController.getUserStatus ==
                  GetUserStatus.initial ||
              changeOperationController.getUserStatus ==
                  GetUserStatus.loading) {
            return LoadingWidget(
              color: AppColors.blue,
              size: 50.0,
            );
          } else if (changeOperationController.getUserStatus ==
              GetUserStatus.error) {
            return ErrorPanel(
              failure: changeOperationController.getUserFailure,
              onTryAgain: () async {
                await changeOperationController.onInit();
              },
            );
          } else {
            return Container(
              width: 1 * 1.sw,
              height: 1 * 1.sh,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/seko.png"),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                children: [],
              ),
            );
          }
        },
      ),
    );
  }
}
