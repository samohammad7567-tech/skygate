import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:skygate/tourism/core/theme/app_colors.dart';
import 'package:skygate/tourism/global_widgets/custom_button.dart';
import 'package:skygate/tourism/global_widgets/gesture_page.dart';
import 'package:skygate/tourism/global_widgets/loading_widget.dart';
import 'package:skygate/tourism/modules/change-operation/controllers/change_operation_controller.dart';
import 'package:skygate/tourism/modules/my-trips/controllers/my_trips_controller.dart';

class BookingRequestConditionsView extends GetView<ChangeOperationController> {
  BookingRequestConditionsView({super.key});

  final changeOperationController = Get.find<ChangeOperationController>();

  @override
  Widget build(BuildContext context) {
    return GesturePage(
      gestureChild: DefaultTabController(
        length: (changeOperationController.bookingRequest.is_one_way == "0")
            ? 2
            : 1,
        child: Scaffold(
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
                  // Body Title
                  Text(
                    "شروط طلب الحجز",
                    style: context.textTheme.titleMedium!.copyWith(
                      color: AppColors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 25.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
                  // Two Choices Tabs
                  TabBar(
                    controller: changeOperationController.tabController,
                    labelColor: AppColors.blue,
                    unselectedLabelColor: Colors.blueGrey,
                    indicatorColor: AppColors.blue,
                    tabs:
                        (changeOperationController.bookingRequest.is_one_way ==
                                "0")
                            ? [
                                const Tab(text: 'شروط رحلة الذهاب'),
                                const Tab(text: 'شروط رحلة العودة'),
                              ]
                            : [
                                const Tab(text: 'شروط رحلة الذهاب فقط'),
                              ],
                  ),

                  SizedBox(
                    height: 450.0.h,
                    child: TabBarView(
                        controller: changeOperationController.tabController,
                        children: [
                          // White big container
                          // First Way Conditions
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
                              padding: EdgeInsets.all(25.0.r),
                              child: Column(
                                children: [
                                  // Change Trip Time Title Text
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
                                  // Change Trip Time Conditions
                                  Row(
                                    children: [
                                      // Free
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
                                          color: (changeOperationController
                                                      .firstWayConditions
                                                      .edit_booking ==
                                                  "1")
                                              ? AppColors.blue
                                              : Colors.white,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.0.w),
                                      ),
                                      // Free Text
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0.w),
                                      ),

                                      // Unavailable
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
                                          color: (changeOperationController
                                                      .firstWayConditions
                                                      .edit_booking ==
                                                  "2")
                                              ? AppColors.blue
                                              : Colors.white,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.0.w),
                                      ),
                                      // Unavailable Text
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0.w),
                                      ),

                                      // Paid Conditiond
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
                                          color: (changeOperationController
                                                      .firstWayConditions
                                                      .edit_booking ==
                                                  "3")
                                              ? AppColors.blue
                                              : Colors.white,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.0.w),
                                      ),
                                      // Paid Conditions Text
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0.w),
                                      ),
                                    ],
                                  ),
                                  // Change Trip Time Penalty Amount
                                  Row(
                                    children: [
                                      // Change Trip Time Penalty Text
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0.w),
                                      ),
                                      // Penalty Amount
                                      Text(
                                        '${changeOperationController.firstWayConditions.first_item_cost} ${changeOperationController.firstWayConditions.currency}',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          color: const Color(0xFF195AA7),
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w400,
                                          height: 1.83,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0.w),
                                      ),
                                    ],
                                  ),

                                  Padding(
                                      padding: EdgeInsets.only(bottom: 20.0.h)),

                                  // Cancel Ticket Title Text
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
                                  // Cancel Ticket Conditions
                                  Row(
                                    children: [
                                      // Free
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
                                          color: (changeOperationController
                                                      .firstWayConditions
                                                      .amount_refund_with_cancel ==
                                                  "1")
                                              ? AppColors.blue
                                              : Colors.white,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.0.w),
                                      ),
                                      // Free Text
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0.w),
                                      ),

                                      // Unavailable
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
                                          color: (changeOperationController
                                                      .firstWayConditions
                                                      .amount_refund_with_cancel ==
                                                  "2")
                                              ? AppColors.blue
                                              : Colors.white,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.0.w),
                                      ),
                                      // Unavailable Text
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0.w),
                                      ),

                                      // Paid Conditions
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
                                          color: (changeOperationController
                                                      .firstWayConditions
                                                      .amount_refund_with_cancel ==
                                                  "3")
                                              ? AppColors.blue
                                              : Colors.white,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.0.w),
                                      ),
                                      // Paid Conditions Text
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0.w),
                                      ),
                                    ],
                                  ),
                                  // Cancel Ticket Penalty Amount
                                  Row(
                                    children: [
                                      // Change Trip Time Penalty Text
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0.w),
                                      ),
                                      // Penalty Amount
                                      Text(
                                        '${changeOperationController.firstWayConditions.third_item_cost} ${changeOperationController.firstWayConditions.currency}',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          color: const Color(0xFF195AA7),
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w400,
                                          height: 1.83,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0.w),
                                      ),
                                    ],
                                  ),

                                  Padding(
                                      padding: EdgeInsets.only(bottom: 20.0.h)),

                                  // Missing Plane Title Text
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
                                  // Missing Plane Conditions
                                  Row(
                                    children: [
                                      // Free
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
                                          color: (changeOperationController
                                                      .firstWayConditions
                                                      .missing_flight ==
                                                  "1")
                                              ? AppColors.blue
                                              : Colors.white,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.0.w),
                                      ),
                                      // Free Text
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0.w),
                                      ),

                                      // Unavailable
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
                                          color: (changeOperationController
                                                      .firstWayConditions
                                                      .missing_flight ==
                                                  "2")
                                              ? AppColors.blue
                                              : Colors.white,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.0.w),
                                      ),
                                      // Unavailable Text
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0.w),
                                      ),

                                      // Paid Conditions
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
                                          color: (changeOperationController
                                                      .firstWayConditions
                                                      .missing_flight ==
                                                  "3")
                                              ? AppColors.blue
                                              : Colors.white,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.0.w),
                                      ),
                                      // Paid Conditions Text
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0.w),
                                      ),
                                    ],
                                  ),
                                  // Missing Plane Penalty Amount
                                  Row(
                                    children: [
                                      // Change Trip Time Penalty Text
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0.w),
                                      ),
                                      // Penalty Amount
                                      Text(
                                        '${changeOperationController.firstWayConditions.second_item_cost} ${changeOperationController.firstWayConditions.currency}',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          color: const Color(0xFF195AA7),
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w400,
                                          height: 1.83,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0.w),
                                      ),
                                    ],
                                  ),

                                  Padding(
                                      padding: EdgeInsets.only(bottom: 20.0.h)),

                                  // Missing After Cancellation Title Text
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
                                  // Missing After Cancellation Conditions
                                  Row(
                                    children: [
                                      // Free
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
                                          color: (changeOperationController
                                                      .firstWayConditions
                                                      .missing_after_cancel ==
                                                  "1")
                                              ? AppColors.blue
                                              : Colors.white,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.0.w),
                                      ),
                                      // Free Text
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0.w),
                                      ),

                                      // Unavailable
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
                                          color: (changeOperationController
                                                      .firstWayConditions
                                                      .missing_after_cancel ==
                                                  "2")
                                              ? AppColors.blue
                                              : Colors.white,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.0.w),
                                      ),
                                      // Unavailable Text
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0.w),
                                      ),

                                      // Paid Conditions
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
                                          color: (changeOperationController
                                                      .firstWayConditions
                                                      .missing_after_cancel ==
                                                  "3")
                                              ? AppColors.blue
                                              : Colors.white,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.0.w),
                                      ),
                                      // Paid Conditions Text
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0.w),
                                      ),
                                    ],
                                  ),
                                  // Missing After Cancellation Penalty Amount
                                  Row(
                                    children: [
                                      // Change Trip Time Penalty Text
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0.w),
                                      ),
                                      // Penalty Amount
                                      Text(
                                        '${changeOperationController.firstWayConditions.fourth_item_cost} ${changeOperationController.firstWayConditions.currency}',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          color: const Color(0xFF195AA7),
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w400,
                                          height: 1.83,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0.w),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Return Conditions
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
                              padding: EdgeInsets.all(25.0.r),
                              child: Column(
                                children: [
                                  // Change Trip Time Title Text
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
                                  // Change Trip Time Conditions
                                  Row(
                                    children: [
                                      // Free
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
                                          color: (changeOperationController
                                                      .returnConditions
                                                      .edit_booking ==
                                                  "1")
                                              ? AppColors.blue
                                              : Colors.white,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.0.w),
                                      ),
                                      // Free Text
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0.w),
                                      ),

                                      // Unavailable
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
                                          color: (changeOperationController
                                                      .returnConditions
                                                      .edit_booking ==
                                                  "2")
                                              ? AppColors.blue
                                              : Colors.white,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.0.w),
                                      ),
                                      // Unavailable Text
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0.w),
                                      ),

                                      // Paid Conditiond
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
                                          color: (changeOperationController
                                                      .returnConditions
                                                      .edit_booking ==
                                                  "3")
                                              ? AppColors.blue
                                              : Colors.white,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.0.w),
                                      ),
                                      // Paid Conditiond Text
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0.w),
                                      ),
                                    ],
                                  ),
                                  // Change Trip Time Penalty Amount
                                  Row(
                                    children: [
                                      // Change Trip Time Penalty Text
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0.w),
                                      ),
                                      // Penalty Amount
                                      Text(
                                        '${changeOperationController.returnConditions.first_item_cost} ${changeOperationController.returnConditions.currency}',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          color: const Color(0xFF195AA7),
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w400,
                                          height: 1.83,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0.w),
                                      ),
                                    ],
                                  ),

                                  Padding(
                                      padding: EdgeInsets.only(bottom: 20.0.h)),

                                  // Cancel Ticket Title Text
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
                                  // Cancel Ticket Conditions
                                  Row(
                                    children: [
                                      // Free
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
                                          color: (changeOperationController
                                                      .returnConditions
                                                      .amount_refund_with_cancel ==
                                                  "1")
                                              ? AppColors.blue
                                              : Colors.white,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.0.w),
                                      ),
                                      // Free Text
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0.w),
                                      ),

                                      // Unavailable
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
                                          color: (changeOperationController
                                                      .returnConditions
                                                      .amount_refund_with_cancel ==
                                                  "2")
                                              ? AppColors.blue
                                              : Colors.white,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.0.w),
                                      ),
                                      // Unavailable Text
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0.w),
                                      ),

                                      // Paid Conditions
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
                                          color: (changeOperationController
                                                      .returnConditions
                                                      .amount_refund_with_cancel ==
                                                  "3")
                                              ? AppColors.blue
                                              : Colors.white,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.0.w),
                                      ),
                                      // Paid Conditions Text
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0.w),
                                      ),
                                    ],
                                  ),
                                  // Cancel Ticket Penalty Amount
                                  Row(
                                    children: [
                                      // Change Trip Time Penalty Text
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0.w),
                                      ),
                                      // Penalty Amount
                                      Text(
                                        '${changeOperationController.returnConditions.third_item_cost} ${changeOperationController.returnConditions.currency}',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          color: const Color(0xFF195AA7),
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w400,
                                          height: 1.83,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0.w),
                                      ),
                                    ],
                                  ),

                                  Padding(
                                      padding: EdgeInsets.only(bottom: 20.0.h)),

                                  // Missing Plane Title Text
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
                                  // Missing Plane Conditions
                                  Row(
                                    children: [
                                      // Free
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
                                          color: (changeOperationController
                                                      .returnConditions
                                                      .missing_flight ==
                                                  "1")
                                              ? AppColors.blue
                                              : Colors.white,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.0.w),
                                      ),
                                      // Free Text
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0.w),
                                      ),

                                      // Unavailable
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
                                          color: (changeOperationController
                                                      .returnConditions
                                                      .missing_flight ==
                                                  "2")
                                              ? AppColors.blue
                                              : Colors.white,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.0.w),
                                      ),
                                      // Unavailable Text
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0.w),
                                      ),

                                      // Paid Conditions
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
                                          color: (changeOperationController
                                                      .returnConditions
                                                      .missing_flight ==
                                                  "3")
                                              ? AppColors.blue
                                              : Colors.white,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.0.w),
                                      ),
                                      // Paid Conditions Text
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0.w),
                                      ),
                                    ],
                                  ),
                                  // Missing Plane Penalty Amount
                                  Row(
                                    children: [
                                      // Change Trip Time Penalty Text
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0.w),
                                      ),
                                      // Penalty Amount
                                      Text(
                                        '${changeOperationController.returnConditions.second_item_cost} ${changeOperationController.returnConditions.currency}',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          color: const Color(0xFF195AA7),
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w400,
                                          height: 1.83,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0.w),
                                      ),
                                    ],
                                  ),

                                  Padding(
                                      padding: EdgeInsets.only(bottom: 20.0.h)),

                                  // Missing After Cancellation Title Text
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
                                  // Missing After Cancellation Conditions
                                  Row(
                                    children: [
                                      // Free
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
                                          color: (changeOperationController
                                                      .returnConditions
                                                      .missing_after_cancel ==
                                                  "1")
                                              ? AppColors.blue
                                              : Colors.white,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.0.w),
                                      ),
                                      // Free Text
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0.w),
                                      ),

                                      // Unavailable
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
                                          color: (changeOperationController
                                                      .returnConditions
                                                      .missing_after_cancel ==
                                                  "2")
                                              ? AppColors.blue
                                              : Colors.white,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.0.w),
                                      ),
                                      // Unavailable Text
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0.w),
                                      ),

                                      // Paid Conditions
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
                                          color: (changeOperationController
                                                      .returnConditions
                                                      .missing_after_cancel ==
                                                  "3")
                                              ? AppColors.blue
                                              : Colors.white,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.0.w),
                                      ),
                                      // Paid Conditions Text
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0.w),
                                      ),
                                    ],
                                  ),
                                  // Missing After Cancellation Penalty Amount
                                  Row(
                                    children: [
                                      // Change Trip Time Penalty Text
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0.w),
                                      ),
                                      // Penalty Amount
                                      Text(
                                        '${changeOperationController.returnConditions.fourth_item_cost} ${changeOperationController.returnConditions.currency}',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          color: const Color(0xFF195AA7),
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w400,
                                          height: 1.83,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0.w),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]),
                  ),

                  Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
                  // Accept Conditions Button
                  Visibility(
                    visible: (changeOperationController.isConditionsAccepted ==
                        false),
                    child: SizedBox(
                      width: 320.0.w,
                      height: 50.0.h,
                      child: CustomButton(
                        onTap: () async {
                          await changeOperationController
                              .acceptRequestConditions(context: context);
                        },
                        btnColor: AppColors.blue,
                        padding: 10.0,
                        addShadow: false,
                        child: GetBuilder<ChangeOperationController>(
                          init: changeOperationController,
                          builder: (changeOperationController) {
                            if (changeOperationController
                                    .acceptRequestConditionsStatus ==
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
      ),
    );
  }
}
