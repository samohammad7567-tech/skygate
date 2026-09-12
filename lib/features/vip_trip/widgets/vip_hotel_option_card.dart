import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/booking_selectable_card.dart';
import 'package:skygate/core/components/cached_image.dart';
import 'package:skygate/core/components/hotel_summary.dart';
import 'package:skygate/core/constants/vip_trip_assets.dart';
import 'package:skygate/core/models/hotel_model.dart';
import 'package:skygate/core/utils/app_scale.dart';

class VipHotelOptionCard extends StatelessWidget {
  const VipHotelOptionCard({
    super.key,
    required this.hotel,
    required this.isSelected,
    required this.onTap,
  });

  final HotelModel hotel;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return BookingSelectableCard(
      isSelected: isSelected,
      onTap: onTap,
      padding: EdgeInsets.all(10.s),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 4.s),
            child: BookingRadio(isSelected: isSelected),
          ),
          Gap(10.s),
          Expanded(child: HotelSummary(hotel: hotel)),
          Gap(10.s),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.s),
            child: CachedImage(
              url: hotel.image,
              fallbackAsset: VipTripAssets.hotelPhoto,
              height: 116.s,
              width: 124.s,
            ),
          ),
        ],
      ),
    );
  }
}
