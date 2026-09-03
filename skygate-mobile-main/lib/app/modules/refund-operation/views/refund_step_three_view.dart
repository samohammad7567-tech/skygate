import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sky_gate/app/core/theme/app_colors.dart';
import 'package:sky_gate/app/global_widgets/custom_button.dart';
import 'package:sky_gate/app/modules/refund-operation/controllers/refund_operation_controller.dart';
import 'package:flutter/material.dart';

class RefundStepThreeView extends GetView<RefundOperationController> {
  RefundStepThreeView({super.key});

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
            Text(
              "هذه التذكرة",
              style: context.textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 30.0,
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 71.0.h)),
            SizedBox(
              width: 284.0.w,
              child: CustomButton(
                child: Text(
                  "استرداد قيمة التذكرة",
                  style: context.textTheme.titleMedium!.copyWith(
                    color: Colors.white,
                  ),
                ),
                onTap: () {},
                btnColor: AppColors.blue,
                padding: 20.0.r,
                addShadow: false,
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
            SizedBox(
              width: 284.0.w,
              child: CustomButton(
                child: Text(
                  "إلغاء",
                  style: context.textTheme.titleMedium!.copyWith(
                    color: AppColors.blue,
                  ),
                ),
                onTap: () {
                  Get.back();
                },
                btnColor: Colors.white,
                padding: 20.0.r,
                addShadow: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
