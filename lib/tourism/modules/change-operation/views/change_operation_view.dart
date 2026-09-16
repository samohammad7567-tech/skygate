import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/core/theme/app_colors.dart';
import 'package:skygate/tourism/global_widgets/custom_button.dart';
import 'package:skygate/tourism/global_widgets/error_panel.dart';
import 'package:skygate/tourism/global_widgets/loading_widget.dart';
import 'package:skygate/tourism/modules/change-operation/controllers/change_operation_controller.dart';
import 'package:skygate/tourism/modules/change-operation/views/choose_departure_trip_view.dart';
import 'package:skygate/tourism/modules/change-operation/views/choose_return_trip_view.dart';

class ChangeOperationView extends GetView<ChangeOperationController> {
  ChangeOperationView({super.key});

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
          "assets/images/svgs/big_logo.svg",
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
            return LoadingWidget(color: AppColors.blue, size: 50.0);
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
                  image: AssetImage("assets/images/pngs/seko.png"),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
                  Text(
                    "طلب تعديل",
                    style: context.textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 30.0,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 71.0.h)),
                  SizedBox(
                    width: 284.0.w,
                    child: CustomButton(
                      onTap: () {
                        changeOperationController.numberOfStages = 1;
                        changeOperationController.changeType =
                            "تعديل مقطع الذهاب";
                        Get.to(() => ChooseDepartureTripView());
                      },
                      btnColor: Colors.white,
                      padding: 20.0.r,
                      addShadow: true,
                      child: Text(
                        "تعديل مقطع الذهاب",
                        style: context.textTheme.titleMedium!.copyWith(
                          color: AppColors.blue,
                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
                  Visibility(
                    visible:
                        (changeOperationController.bookingRequest.is_one_way ==
                        "0"),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 284.0.w,
                          child: CustomButton(
                            onTap: () {
                              changeOperationController.numberOfStages = 1;
                              changeOperationController.changeType =
                                  " تعديل مقطع الإياب";
                              Get.to(() => ChooseReturnTripView());
                            },
                            btnColor: Colors.white,
                            padding: 20.0.r,
                            addShadow: true,
                            child: Text(
                              "تعديل مقطع الإياب",
                              style: context.textTheme.titleMedium!.copyWith(
                                color: AppColors.blue,
                              ),
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
                        SizedBox(
                          width: 284.0.w,
                          child: CustomButton(
                            onTap: () {
                              changeOperationController.numberOfStages = 2;
                              changeOperationController.changeType =
                                  "تعديل مقطع الذهاب والإياب";
                              Get.to(() => ChooseDepartureTripView());
                            },
                            btnColor: Colors.white,
                            padding: 20.0.r,
                            addShadow: true,
                            child: Text(
                              "تعديل مقطع الذهاب والإياب",
                              style: context.textTheme.titleMedium!.copyWith(
                                color: AppColors.blue,
                              ),
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 284.0.w,
                    child: CustomButton(
                      onTap: () {
                        Get.back();
                      },
                      btnColor: AppColors.blue,
                      padding: 20.0.r,
                      addShadow: true,
                      child: Text(
                        "إلغاء",
                        style: context.textTheme.titleMedium!.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
