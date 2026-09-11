import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/booking_selectable_card.dart';
import 'package:skygate/core/components/cached_image.dart';
import 'package:skygate/core/components/hotel_summary.dart';
import 'package:skygate/core/constants/vip_trip_assets.dart';
import 'package:skygate/core/models/hotel_model.dart';

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
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: BookingRadio(isSelected: isSelected),
          ),
          const Gap(10),
          Expanded(child: HotelSummary(hotel: hotel)),
          const Gap(10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedImage(
              url: hotel.image,
              fallbackAsset: VipTripAssets.hotelPhoto,
              height: 116,
              width: 124,
            ),
          ),
        ],
      ),
    );
  }
}
