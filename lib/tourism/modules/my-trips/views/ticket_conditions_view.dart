import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:skygate/tourism/core/theme/app_colors.dart';
import 'package:skygate/tourism/global_widgets/custom_button.dart';
import 'package:skygate/tourism/global_widgets/gesture_page.dart';
import 'package:skygate/tourism/global_widgets/loading_widget.dart';
import 'package:skygate/tourism/modules/my-trips/controllers/my_trips_controller.dart';

class TicketConditionsView extends GetView<MyTripsController> {
  TicketConditionsView({super.key});

  final myTripsController = Get.find<MyTripsController>();

  @override
  Widget build(BuildContext context) {
    final conditions = myTripsController.conditions;
    final conditionsAccepted = myTripsController.conditions_accepted;

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
                Padding(padding: EdgeInsets.only(bottom: 40.0.h)),
                Text(
                  "شروط التذكرة",
                  style: context.textTheme.titleMedium!.copyWith(
                    color: AppColors.blue,
                    fontWeight: FontWeight.w500,
                    fontSize: 25.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
                Container(
                  width: 376.0.w,
                  height: 417.0.h,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'تغيير موعد الرحلة: ',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: const Color(0xFF195AA7),
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                height: 1.83,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 14.0.w,
                              height: 14.0.h,
                              decoration: ShapeDecoration(
                                shape: const OvalBorder(
                                  side: BorderSide(
                                    width: 1,
                                    color: Color(0xFFD9D9D9),
                                  ),
                                ),
                                color: (conditions.edit_booking == "1")
                                    ? AppColors.blue
                                    : Colors.white,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                            ),
                            Text(
                              'مجاني',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: const Color(0xFF195AA7),
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                height: 1.83,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                            ),
                            Container(
                              width: 14.0.w,
                              height: 14.0.h,
                              decoration: ShapeDecoration(
                                shape: const OvalBorder(
                                  side: BorderSide(
                                    width: 1,
                                    color: Color(0xFFD9D9D9),
                                  ),
                                ),
                                color: (conditions.edit_booking == "2")
                                    ? AppColors.blue
                                    : Colors.white,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                            ),
                            Text(
                              'غير قابل',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: const Color(0xFF195AA7),
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                height: 1.83,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                            ),
                            Container(
                              width: 14.0.w,
                              height: 14.0.h,
                              decoration: ShapeDecoration(
                                shape: const OvalBorder(
                                  side: BorderSide(
                                    width: 1,
                                    color: Color(0xFFD9D9D9),
                                  ),
                                ),
                                color: (conditions.edit_booking == "3")
                                    ? AppColors.blue
                                    : Colors.white,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                            ),
                            Text(
                              'يوجد رسوم',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: const Color(0xFF195AA7),
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                height: 1.83,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'رسوم تعديل موعد الرحلة :',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: const Color(0xFF195AA7),
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                height: 1.83,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                            ),
                            Text(
                              '${conditions.first_item_cost} ${conditions.currency}',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: const Color(0xFF195AA7),
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                height: 1.83,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                            ),
                          ],
                        ),

                        Padding(padding: EdgeInsets.only(bottom: 20.0.h)),
                        Row(
                          children: [
                            Text(
                              'إلغاء الحجز: ',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: const Color(0xFF195AA7),
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                height: 1.83,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 14.0.w,
                              height: 14.0.h,
                              decoration: ShapeDecoration(
                                shape: const OvalBorder(
                                  side: BorderSide(
                                    width: 1,
                                    color: Color(0xFFD9D9D9),
                                  ),
                                ),
                                color:
                                    (conditions.amount_refund_with_cancel ==
                                        "1")
                                    ? AppColors.blue
                                    : Colors.white,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                            ),
                            Text(
                              'مجاني',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: const Color(0xFF195AA7),
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                height: 1.83,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                            ),
                            Container(
                              width: 14.0.w,
                              height: 14.0.h,
                              decoration: ShapeDecoration(
                                shape: const OvalBorder(
                                  side: BorderSide(
                                    width: 1,
                                    color: Color(0xFFD9D9D9),
                                  ),
                                ),
                                color:
                                    (conditions.amount_refund_with_cancel ==
                                        "2")
                                    ? AppColors.blue
                                    : Colors.white,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                            ),
                            Text(
                              'غير قابل',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: const Color(0xFF195AA7),
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                height: 1.83,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                            ),
                            Container(
                              width: 14.0.w,
                              height: 14.0.h,
                              decoration: ShapeDecoration(
                                shape: const OvalBorder(
                                  side: BorderSide(
                                    width: 1,
                                    color: Color(0xFFD9D9D9),
                                  ),
                                ),
                                color:
                                    (conditions.amount_refund_with_cancel ==
                                        "3")
                                    ? AppColors.blue
                                    : Colors.white,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                            ),
                            Text(
                              'يوجد رسوم',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: const Color(0xFF195AA7),
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                height: 1.83,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'رسوم إلغاء الحجز :',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: const Color(0xFF195AA7),
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                height: 1.83,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                            ),
                            Text(
                              '${conditions.third_item_cost} ${conditions.currency}',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: const Color(0xFF195AA7),
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                height: 1.83,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                            ),
                          ],
                        ),

                        Padding(padding: EdgeInsets.only(bottom: 20.0.h)),
                        Row(
                          children: [
                            Text(
                              'تخلف عن الطائرة: ',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: const Color(0xFF195AA7),
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                height: 1.83,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 14.0.w,
                              height: 14.0.h,
                              decoration: ShapeDecoration(
                                shape: const OvalBorder(
                                  side: BorderSide(
                                    width: 1,
                                    color: Color(0xFFD9D9D9),
                                  ),
                                ),
                                color: (conditions.missing_flight == "1")
                                    ? AppColors.blue
                                    : Colors.white,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                            ),
                            Text(
                              'مجاني',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: const Color(0xFF195AA7),
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                height: 1.83,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                            ),
                            Container(
                              width: 14.0.w,
                              height: 14.0.h,
                              decoration: ShapeDecoration(
                                shape: const OvalBorder(
                                  side: BorderSide(
                                    width: 1,
                                    color: Color(0xFFD9D9D9),
                                  ),
                                ),
                                color: (conditions.missing_flight == "2")
                                    ? AppColors.blue
                                    : Colors.white,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                            ),
                            Text(
                              'غير قابل',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: const Color(0xFF195AA7),
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                height: 1.83,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                            ),
                            Container(
                              width: 14.0.w,
                              height: 14.0.h,
                              decoration: ShapeDecoration(
                                shape: const OvalBorder(
                                  side: BorderSide(
                                    width: 1,
                                    color: Color(0xFFD9D9D9),
                                  ),
                                ),
                                color: (conditions.missing_flight == "3")
                                    ? AppColors.blue
                                    : Colors.white,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                            ),
                            Text(
                              'يوجد رسوم',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: const Color(0xFF195AA7),
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                height: 1.83,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'رسوم التخلف عن الطائرة :',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: const Color(0xFF195AA7),
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                height: 1.83,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                            ),
                            Text(
                              '${conditions.second_item_cost} ${conditions.currency}',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: const Color(0xFF195AA7),
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                height: 1.83,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                            ),
                          ],
                        ),

                        Padding(padding: EdgeInsets.only(bottom: 20.0.h)),
                        Row(
                          children: [
                            Text(
                              'تخلف بعد الإلغاء: ',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: const Color(0xFF195AA7),
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                height: 1.83,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 14.0.w,
                              height: 14.0.h,
                              decoration: ShapeDecoration(
                                shape: const OvalBorder(
                                  side: BorderSide(
                                    width: 1,
                                    color: Color(0xFFD9D9D9),
                                  ),
                                ),
                                color: (conditions.missing_after_cancel == "1")
                                    ? AppColors.blue
                                    : Colors.white,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                            ),
                            Text(
                              'مجاني',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: const Color(0xFF195AA7),
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                height: 1.83,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                            ),
                            Container(
                              width: 14.0.w,
                              height: 14.0.h,
                              decoration: ShapeDecoration(
                                shape: const OvalBorder(
                                  side: BorderSide(
                                    width: 1,
                                    color: Color(0xFFD9D9D9),
                                  ),
                                ),
                                color: (conditions.missing_after_cancel == "2")
                                    ? AppColors.blue
                                    : Colors.white,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                            ),
                            Text(
                              'غير قابل',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: const Color(0xFF195AA7),
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                height: 1.83,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                            ),
                            Container(
                              width: 14.0.w,
                              height: 14.0.h,
                              decoration: ShapeDecoration(
                                shape: const OvalBorder(
                                  side: BorderSide(
                                    width: 1,
                                    color: Color(0xFFD9D9D9),
                                  ),
                                ),
                                color: (conditions.missing_after_cancel == "3")
                                    ? AppColors.blue
                                    : Colors.white,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                            ),
                            Text(
                              'يوجد رسوم',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: const Color(0xFF195AA7),
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                height: 1.83,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'رسوم التخلف بعد الإلغاء :',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: const Color(0xFF195AA7),
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                height: 1.83,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                            ),
                            Text(
                              '${conditions.fourth_item_cost} ${conditions.currency}',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: const Color(0xFF195AA7),
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                height: 1.83,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
                Visibility(
                  visible: (conditionsAccepted == "0"),
                  child: SizedBox(
                    width: 320.0.w,
                    height: 50.0.h,
                    child: CustomButton(
                      onTap: () async {
                        await myTripsController.acceptTripConditions(
                          context: context,
                        );
                      },
                      btnColor: AppColors.blue,
                      padding: 10.0,
                      addShadow: false,
                      child: GetBuilder<MyTripsController>(
                        init: myTripsController,
                        builder: (myTripsController) {
                          if (myTripsController.acceptTripConditionsStatus ==
                              AcceptTripConditionsStatus.loading) {
                            return LoadingWidget(
                              size: 25.0,
                              color: Colors.white,
                            );
                          } else {
                            return Text(
                              "الموافقة على الشروط",
                              style: context.textTheme.titleMedium!.copyWith(
                                color: Colors.white,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}
