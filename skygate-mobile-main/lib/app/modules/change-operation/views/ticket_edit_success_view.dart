import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sky_gate/app/core/theme/app_colors.dart';
import 'package:sky_gate/app/global_widgets/custom_button.dart';
import 'package:sky_gate/app/modules/change-operation/controllers/change_operation_controller.dart';
import 'package:flutter/material.dart';
import 'package:sky_gate/app/routes/app_pages.dart';

class TicketEditSuccessView extends GetView<ChangeOperationController> {
  TicketEditSuccessView({super.key});

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
            Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
            Container(
              width: 376.0.w,
              height: 250.0.h,
              decoration: ShapeDecoration(
                color: const Color(0xA3FCFDFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0.r),
                ),
              ),
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(bottom: 60.0.h)),
                  SizedBox(
                    width: 300.0.w,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 255.0.w,
                          height: 23.0.h,
                          child: Text(
                            'تم تعديل التذكرة بنجاح',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF195AA7),
                              fontSize: 20.0,
                              fontWeight: FontWeight.w400,
                              height: 1.10,
                            ),
                          ),
                        ),
                        Image.asset("assets/images/tick.png"),
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
                  SizedBox(
                    width: 295.0.w,
                    height: 52.0.h,
                    child: Text(
                      'يمكنك الآن القيام بتحميل التذكرة ومتابعة تفاصيل الرحلة من خلال التطبيق أو عبر التواصل مع قسم المبيعات',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF195AA7),
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        height: 1.83,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
            // Bookings Requests Button
            SizedBox(
              width: 200.0.w,
              child: CustomButton(
                onTap: () async {
                  Get.offAllNamed(Routes.MY_BOOKINGS_REQUESTS);
                },
                btnColor: AppColors.blue,
                addShadow: false,
                borderRadius: 30.0.r,
                padding: 15.0.r,
                child: Text(
                  "الطلبات",
                  style: context.textTheme.titleMedium!.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
            // My Trips BTN
            SizedBox(
              width: 200.0.w,
              child: CustomButton(
                onTap: () async {
                  Get.offAllNamed(Routes.MY_TRIPS);
                },
                btnColor: AppColors.blue,
                addShadow: false,
                borderRadius: 30.0.r,
                padding: 15.0.r,
                child: Text(
                  "تحميل التذكرة",
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
