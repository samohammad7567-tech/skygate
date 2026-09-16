import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/global_widgets/custom_button.dart';
import 'package:skygate/tourism/modules/my-trips-agenda/controllers/my_trips_agenda_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skygate/tourism/core/theme/app_colors.dart';
import 'package:skygate/tourism/global_widgets/gesture_page.dart';
import 'package:skygate/tourism/modules/my-trips-agenda/views/widgets/horizontal_day_selector.dart';
import 'package:skygate/tourism/modules/my-trips-agenda/views/widgets/trip_card.dart';
import 'package:skygate/tourism/routes/app_pages.dart';

class ChooseReturnTripView extends GetView<MyTripsAgendaController> {
  ChooseReturnTripView({super.key});

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
                Padding(padding: EdgeInsets.only(bottom: 15.0.h)),
                Text(
                  "نتائج البحث",
                  style: context.textTheme.titleMedium!.copyWith(
                    color: AppColors.blue,
                    fontWeight: FontWeight.w500,
                    fontSize: 35.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                GetBuilder<MyTripsAgendaController>(
                  init: myTripsAgendaController,
                  initState: (state) {
                    state.controller?.isTripWithinDate(true);
                  },
                  builder: (myTripsAgendaController) {
                    return HorizontalDaySelector(selectReturnTripPage: true);
                  },
                ),
                Text(
                  "اختيار رحلة الإياب",
                  style: context.textTheme.titleMedium!.copyWith(
                    color: AppColors.blue,
                    fontWeight: FontWeight.w500,
                    fontSize: 20.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                Padding(padding: EdgeInsets.only(bottom: 10.0.h)),
                GetBuilder<MyTripsAgendaController>(
                  init: myTripsAgendaController,
                  builder: (myTripsAgendaController) {
                    return SizedBox(
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              myTripsAgendaController.selectSecondWayTrip(
                                index: index,
                                tripID: myTripsAgendaController
                                    .secondWayTripsFiltered[index]
                                    .id,
                              );
                            },
                            child: TripCard(
                              arrivalAirport: myTripsAgendaController
                                  .secondWayTripsFiltered[index]
                                  .arrival_airport,
                              arrivalCity: myTripsAgendaController
                                  .secondWayTripsFiltered[index]
                                  .arrival_city,
                              arrivalTime: myTripsAgendaController
                                  .secondWayTripsFiltered[index]
                                  .arrival_time,
                              departureAirport: myTripsAgendaController
                                  .secondWayTripsFiltered[index]
                                  .departure_airport,
                              departureCity: myTripsAgendaController
                                  .secondWayTripsFiltered[index]
                                  .departure_city,
                              departureTime: myTripsAgendaController
                                  .secondWayTripsFiltered[index]
                                  .departure_time,
                              firstWayLevel: myTripsAgendaController
                                  .secondWayTripsFiltered[index]
                                  .second_way_level,
                              tripPrice: myTripsAgendaController.getTripPrice(
                                trip: myTripsAgendaController
                                    .secondWayTripsFiltered[index],
                              ),
                              flightCompanyLogo: myTripsAgendaController
                                  .secondWayTripsFiltered[index]
                                  .flight_company!
                                  .logo,
                              tripDuration: myTripsAgendaController
                                  .secondWayTripsFiltered[index]
                                  .trip_duration,
                              tripNumber: myTripsAgendaController
                                  .secondWayTripsFiltered[index]
                                  .trip_number,
                              firstTransitCity: myTripsAgendaController
                                  .secondWayTripsFiltered[index]
                                  .second_transit_city,
                              firstTransitAirport: myTripsAgendaController
                                  .secondWayTripsFiltered[index]
                                  .second_transit_airport,
                              secondTransitCity: myTripsAgendaController
                                  .secondWayTripsFiltered[index]
                                  .first_transit_city,
                              secondTransitAirport: myTripsAgendaController
                                  .secondWayTripsFiltered[index]
                                  .first_transit_airport,
                              index: index,
                              isFirstWay: false,
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 25.0.h),
                          );
                        },
                        itemCount: myTripsAgendaController
                            .secondWayTripsFiltered
                            .length,
                      ),
                    );
                  },
                ),
                Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
                GetBuilder<MyTripsAgendaController>(
                  init: myTripsAgendaController,
                  builder: (myTripsAgendaController) {
                    return SizedBox(
                      width: 222.0.w,
                      child: CustomButton(
                        onTap:
                            myTripsAgendaController
                                    .selectedSecondWayCardIndex ==
                                -1
                            ? null
                            : () {
                                Get.toNamed(Routes.REVIEW_TRIP);
                              },
                        btnColor:
                            myTripsAgendaController
                                    .selectedSecondWayCardIndex ==
                                -1
                            ? AppColors.greyMedium
                            : AppColors.blue,
                        addShadow: false,
                        borderRadius: 20.0.r,
                        padding: 5.0.r,
                        child: Text(
                          "متابعة",
                          style: context.textTheme.titleSmall!.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
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
