import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sky_gate/app/core/theme/app_colors.dart';
import 'package:sky_gate/app/global_widgets/custom_button.dart';
import 'package:sky_gate/app/global_widgets/custom_white_outlined_button.dart';
import 'package:sky_gate/app/global_widgets/loading_widget.dart';
import 'package:sky_gate/app/modules/refund-operation/controllers/refund_operation_controller.dart';
import 'package:flutter/material.dart';
import 'package:sky_gate/app/modules/refund-operation/views/booking_request_conditions_view.dart';
import 'package:sky_gate/app/modules/refund-operation/views/refund_step_four_view.dart';
import 'package:sky_gate/app/routes/app_pages.dart';

class RefundStepTwoView extends GetView<RefundOperationController> {
  RefundStepTwoView({super.key});

  final refundOperationController = Get.find<RefundOperationController>();

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
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
            Text(
              "طلب استرداد",
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
                padding:
                    EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 15.0.h),
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
                          '${refundOperationController.bookingRequest.request_number}',
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
                          '${refundOperationController.userModel.full_name}',
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
                    // Travel Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'تاريخ السفر',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF767680),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            height: 1.38,
                          ),
                        ),
                        Text(
                          '${refundOperationController.bookingRequest.departure_date}',
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
                    // Arrival Place
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'الوجهة',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF767680),
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            height: 1.57,
                          ),
                        ),
                        Text(
                          '${refundOperationController.bookingRequest.arrival_place}',
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
                          '${refundOperationController.bookingRequest.total_cost} ${refundOperationController.bookingRequest.currency}',
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
                        if (refundOperationController.isConditionsAccepted ==
                            true) {
                          await refundOperationController.submitRefundRequest(
                              context: context);
                          Get.to(() => RefundStepFourView());
                        }
                      },
                      btnColor: AppColors.blue,
                      addShadow: false,
                      borderRadius: 30.0.r,
                      padding: 10.0.r,
                      child: GetBuilder<RefundOperationController>(
                        init: refundOperationController,
                        builder: (refundOperationController) {
                          if (refundOperationController
                                  .submitRefundRequestStatus ==
                              SubmitRefundRequestStatus.loading) {
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
            Padding(padding: EdgeInsets.only(bottom: 15.0.h)),
            // Booking Request Conditions Button
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
            // Request Conditions Text
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
