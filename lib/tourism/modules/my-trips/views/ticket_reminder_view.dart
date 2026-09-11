import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/core/theme/app_colors.dart';
import 'package:skygate/tourism/global_widgets/gesture_page.dart';
import 'package:skygate/tourism/modules/my-trips/controllers/my_trips_controller.dart';
import 'package:flutter/material.dart';

class TicketReminderView extends GetView<MyTripsController> {
  TicketReminderView({super.key});

  @override
  Widget build(BuildContext context) {
    return GesturePage(
      gestureChild: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: false,
        extendBody: true,
        resizeToAvoidBottomInset: true,
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(padding: EdgeInsets.only(bottom: 20.0.h)),
                // Page Title
                Text(
                  "تذكير",
                  style: context.textTheme.titleLarge!.copyWith(
                    fontSize: 40.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Padding(padding: EdgeInsets.only(bottom: 75.0.h)),
                Container(
                  width: 376.0.w,
                  height: 219.0.h,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 302.0.w,
                        child: Text(
                          'سيتم تذكيرك بموعد الرحلة قبل 24 ساعة وقبل 6 ساعات من موعد الرحلة',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.blue,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            height: 1.57,
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 20.0.h)),
                      Image.asset("assets/images/pngs/notification.png"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
