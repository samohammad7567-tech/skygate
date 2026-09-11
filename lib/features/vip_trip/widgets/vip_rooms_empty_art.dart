import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/vip_trip_assets.dart';

class VipRoomsEmptyArt extends StatelessWidget {
  const VipRoomsEmptyArt({super.key});
  static const double _width = 260;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: _width,
        height: _width * 0.86,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Positioned(
              top: 0,
              child: AppImage(VipTripAssets.emptyRoomsLamp, height: 74),
            ),
            const Align(
              alignment: Alignment(0, 0.35),
              child: AppImage(VipTripAssets.emptyRooms, width: _width),
            ),
            const Align(
              alignment: Alignment(-0.92, 0.92),
              child: AppImage(VipTripAssets.emptyRoomsPlant, height: 34),
            ),
            const Align(
              alignment: Alignment(0.34, -0.24),
              child: AppImage(VipTripAssets.info, height: 30),
            ),
          ],
        ),
      ),
    );
  }
}
