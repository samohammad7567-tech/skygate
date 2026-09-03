import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_widget/google_maps_widget.dart';
import 'package:sky_gate/app/core/theme/app_colors.dart';
import 'package:sky_gate/app/global_widgets/custom_button.dart';
import 'package:sky_gate/app/global_widgets/custom_dropdown_field.dart';
import 'package:sky_gate/app/global_widgets/error_panel.dart';
import 'package:sky_gate/app/global_widgets/loading_widget.dart';
import '../controllers/airport_map_controller.dart';

class AirportMapView extends GetView<AirportMapController> {
  AirportMapView({super.key});
  final airportMapController = Get.find<AirportMapController>();
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
          "assets/images/big-logo.svg",
          width: 105.0.w,
          height: 47.0.h,
        ),
      ),
      body: GetBuilder<AirportMapController>(
        init: airportMapController,
        builder: (airportMapController) {
          if (airportMapController.prepareMapPageStatus ==
                  PrepareMapPageStatus.loading ||
              airportMapController.getAirportsStatus ==
                  GetAirportsStatus.loading) {
            return Center(
              child: LoadingWidget(
                color: AppColors.blue,
                size: 40.0,
              ),
            );
          } else if (airportMapController.getAirportsStatus ==
              GetAirportsStatus.error) {
            Center(
              child: ErrorPanel(
                failure: airportMapController.getAirportsFailure,
                onTryAgain: () async {
                  await airportMapController.getAirportsData();
                },
              ),
            );
          } else if (airportMapController.getAirportsStatus ==
              GetAirportsStatus.success) {
            return Center(
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(bottom: 60.0.h)),
                  const Text("اختر المطار أولاً لحساب المسافة و الزمن:"),
                  Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
                  // Airport
                  CustomDropdownField(
                    hintText: "المطار",
                    dropDownList: airportMapController.airportsDropdownItems,
                    onChanged: (String? value) {
                      airportMapController.onAirportSelected(value);
                    },
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
                  SizedBox(
                    width: 244.0.w,
                    child: CustomButton(
                      onTap: () async {
                        await airportMapController.getCurrentLocation();
                      },
                      borderRadius: 30.0,
                      btnColor: AppColors.blue,
                      addShadow: false,
                      child: Text(
                        "تأكيد الاختيار",
                        style: context.textTheme.titleSmall!.copyWith(
                            fontSize: 14.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (airportMapController.prepareMapPageStatus ==
              PrepareMapPageStatus.success) {
            return Column(
              children: [
                Expanded(
                  child: GoogleMapsWidget(
                    apiKey: "AIzaSyD0Z3LxcTIyO22wBIku2IIVm4yx5ROu0_M",
                    sourceLatLng: airportMapController.userLocation,
                    destinationLatLng: airportMapController.destinationLocation,
                    totalDistanceCallback: (String? distance) {
                      airportMapController.totalDistance.value = distance!;
                    },
                    totalTimeCallback: (String? time) {
                      airportMapController.totalTime.value = time!;
                      airportMapController.update();
                    },
                  ),
                ),
                Text(
                  "المسافة الكلية = ${airportMapController.totalDistance.value}",
                  style: context.textTheme.titleMedium,
                ),
                Text(
                  "الزمن الكلي = ${airportMapController.totalTime.value}",
                  style: context.textTheme.titleMedium,
                ),
              ],
            );
          } else {
            return Container();
          }
          return Container();
        },
      ),
    );
  }
}
