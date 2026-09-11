import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/core/theme/app_colors.dart';
import 'package:skygate/tourism/global_widgets/custom_button.dart';
import 'package:skygate/tourism/modules/refund-operation/controllers/refund_operation_controller.dart';
import 'package:flutter/material.dart';
import 'package:skygate/tourism/modules/refund-operation/views/refund_step_two_view.dart';

class RefundStepOneView extends GetView<RefundOperationController> {
  RefundStepOneView({super.key});

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
              "طلب استرداد",
              style: context.textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 30.0,
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
            Text(
              refundOperationController.getTripTypeText(),
              style: context.textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 25.0,
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 71.0.h)),
            SizedBox(
              width: 284.0.w,
              child: CustomButton(
                child: Text(
                  "استرداد كامل التذكرة",
                  style: context.textTheme.titleMedium!.copyWith(
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  refundOperationController.refundType = "استرداد كامل التذكرة";
                  Get.to(() => RefundStepTwoView());
                },
                btnColor: AppColors.blue,
                padding: 20.0.r,
                addShadow: false,
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
            Visibility(
              visible:
                  (refundOperationController.bookingRequest.is_one_way == "0"),
              child: SizedBox(
                width: 284.0.w,
                child: CustomButton(
                  child: Text(
                    "استرداد قيمة مقظع العودة",
                    style: context.textTheme.titleMedium!.copyWith(
                      color: AppColors.blue,
                    ),
                  ),
                  onTap: () {
                    refundOperationController.refundType =
                        "استرداد قيمة مقظع العودة";
                    Get.to(() => RefundStepTwoView());
                  },
                  btnColor: Colors.white,
                  padding: 20.0.r,
                  addShadow: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
