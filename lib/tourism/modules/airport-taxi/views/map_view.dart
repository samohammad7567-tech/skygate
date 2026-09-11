import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:skygate/tourism/modules/airport-taxi/controllers/airport_taxi_controller.dart';

class MapView extends GetView<AirportTaxiController> {
  final airportTaxiController = Get.find<AirportTaxiController>();

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
        child: GetBuilder<AirportTaxiController>(
          init: airportTaxiController,
          builder: (airportTaxiController) {
            return Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: 700.0.h,
                      child: GoogleMap(
                        initialCameraPosition: airportTaxiController.kQatar,
                        onMapCreated: (controller) =>
                            airportTaxiController.mapController = controller,
                        onCameraMove: (CameraPosition position) async {
                          await airportTaxiController.onMapMove(position);
                        },
                        myLocationEnabled: true, // Show user's current location
                        myLocationButtonEnabled: true,
                      ),
                    ),
                    PositionedDirectional(
                      top: 350.0.h,
                      start: (1 * 1.sw) / 2,
                      child: Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 48.0,
                      ),
                    ),
                  ],
                ),
                Text(
                  airportTaxiController.selectedLocationAddress!,
                  style: context.textTheme.titleMedium,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
