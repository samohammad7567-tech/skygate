import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/core/theme/app_colors.dart';
import 'package:skygate/tourism/global_widgets/custom_button.dart';
import 'package:skygate/tourism/modules/change-operation/controllers/change_operation_controller.dart';
import 'package:flutter/material.dart';
import 'package:skygate/tourism/routes/app_pages.dart';

class AfterPaymentMethodView extends GetView<ChangeOperationController> {
  AfterPaymentMethodView({super.key});

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
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(bottom: 50.0.h)),
            Image.asset("assets/images/handshake.png"),
            Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
            Container(
              width: 376.0.w,
              height: 280.0.h,
              decoration: ShapeDecoration(
                color: const Color(0xA3FCFDFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0.r),
                ),
              ),
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(bottom: 60.0.h)),
                  Text(
                    'سيتم التواصل معكم من   قسم المبيعات خلال دقائق\n\n\nلإتمام الحجز وتصدير التذكرة',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF195AA7),
                      fontSize: 24.0,
                      fontWeight: FontWeight.w400,
                      height: 1.71,
                    ),
                  )
                ],
              ),
            ),
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
