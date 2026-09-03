import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/global_widgets/custom_button.dart';
import 'package:skygate/tourism/global_widgets/custom_white_outlined_button.dart';
import 'package:skygate/tourism/global_widgets/error_banner.dart';
import 'package:skygate/tourism/global_widgets/loading_widget.dart';
import 'package:skygate/tourism/modules/my-trips-agenda/controllers/my_trips_agenda_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skygate/tourism/core/theme/app_colors.dart';
import 'package:skygate/tourism/global_widgets/gesture_page.dart';
import 'package:skygate/tourism/routes/app_pages.dart';

class ReviewTripView extends GetView<MyTripsAgendaController> {
  ReviewTripView({super.key});

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
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/seko.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(bottom: 15.0.h)),
              // Body Title
              Text(
                "مراجعة الرحلة",
                style: context.textTheme.titleMedium!.copyWith(
                  color: AppColors.blue,
                  fontWeight: FontWeight.w500,
                  fontSize: 30.0,
                ),
                textAlign: TextAlign.center,
              ),
              Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
              // Trip Data
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 376.0.w,
                    height: 484.0.h,
                    padding: EdgeInsets.all(22.0.r),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0.r),
                      ),
                    ),
                    child: Container(
                      width: 332.0.w,
                      height: 444.0.h,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0.w, vertical: 15.0.h),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 1,
                            color: Color(0xFFD9D9D9),
                          ),
                          borderRadius: BorderRadius.circular(10.0.r),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Dep/Arrival Trip Code
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'رحلة الذهاب | الإياب',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF767680),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  height: 1.38,
                                ),
                              ),
                              Text(
                                '${myTripsAgendaController.getTripData(isFirstWay: true).trip_number} | ${myTripsAgendaController.getTripData(isFirstWay: false).trip_number}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF22509E),
                                  fontSize: 16.0,
                                  fontFamily: 'Aileron',
                                  fontWeight: FontWeight.w400,
                                  height: 1.38,
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            color: Color(0xFFD9D9D9),
                            thickness: 1.5,
                          ),
                          // Dep/Arrival Places
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'الوجهة',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF767680),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  height: 1.38,
                                ),
                              ),
                              Text(
                                '${myTripsAgendaController.selectedDeparturePlace} - ${myTripsAgendaController.selectedArrivalPlace}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF22509E),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  height: 1.38,
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            color: Color(0xFFD9D9D9),
                            thickness: 1.5,
                          ),
                          // Departure Date
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'تاريخ الذهاب',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF767680),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  height: 1.38,
                                ),
                              ),
                              Text(
                                '${myTripsAgendaController.departureDateController.text}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF22509E),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  height: 1.38,
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            color: Color(0xFFD9D9D9),
                            thickness: 1.5,
                          ),
                          // First way dep/arrival times
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'إقلاع',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF767680),
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  height: 1.57,
                                ),
                              ),
                              Text(
                                '${myTripsAgendaController.getTripData(isFirstWay: true).departure_time}',
                                style: TextStyle(
                                  color: const Color(0xFF22509E),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  height: 1.38,
                                ),
                              ),
                              Text(
                                'وصول',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF767680),
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  height: 1.57,
                                ),
                              ),
                              Text(
                                '${myTripsAgendaController.getTripData(isFirstWay: true).arrival_time}',
                                style: TextStyle(
                                  color: const Color(0xFF22509E),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  height: 1.38,
                                ),
                              )
                            ],
                          ),
                          const Divider(
                            color: Color(0xFFD9D9D9),
                            thickness: 1.5,
                          ),
                          // second way Date
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'رحلة العودة',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF767680),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  height: 1.38,
                                ),
                              ),
                              Text(
                                '${myTripsAgendaController.returnDateController.text}',
                                style: TextStyle(
                                  color: const Color(0xFF22509E),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  height: 1.38,
                                ),
                              )
                            ],
                          ),
                          const Divider(
                            color: Color(0xFFD9D9D9),
                            thickness: 1.5,
                          ),
                          // Second way dep/arrival times
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'إقلاع',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF767680),
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  height: 1.57,
                                ),
                              ),
                              Text(
                                '${myTripsAgendaController.getTripData(isFirstWay: false).departure_time}',
                                style: TextStyle(
                                  color: const Color(0xFF22509E),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  height: 1.38,
                                ),
                              ),
                              Text(
                                'وصول',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF767680),
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  height: 1.57,
                                ),
                              ),
                              Text(
                                '${myTripsAgendaController.getTripData(isFirstWay: false).arrival_time}',
                                style: TextStyle(
                                  color: const Color(0xFF22509E),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  height: 1.38,
                                ),
                              )
                            ],
                          ),
                          const Divider(
                            color: Color(0xFFD9D9D9),
                            thickness: 1.5,
                          ),
                          // Trip Level
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'الدرجة',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF767680),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  height: 1.38,
                                ),
                              ),
                              Text(
                                '${myTripsAgendaController.getTripData(isFirstWay: true).first_way_level}',
                                style: TextStyle(
                                  color: const Color(0xFF22509E),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  height: 1.38,
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            color: Color(0xFFD9D9D9),
                            thickness: 1.5,
                          ),
                          // Total Trip Cost
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'سعر التذكرة',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF767680),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  height: 1.38,
                                ),
                              ),
                              Text(
                                '${myTripsAgendaController.getTripPriceForTripReview(isFirstWay: true)}',
                                style: TextStyle(
                                  color: const Color(0xFF22509E),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  height: 1.38,
                                ),
                              )
                            ],
                          ),
                          const Divider(
                            color: Color(0xFFD9D9D9),
                            thickness: 1.5,
                          ),
                          // Passengers Numbers Detailed
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${myTripsAgendaController.adults} × بالغ (ذهاب إياب)',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: const Color(0xFF767680),
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w400,
                                  height: 2.20,
                                ),
                              ),
                              Text(
                                '${myTripsAgendaController.children} × طفل',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: const Color(0xFF767680),
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w400,
                                  height: 2.20,
                                ),
                              ),
                              Text(
                                '${myTripsAgendaController.infants} × رضيع',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: const Color(0xFF767680),
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w400,
                                  height: 2.20,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    top: -27,
                    start: 160.0.w,
                    child: Container(
                      height: 60.0.h,
                      width: 70.0.w,
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0.r),
                        boxShadow: const [
                          BoxShadow(
                              offset: Offset(0, 4),
                              spreadRadius: 0.0,
                              blurRadius: 4.0,
                              color: Color(0xFF626270)),
                        ],
                      ),
                      child: CachedNetworkImage(
                        imageUrl: myTripsAgendaController
                            .getTripData(isFirstWay: true)
                            .flight_company!
                            .logo!,
                        width: 60.0.w,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 15.0.h)),
              // Two Buttons Row
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Confirm Button
                    SizedBox(
                      width: 150.0.w,
                      child: CustomButton(
                        onTap: () async {
                          await myTripsAgendaController.submitBookingRequest(
                            regularTripID: myTripsAgendaController
                                .selectedFirstWayTripID
                                .toString(),
                            isRegularTrip: "true",
                          );
                        },
                        btnColor: AppColors.blue,
                        addShadow: false,
                        borderRadius: 30.0.r,
                        padding: 10.0.r,
                        child: GetBuilder<MyTripsAgendaController>(
                          init: myTripsAgendaController,
                          builder: (myTripsAgendaController) {
                            if (myTripsAgendaController
                                    .submitBookingRequestStatus ==
                                SubmitBookingRequestStatus.loading) {
                              return LoadingWidget(
                                size: 25.0,
                                color: Colors.white,
                              );
                            } else if (myTripsAgendaController
                                    .submitBookingRequestStatus ==
                                SubmitBookingRequestStatus.error) {
                              return ErrorBanner(
                                failure: myTripsAgendaController
                                    .submitBookingRequestFailure,
                                tryAgain: () async {
                                  await myTripsAgendaController
                                      .submitBookingRequest(
                                    regularTripID: myTripsAgendaController
                                        .selectedFirstWayTripID
                                        .toString(),
                                    isRegularTrip: "true",
                                  );
                                },
                              );
                            } else {
                              return Text(
                                "تأكيد",
                                style: context.textTheme.titleMedium!.copyWith(
                                  color: Colors.white,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    // Cancel Button
                    SizedBox(
                      width: 150.0.w,
                      child: CustomWhiteOutlinedButton(
                        onTap: () {
                          Get.offAllNamed(Routes.HOME);
                        },
                        addShadow: false,
                        borderColor: AppColors.blue,
                        child: Text(
                          "إلغاء",
                          style: context.textTheme.titleMedium!.copyWith(
                            color: AppColors.blue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 15.0.h)),
              // Important Note
              Text(
                'ملاحظة هامة',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF22509E),
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400,
                  height: 1.10,
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 15.0.h)),
              // Note Text
              SizedBox(
                width: 319.0.w,
                height: 70.0.h,
                child: Text(
                  'السعر  المعروض هو سعر مبدئي وقد يختلف حسب توفر المقاعد. سيتم مراجعة الطلب والتأكد من توفر الرحلات والسعر النهائي خلال دقائق، وسيتم التواصل معك فوراً',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF767680),
                    fontSize: 11.0,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.underline,
                    height: 2,
                  ),
                ),
              )
            ],
          ),
        ),
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}
