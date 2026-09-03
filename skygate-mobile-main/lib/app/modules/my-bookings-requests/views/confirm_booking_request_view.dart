import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sky_gate/app/core/theme/app_colors.dart';
import 'package:sky_gate/app/global_widgets/custom_button.dart';
import 'package:sky_gate/app/modules/my-bookings-requests/controllers/my_bookings_requests_controller.dart';
import 'package:sky_gate/app/routes/app_pages.dart';

class ConfirmBookingRequestView extends GetView<MyBookingsRequestsController> {
  ConfirmBookingRequestView({super.key});

  final myBookingsRequestsController = Get.find<MyBookingsRequestsController>();

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
            Image.asset("assets/images/handshake.png"),
            Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
            Container(
              width: 325.0.w,
              height: 281.0.h,
              decoration: ShapeDecoration(
                color: const Color(0xA3FCFDFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                'سيتم التواصل معكم من   قسم المبيعات خلال دقائق\n\n\nلإتمام الحجز وتصدير التذكرة',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF195AA7),
                  fontSize: 24.0,
                  fontWeight: FontWeight.w400,
                  height: 1.71,
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 100.0.h)),
            SizedBox(
              width: 150.0.w,
              child: CustomButton(
                onTap: () {
                  Get.offAllNamed(Routes.HOME);
                  Get.toNamed(Routes.MY_BOOKINGS_REQUESTS);
                },
                btnColor: AppColors.blue,
                addShadow: false,
                borderRadius: 15.0.r,
                padding: 20.0.r,
                child: Text(
                  "عرض الطلبات",
                  style: context.textTheme.titleMedium!.copyWith(
                    color: Colors.white,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 50.0.h)),
            SvgPicture.asset("assets/images/big-logo.svg"),
          ],
        ),
      ),
    );
  }
}
