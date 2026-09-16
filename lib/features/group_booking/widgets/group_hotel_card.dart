import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/cached_image.dart';
import 'package:skygate/core/constants/journey_assets.dart';
import 'package:skygate/core/models/hotel_model.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/group_booking/models/group_room_allocation.dart';
import 'package:skygate/core/components/hotel_summary.dart';
import 'package:skygate/features/group_booking/widgets/group_room_chip.dart';

class GroupHotelCard extends StatelessWidget {
  const GroupHotelCard({
    super.key,
    required this.hotel,
    required this.allocation,
    required this.onAllocate,
  });

  final HotelModel hotel;
  final GroupRoomAllocation allocation;
  final VoidCallback onAllocate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(10.s),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14.s),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: HotelSummary(hotel: hotel)),
              Gap(10.s),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.s),
                child: CachedImage(
                  url: hotel.image,
                  fallbackAsset: JourneyAssets.hotelPhoto,
                  height: 116.s,
                  width: 124.s,
                ),
              ),
            ],
          ),
          Gap(10.s),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: _AllocateButton(
              isAllocated: !allocation.isEmpty,
              onTap: onAllocate,
            ),
          ),
          if (!allocation.isEmpty) ...[
            Gap(10.s),
            Divider(height: 1.s),
            Gap(10.s),
            GroupRoomChips(allocation: allocation),
          ],
        ],
      ),
    );
  }
}

class _AllocateButton extends StatelessWidget {
  const _AllocateButton({required this.isAllocated, required this.onTap});

  final bool isAllocated;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(
        isAllocated ? Icons.edit_outlined : Icons.add_circle_outline,
        size: 18.s,
        color: theme.colorScheme.primary,
      ),
      label: Text(
        isAllocated ? 'edit'.tr() : 'add_rooms_to_hotel'.tr(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: theme.colorScheme.primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.s),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.s, vertical: 8.s),
      ),
    );
  }
}
