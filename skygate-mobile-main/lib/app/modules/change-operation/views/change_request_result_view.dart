import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sky_gate/app/core/theme/app_colors.dart';
import 'package:sky_gate/app/global_widgets/custom_button.dart';
import 'package:sky_gate/app/global_widgets/custom_white_outlined_button.dart';
import 'package:sky_gate/app/global_widgets/error_panel.dart';
import 'package:sky_gate/app/global_widgets/loading_widget.dart';
import 'package:sky_gate/app/modules/change-operation/controllers/change_operation_controller.dart';
import 'package:flutter/material.dart';
import 'package:sky_gate/app/modules/change-operation/views/choose_payment_method2_view.dart';
import 'package:sky_gate/app/routes/app_pages.dart';

class ChangeRequestResultView extends GetView<ChangeOperationController> {
  ChangeRequestResultView({super.key});

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
      body: Container(
        width: 1 * 1.sw,
        height: 1 * 1.sh,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/seko.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: GetBuilder<ChangeOperationController>(
          init: changeOperationController,
          builder: (changeOperationController) {
            if (changeOperationController.getChangeRequestStatus ==
                    GetChangeRequestStatus.initial ||
                changeOperationController.getChangeRequestStatus ==
                    GetChangeRequestStatus.loading) {
              return LoadingWidget(
                color: AppColors.blue,
                size: 50.0,
              );
            } else if (changeOperationController.getChangeRequestStatus ==
                GetChangeRequestStatus.error) {
              return ErrorPanel(
                failure: changeOperationController.getChangeRequestFailure,
                onTryAgain: () async {
                  await changeOperationController.onInit();
                },
              );
            } else {
              return Column(
                children: [
                  Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
                  Text(
                    "نتيجة طلب التعديل",
                    style: context.textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 30.0,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
                  // Big White Container
                  Container(
                    width: 376.0.w,
                    height: 484.0.h,
                    padding: EdgeInsets.all(22.0.r),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0.r),
                      ),
                    ),
                    child: Container(
                      width: 332.0.w,
                      height: 444.0.h,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0.w, vertical: 15.0.h),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 1,
                            color: Color(0xFFD9D9D9),
                          ),
                          borderRadius: BorderRadius.circular(10.0.r),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Booking Request Number
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'رقم الحجز',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF767680),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  height: 1.38,
                                ),
                              ),
                              Text(
                                '${changeOperationController.bookingRequest.request_number}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF22509E),
                                  fontSize: 16.0,
                                  fontFamily: 'Aileron',
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
                          // Passenger Name
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
                          const Divider(
                            color: Color(0xFFD9D9D9),
                            thickness: 1.5,
                          ),
                          // Ticket Price
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'سعر التذكرة',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF767680),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  height: 1.38,
                                ),
                              ),
                              Text(
                                '${changeOperationController.bookingRequest.total_cost} ${changeOperationController.bookingRequest.currency}',
                                style: TextStyle(
                                  color: const Color(0xFF22509E),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  height: 1.38,
                                ),
                              )
                            ],
                          ),
                          const Divider(
                            color: Color(0xFFD9D9D9),
                            thickness: 1.5,
                          ),
                          // Change Amount
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'غرامة التعديل',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF767680),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  height: 1.38,
                                ),
                              ),
                              Text(
                                '${changeOperationController.changeRequest.change_penalty} ${changeOperationController.changeRequest.currency}',
                                style: TextStyle(
                                  color: const Color(0xFF22509E),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  height: 1.38,
                                ),
                              )
                            ],
                          ),
                          const Divider(
                            color: Color(0xFFD9D9D9),
                            thickness: 1.5,
                          ),
                          // Price Difference
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'فرق السعر',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF767680),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  height: 1.38,
                                ),
                              ),
                              Text(
                                '${changeOperationController.changeRequest.cost_difference} ${changeOperationController.changeRequest.currency}',
                                style: TextStyle(
                                  color: const Color(0xFF22509E),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  height: 1.38,
                                ),
                              )
                            ],
                          ),
                          const Divider(
                            color: Color(0xFFD9D9D9),
                            thickness: 1.5,
                          ),
                          // Missing Plane Penalty
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'التخلف عن الطائرة',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF767680),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  height: 1.38,
                                ),
                              ),
                              Text(
                                '${changeOperationController.changeRequest.plane_missing_penalty} ${changeOperationController.changeRequest.currency}',
                                style: TextStyle(
                                  color: const Color(0xFF22509E),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  height: 1.38,
                                ),
                              )
                            ],
                          ),
                          const Divider(
                            color: Color(0xFFD9D9D9),
                            thickness: 1.5,
                          ),
                          // Total Amount
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'مجموع الغرامات',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF767680),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  height: 1.38,
                                ),
                              ),
                              Text(
                                '${changeOperationController.penaltyTotalSum} ${changeOperationController.changeRequest.currency}',
                                style: TextStyle(
                                  color: const Color(0xFF22509E),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  height: 1.38,
                                ),
                              )
                            ],
                          ),
                          const Divider(
                            color: Color(0xFFD9D9D9),
                            thickness: 1.5,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 15.0.h)),
                  // Two Buttons Row
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50.0.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Continue Button
                        SizedBox(
                          width: 150.0.w,
                          child: CustomButton(
                            onTap: () async {
                              Get.to(() => ChoosePaymentMethod2View());
                            },
                            btnColor: AppColors.blue,
                            addShadow: false,
                            borderRadius: 30.0.r,
                            padding: 10.0.r,
                            child: Text(
                              "متابعة",
                              style: context.textTheme.titleMedium!.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        // Cancel Button
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
                  Padding(padding: EdgeInsets.only(bottom: 25.0.h)),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
