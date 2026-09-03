import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:skygate/tourism/core/theme/app_colors.dart';
import 'package:skygate/tourism/global_widgets/error_panel.dart';
import 'package:skygate/tourism/global_widgets/loading_widget.dart';
import 'package:skygate/tourism/modules/my-trips/views/widgets/trip_widget.dart';

import '../controllers/my_trips_controller.dart';

class MyTripsView extends GetView<MyTripsController> {
  MyTripsView({super.key});
  final myTripsController = Get.find<MyTripsController>();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
          Text(
            "رحلاتي",
            style: context.textTheme.displayLarge!.copyWith(
              color: AppColors.blue,
              fontWeight: FontWeight.w500,
              fontSize: 40.0,
            ),
          ),
          Padding(padding: EdgeInsets.only(bottom: 50.0.h)),
          GetBuilder<MyTripsController>(
              init: myTripsController,
              builder: (myTripsController) {
                if (myTripsController.getTripsDataStatus ==
                        GetTripsDataStatus.initial ||
                    myTripsController.getTripsDataStatus ==
                        GetTripsDataStatus.loading) {
                  return LoadingWidget(
                    color: AppColors.blue,
                    size: 50.0,
                  );
                } else if (myTripsController.getTripsDataStatus ==
                    GetTripsDataStatus.error) {
                  return ErrorPanel(
                    failure: myTripsController.getTripsDataFailure,
                    onTryAgain: () async {
                      await myTripsController.getTripsData();
                    },
                  );
                } else {
                  if (myTripsController.tripsList.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          Icons.find_in_page,
                          color: AppColors.blue,
                          size: 50.0,
                        ),
                        Text(
                          tr("noRecordsFound"),
                          style: context.textTheme.titleMedium,
                        ),
                      ],
                    );
                  } else {
                    return ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                      itemBuilder: (BuildContext context, int index) {
                        return TripWidget(
                          departureCity: myTripsController
                              .tripsList[index].departure_place,
                          arrivalCity:
                              myTripsController.tripsList[index].arrival_place,
                          departureDate:
                              myTripsController.tripsList[index].trip_date,
                          file: myTripsController.tripsList[index].file,
                          filesList:
                              myTripsController.tripsList[index].filesList,
                          index: index,
                          ticketID:
                              myTripsController.tripsList[index].id.toString(),
                          conditions:
                              myTripsController.tripsList[index].conditions,
                          conditions_accepted: myTripsController
                              .tripsList[index].conditions_accepted,
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Padding(
                            padding: EdgeInsets.only(bottom: 30.0.h));
                      },
                      itemCount: myTripsController.tripsList.length,
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                    );
                  }
                }
              }),
        ],
      ),
    );
  }
}
