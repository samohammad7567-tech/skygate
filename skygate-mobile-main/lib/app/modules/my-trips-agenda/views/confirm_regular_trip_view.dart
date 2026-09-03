import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sky_gate/app/core/theme/app_colors.dart';
import 'package:sky_gate/app/global_widgets/custom_white_outlined_button.dart';
import 'package:sky_gate/app/global_widgets/gesture_page.dart';
import 'package:sky_gate/app/modules/my-trips-agenda/controllers/my_trips_agenda_controller.dart';
import 'package:sky_gate/app/routes/app_pages.dart';


class ConfirmRegularTripView extends GetView<MyTripsAgendaController> {
  ConfirmRegularTripView({super.key});

  final myTripsAgendaController = Get.find<MyTripsAgendaController>();

  @override
  Widget build(BuildContext context) {
    return GesturePage(
      gestureChild: Scaffold(
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
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage("assets/images/seko.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0.w),
            child: Container(
              width: 300.0.w,
              height: 150.0.h,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0.r),
              ),
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(bottom: 100.0.h)),
                  Image.asset("assets/images/confirm-regular.png"),
                  Padding(padding: EdgeInsets.only(bottom: 40.0.h)),
                  SizedBox(
                    width: 150.0.w,
                    child: CustomWhiteOutlinedButton(
                      onTap: () {
                        Get.offAllNamed(Routes.HOME);
                      },
                      addShadow: false,
                      borderColor: AppColors.blue,
                      child: Text(
                        "رجوع",
                        style: context.textTheme.titleMedium!.copyWith(
                          color: AppColors.blue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}
