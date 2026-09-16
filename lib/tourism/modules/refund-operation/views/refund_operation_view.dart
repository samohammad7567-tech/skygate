import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:skygate/tourism/core/theme/app_colors.dart';
import 'package:skygate/tourism/global_widgets/custom_button.dart';
import 'package:skygate/tourism/modules/refund-operation/views/refund_step_one_view.dart';

import '../controllers/refund_operation_controller.dart';

class RefundOperationView extends GetView<RefundOperationController> {
  RefundOperationView({super.key});

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
            Padding(padding: EdgeInsets.only(bottom: 71.0.h)),
            SizedBox(
              width: 284.0.w,
              child: CustomButton(
                onTap: () {
                  Get.to(() => RefundStepOneView());
                },
                btnColor: AppColors.blue,
                padding: 20.0.r,
                addShadow: false,
                child: Text(
                  "استرداد قيمة التذكرة",
                  style: context.textTheme.titleMedium!.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
            SizedBox(
              width: 284.0.w,
              child: CustomButton(
                onTap: () {
                  Get.back();
                },
                btnColor: Colors.white,
                padding: 20.0.r,
                addShadow: true,
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
    );
  }
}
