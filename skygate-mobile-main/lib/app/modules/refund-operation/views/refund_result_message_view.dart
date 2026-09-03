import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sky_gate/app/core/theme/app_colors.dart';
import 'package:sky_gate/app/global_widgets/custom_button.dart';
import 'package:sky_gate/app/modules/refund-operation/controllers/refund_operation_controller.dart';
import 'package:flutter/material.dart';
import 'package:sky_gate/app/routes/app_pages.dart';

class RefundResultMessageView extends GetView<RefundOperationController> {
  RefundResultMessageView({super.key});

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
              refundOperationController.getRefundResultMsgPageTitle(),
              style: context.textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 30.0,
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
            refundOperationController.getRefundResultMsgPageContent(),
            Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
            // Return Back Button
            SizedBox(
              width: 200.0.w,
              child: CustomButton(
                onTap: () async {
                  Get.offAllNamed(Routes.HOME);
                },
                btnColor: AppColors.blue,
                addShadow: false,
                borderRadius: 30.0.r,
                padding: 15.0.r,
                child: Text(
                  "الرجوع",
                  style: context.textTheme.titleMedium!.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 25.0.h)),
          ],
        ),
      ),
    );
  }
}
