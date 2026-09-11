import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/global_widgets/custom_button.dart';
import 'package:skygate/tourism/modules/change-operation/controllers/change_operation_controller.dart';
import 'package:skygate/tourism/modules/change-operation/views/change_trip_request_details_view.dart';
import 'package:skygate/tourism/modules/change-operation/views/choose_return_trip_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skygate/tourism/core/theme/app_colors.dart';
import 'package:skygate/tourism/modules/change-operation/views/widgets/horizontal_day_selector.dart';
import 'package:skygate/tourism/modules/change-operation/views/widgets/trip_card.dart';

class ChooseDepartureTripView extends GetView<ChangeOperationController> {
  ChooseDepartureTripView({super.key});

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
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(bottom: 15.0.h)),
            // Body Title
            Text(
              "تعديل رحلة",
              style: context.textTheme.titleMedium!.copyWith(
                color: AppColors.blue,
                fontWeight: FontWeight.w500,
                fontSize: 35.0,
              ),
              textAlign: TextAlign.center,
            ),
            // Horizontal Day Selector
            GetBuilder<ChangeOperationController>(
              init: changeOperationController,
              initState: (state) {
                state.controller?.isTripWithinDate(true);
              },
              builder: (changeOperationController) {
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
            Expanded(
              child: GetBuilder<ChangeOperationController>(
                init: changeOperationController,
                builder: (changeOperationController) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          changeOperationController.selectFirstWayTrip(
                            index: index,
                            flightCompanyID: changeOperationController
                                .tripsListFiltered[index].flight_company!.id,
                            tripID: changeOperationController
                                .tripsListFiltered[index].id,
                          );
                        },
                        child: TripCard(
                          arrivalAirport: changeOperationController
                              .tripsListFiltered[index].arrival_airport,
                          arrivalCity: changeOperationController
                              .tripsListFiltered[index].arrival_city,
                          arrivalTime: changeOperationController
                              .tripsListFiltered[index].arrival_time,
                          departureAirport: changeOperationController
                              .tripsListFiltered[index].departure_airport,
                          departureCity: changeOperationController
                              .tripsListFiltered[index].departure_city,
                          departureTime: changeOperationController
                              .tripsListFiltered[index].departure_time,
                          firstWayLevel: changeOperationController
                              .tripsListFiltered[index].first_way_level,
                          tripPrice: changeOperationController.getTripPrice(
                            trip: changeOperationController
                                .tripsListFiltered[index],
                          ),
                          flightCompanyLogo: changeOperationController
                              .tripsListFiltered[index].flight_company!.logo,
                          tripDuration: changeOperationController
                              .tripsListFiltered[index].trip_duration,
                          tripNumber: changeOperationController
                              .tripsListFiltered[index].trip_number,
                          firstTransitCity: changeOperationController
                              .tripsListFiltered[index].first_transit_city,
                          firstTransitAirport: changeOperationController
                              .tripsListFiltered[index].first_transit_airport,
                          secondTransitCity: changeOperationController
                              .tripsListFiltered[index].second_transit_city,
                          secondTransitAirport: changeOperationController
                              .tripsListFiltered[index].second_transit_airport,
                          index: index,
                          isFirstWay: true,
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Padding(padding: EdgeInsets.only(bottom: 10.0.h));
                    },
                    itemCount:
                        changeOperationController.tripsListFiltered.length,
                  );
                },
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
            SizedBox(
              width: 222.0.w,
              child: CustomButton(
                onTap: () {
                  if (changeOperationController.numberOfStages! > 1) {
                    final stringDate =
                        changeOperationController.bookingRequest.return_date;
                    final formattedDate = DateTime.tryParse(stringDate!);
                    changeOperationController.currentDate = formattedDate!;
                    Get.to(() => ChooseReturnTripView());
                  } else {
                    Get.to(() => ChangeTripRequestDetailsView());
                  }
                },
                btnColor: AppColors.blue,
                addShadow: false,
                borderRadius: 20.0.r,
                padding: 5.0.r,
                child: Text(
                  "اختيار",
                  style: context.textTheme.titleSmall!.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
