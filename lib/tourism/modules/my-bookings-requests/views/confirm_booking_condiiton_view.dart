import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/core/theme/app_colors.dart';
import 'package:skygate/tourism/global_widgets/custom_button.dart';
import 'package:skygate/tourism/modules/my-trips/models/condition_model.dart';
import 'package:skygate/tourism/routes/app_pages.dart';

import '../controllers/my_bookings_requests_controller.dart';

class ConfirmBookingCondiitonView extends StatelessWidget {
  ConfirmBookingCondiitonView({super.key});
  final myBookingsRequestsController = Get.find<MyBookingsRequestsController>();
  final List conditions = ['مجاني', 'غير قابل', 'يوجد رسوم'];
  final List titles = ['تغيير الموعد ', 'إلغاء الحجز', 'تخلف عن الطائرة'];
  final List returnTitles = ['تغيير موعد الإياب', 'إلغاء مقطع الإياب'];

  List<String> _mapConditionsToDisplay(ConditionModel? conditionModel) {
    if (conditionModel == null) return ['مجاني', 'مجاني', 'مجاني'];

    return [
      _mapConditionValue(conditionModel.edit_booking),
      _mapConditionValue(conditionModel.missing_flight),
      _mapConditionValue(conditionModel.amount_refund_with_cancel),
    ];
  }

  String _mapConditionValue(String? value) {
    switch (value) {
      case '1':
        return 'مجاني';
      case '2':
        return 'غير قابل';
      case '3':
        return 'يوجد رسوم';
      default:
        return 'مجاني';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            image: AssetImage('assets/images/pngs/seko.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
            Text(
              "شروط التذكرة",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontSize: 40.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 36.0.h)),
            GetBuilder(
              init: myBookingsRequestsController,
              builder: (controller) {
                final bookingRequest =
                    myBookingsRequestsController.selectedBookingRequest;
                final firstWayConditions = bookingRequest?.first_way_conditions;
                final returnConditions = bookingRequest?.return_conditions;
                List<String> firstWayConditionsDisplay =
                    _mapConditionsToDisplay(firstWayConditions);
                List<String> returnConditionsDisplay = _mapConditionsToDisplay(
                  returnConditions,
                );

                return Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(25.0.w),
                      padding: EdgeInsets.all(25.0.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0.r),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          if (firstWayConditions != null)
                            ConditionSection(
                              sectionTitle: "قبل السفر",
                              titles: titles,
                              conditions: firstWayConditionsDisplay,
                            ),
                          if (firstWayConditions != null &&
                              returnConditions != null)
                            SizedBox(height: 50.0.h),
                          if (returnConditions != null)
                            ConditionSection(
                              sectionTitle:
                                  "بعد السفر (في حالة الرحلة ذهاب - إياب)",
                              titles: returnTitles,
                              conditions: returnConditionsDisplay,
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 25.0.h),
                    GetBuilder<MyBookingsRequestsController>(
                      builder: (controller) {
                        return CustomButton(
                          onTap: () async {
                            if (controller.acceptBookingConditionsStatus ==
                                AcceptBookingConditionsStatus.loading) {
                              return; // Prevent multiple taps while loading
                            }

                            await controller.acceptBookingConditions(
                              bookingRequestId: bookingRequest?.id.toString(),
                            );

                            if (controller.acceptBookingConditionsStatus ==
                                AcceptBookingConditionsStatus.success) {
                              controller.loadPassportsFromSelectedBooking();
                              controller.getCameraPermission();
                              Get.toNamed(Routes.ADD_PASSPORTS_VIEW);
                            } else if (controller
                                    .acceptBookingConditionsStatus ==
                                AcceptBookingConditionsStatus.error) {
                              Get.snackbar(
                                "خطأ",
                                "حدث خطأ في قبول الشروط. يرجى المحاولة مرة أخرى.",
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            }
                          },
                          btnColor:
                              controller.acceptBookingConditionsStatus ==
                                  AcceptBookingConditionsStatus.loading
                              ? Colors.grey
                              : AppColors.blue,
                          borderRadius: 30.0.r,
                          addShadow: false,
                          child:
                              controller.acceptBookingConditionsStatus ==
                                  AcceptBookingConditionsStatus.loading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  "موافقة على الشروط",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                      ),
                                ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ConditionSection extends StatelessWidget {
  const ConditionSection({
    super.key,
    required this.titles,
    required this.conditions,
    required this.sectionTitle,
  });

  final List titles;
  final List conditions;
  final String sectionTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(sectionTitle),
        SizedBox(height: 5.0.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 15.0.w),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffD9D9D9)),
            borderRadius: BorderRadius.circular(15.0.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              titles.length,
              (index) => ConditonWidget(
                conditions: conditions[index],
                title: titles[index],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ConditonWidget extends StatelessWidget {
  const ConditonWidget({
    super.key,
    required this.conditions,
    required this.title,
  });

  final String conditions;
  final String title;

  static const List<String> allConditions = ['مجاني', 'غير قابل', 'يوجد رسوم'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 14)),
        SizedBox(height: 10.0.h),
        ...List.generate(
          3,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: 10.0.w),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 10.h,
                      width: 10.w,
                      decoration: BoxDecoration(
                        color: (conditions) == allConditions[index]
                            ? AppColors.blue
                            : Colors.white,
                        border: Border.all(color: AppColors.blue),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 5.0.w),
                    Text(allConditions[index], style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
