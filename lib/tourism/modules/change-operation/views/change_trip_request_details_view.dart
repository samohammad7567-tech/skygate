import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/core/theme/app_colors.dart';
import 'package:skygate/tourism/global_widgets/custom_button.dart';
import 'package:skygate/tourism/global_widgets/custom_white_outlined_button.dart';
import 'package:skygate/tourism/global_widgets/loading_widget.dart';
import 'package:skygate/tourism/modules/change-operation/controllers/change_operation_controller.dart';
import 'package:flutter/material.dart';
import 'package:skygate/tourism/modules/change-operation/views/booking_request_conditions_view.dart';
import 'package:skygate/tourism/routes/app_pages.dart';

class ChangeTripRequestDetailsView extends GetView<ChangeOperationController> {
  ChangeTripRequestDetailsView({super.key});

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
      body: Container(
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
            Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
            Container(
              width: 376.0.w,
              height: 300.0.h,
              padding: EdgeInsets.all(22.0.r),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0.r),
                ),
              ),
              child: Container(
                width: 332.0.w,
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0.w,
                  vertical: 15.0.h,
                ),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFFD9D9D9)),
                    borderRadius: BorderRadius.circular(10.0.r),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'اسم المسافر',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF767680),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            height: 1.38,
                          ),
                        ),
                        Text(
                          '${changeOperationController.userModel.full_name}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF22509E),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            height: 1.38,
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Color(0xFFD9D9D9), thickness: 1.5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'تاريخ تعديل مقطع الذهاب',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF767680),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            height: 1.38,
                          ),
                        ),
                        Text(
                          '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF22509E),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            height: 1.38,
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Color(0xFFD9D9D9), thickness: 1.5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'توقيت تعديل مقطع الذهاب',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF767680),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            height: 1.38,
                          ),
                        ),
                        Text(
                          '${DateTime.now().hour}:${DateTime.now().minute}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF22509E),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            height: 1.38,
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Color(0xFFD9D9D9), thickness: 1.5),
                    Visibility(
                      visible: (changeOperationController.numberOfStages! > 1),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'تاريخ تعديل مقطع الإياب',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF767680),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  height: 1.38,
                                ),
                              ),
                              Text(
                                '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF22509E),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  height: 1.38,
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            color: Color(0xFFD9D9D9),
                            thickness: 1.5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'توقيت تعديل مقطع الإياب',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF767680),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  height: 1.38,
                                ),
                              ),
                              Text(
                                '${DateTime.now().hour}:${DateTime.now().minute}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF22509E),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  height: 1.38,
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            color: Color(0xFFD9D9D9),
                            thickness: 1.5,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 15.0.h)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.0.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 150.0.w,
                    child: CustomButton(
                      onTap: () async {
                        if (changeOperationController.isConditionsAccepted ==
                            true) {
                          await changeOperationController.submitChangeRequest(
                            context: context,
                          );
                        }
                      },
                      btnColor: AppColors.blue,
                      addShadow: false,
                      borderRadius: 30.0.r,
                      padding: 10.0.r,
                      child: GetBuilder<ChangeOperationController>(
                        init: changeOperationController,
                        builder: (changeOperationController) {
                          if (changeOperationController
                                  .submitChangeRequestStatus ==
                              SubmitChangeRequestStatus.loading) {
                            return LoadingWidget(
                              size: 25.0,
                              color: Colors.white,
                            );
                          } else {
                            return Text(
                              "متابعة",
                              style: context.textTheme.titleMedium!.copyWith(
                                color: Colors.white,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 150.0.w,
                    child: CustomWhiteOutlinedButton(
                      onTap: () {
                        Get.offAllNamed(Routes.HOME);
                      },
                      addShadow: false,
                      borderColor: AppColors.blue,
                      child: Text(
                        "إلغاء",
                        style: context.textTheme.titleMedium!.copyWith(
                          color: AppColors.blue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 15.0.h)),
            SizedBox(
              width: 200.0.w,
              child: CustomButton(
                onTap: () async {
                  Get.to(() => BookingRequestConditionsView());
                },
                btnColor: const Color(0xFF4493F1),
                addShadow: false,
                borderRadius: 30.0.r,
                padding: 15.0.r,
                child: Text(
                  "شروط الطلب",
                  style: context.textTheme.titleMedium!.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 25.0.h)),
            Text(
              'يجب فتح الشروط قبل المتابعة',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF22509E),
                fontSize: 20.0,
                fontWeight: FontWeight.w400,
                height: 1.10,
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 15.0.h)),
          ],
        ),
      ),
    );
  }
}
