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

class ChooseDepartureTripView extends GetView<MyTripsAgendaController> {
  ChooseDepartureTripView({super.key});

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
                // Body Title
                Text(
                  "نتائج البحث",
                  style: context.textTheme.titleMedium!.copyWith(
                    color: AppColors.blue,
                    fontWeight: FontWeight.w500,
                    fontSize: 35.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                // Horizontal Day Selector
                GetBuilder<MyTripsAgendaController>(
                  init: myTripsAgendaController,
                  initState: (state) {
                    state.controller?.isTripWithinDate(true);
                  },
                  builder: (myTripsAgendaController) {
                    return HorizontalDaySelector(
                      selectReturnTripPage: false,
                    );
                  },
                ),
                // Choose Departure Trip Text
                Text(
                  "اختيار رحلة الذهاب",
                  style: context.textTheme.titleMedium!.copyWith(
                    color: AppColors.blue,
                    fontWeight: FontWeight.w500,
                    fontSize: 20.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                Padding(padding: EdgeInsets.only(bottom: 10.0.h)),
                // Trips List
                GetBuilder<MyTripsAgendaController>(
                  init: myTripsAgendaController,
                  builder: (myTripsAgendaController) {
                    return SizedBox(
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              myTripsAgendaController.selectFirstWayTrip(
                                index: index,
                                flightCompanyID: myTripsAgendaController
                                    .firstWayTripsFiltered[index]
                                    .flight_company!
                                    .id,
                                tripID: myTripsAgendaController
                                    .firstWayTripsFiltered[index].id,
                              );
                            },
                            child: TripCard(
                              arrivalAirport: myTripsAgendaController
                                  .firstWayTripsFiltered[index].arrival_airport,
                              arrivalCity: myTripsAgendaController
                                  .firstWayTripsFiltered[index].arrival_city,
                              arrivalTime: myTripsAgendaController
                                  .firstWayTripsFiltered[index].arrival_time,
                              departureAirport: myTripsAgendaController
                                  .firstWayTripsFiltered[index]
                                  .departure_airport,
                              departureCity: myTripsAgendaController
                                  .firstWayTripsFiltered[index].departure_city,
                              departureTime: myTripsAgendaController
                                  .firstWayTripsFiltered[index].departure_time,
                              firstWayLevel: myTripsAgendaController
                                  .firstWayTripsFiltered[index].first_way_level,
                              tripPrice: myTripsAgendaController.getTripPrice(
                                trip: myTripsAgendaController
                                    .firstWayTripsFiltered[index],
                              ),
                              flightCompanyLogo: myTripsAgendaController
                                  .firstWayTripsFiltered[index]
                                  .flight_company!
                                  .logo,
                              tripDuration: myTripsAgendaController
                                  .firstWayTripsFiltered[index].trip_duration,
                              tripNumber: myTripsAgendaController
                                  .firstWayTripsFiltered[index].trip_number,
                              firstTransitCity: myTripsAgendaController
                                  .firstWayTripsFiltered[index]
                                  .first_transit_city,
                              firstTransitAirport: myTripsAgendaController
                                  .firstWayTripsFiltered[index]
                                  .first_transit_airport,
                              secondTransitCity: myTripsAgendaController
                                  .firstWayTripsFiltered[index]
                                  .second_transit_city,
                              secondTransitAirport: myTripsAgendaController
                                  .firstWayTripsFiltered[index]
                                  .second_transit_airport,
                              index: index,
                              isFirstWay: true,
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Padding(
                              padding: EdgeInsets.only(bottom: 25.0.h));
                        },
                        itemCount: myTripsAgendaController
                            .firstWayTripsFiltered.length,
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
                          onTap: myTripsAgendaController
                                      .selectedFirstWayCardIndex ==
                                  -1
                              ? null
                              : () {
                                  if (myTripsAgendaController.isOneWay ==
                                      false) {
                                    final stringDate = myTripsAgendaController
                                        .returnDateController.text;
                                    final formattedDate =
                                        DateTime.tryParse(stringDate);
                                    myTripsAgendaController.currentDate =
                                        formattedDate!;
                                    // Populate secondWayTripsFiltered based on return date
                                    myTripsAgendaController
                                        .isTripWithinDate(true);
                                    Get.toNamed(Routes.CHOOSE_RETURN_TRIP);
                                  } else {
                                    Get.toNamed(Routes.REVIEW_TRIP);
                                  }
                                },
                          btnColor: myTripsAgendaController
                                      .selectedFirstWayCardIndex ==
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
                    }),
              ],
            ),
          ),
        ),
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}
