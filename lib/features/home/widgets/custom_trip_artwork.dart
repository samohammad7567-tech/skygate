import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/home_assets.dart';
import 'package:skygate/features/home/utils/artwork_plate_clipper.dart';
import 'package:skygate/features/home/widgets/vip_ribbon.dart';

/// Start-side panel of the custom-trip card: the blue plate with the Kaaba
/// photo laid over it, leaving the plate showing as a rim along the curved
/// edge that faces the copy, and the VIP pennant hanging from the top.
class CustomTripArtwork extends StatelessWidget {
  const CustomTripArtwork({super.key});

  /// Width of the blue rim left visible around the photo.
  static const double _rim = 3;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: AppImage(HomeAssets.artworkPlate, fit: BoxFit.fill),
        ),
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.all(_rim),
            child: ClipPath(
              clipper: const ArtworkPlateClipper(),
              child: AppImage(HomeAssets.kaaba, fit: BoxFit.cover),
            ),
          ),
        ),
        const PositionedDirectional(top: 0, start: 18, child: VipRibbon()),
      ],
    );
  }
}
