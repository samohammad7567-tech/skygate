import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sky_gate/app/routes/app_pages.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/support_controller.dart';

class SupportView extends GetView<SupportController> {
  SupportView({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
        Text(
          "الدعم",
          style: context.textTheme.displayLarge!.copyWith(
            color: AppColors.blue,
            fontWeight: FontWeight.w500,
            fontSize: 40.0,
          ),
        ),
        Padding(padding: EdgeInsets.only(bottom: 50.0.h)),
        InkWell(
          onTap: () {
            Get.toNamed(Routes.CUSTOMER_CARE_SUPPORT);
          },
          child: Image.asset("assets/images/customer-care-btn.png"),
        ),
        Padding(padding: EdgeInsets.only(bottom: 100.0.h)),
        InkWell(
          onTap: () {
            Get.toNamed(Routes.SALES_SUPPORT);
          },
          child: Image.asset("assets/images/sales-btn.png"),
        ),
      ],
    );
  }
}
