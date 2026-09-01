import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/journey_assets.dart';
import 'package:skygate/core/models/booking_type.dart';

/// "حجز فردي" / "حجز مجموعة" chips.
class TripOfferBookingTypes extends StatelessWidget {
  const TripOfferBookingTypes({
    super.key,
    required this.types,
    required this.selectedType,
    required this.onSelected,
  });

  final List<BookingType> types;
  final BookingType? selectedType;
  final ValueChanged<BookingType> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        AppImage(
          JourneyAssets.supervisors,
          height: 20,
          width: 20,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final type in types)
                _BookingTypeChip(
                  type: type,
                  isSelected: type == selectedType,
                  onTap: () => onSelected(type),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BookingTypeChip extends StatelessWidget {
  const _BookingTypeChip({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  final BookingType type;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isSelected
        ? theme.colorScheme.secondary
        : theme.colorScheme.primary;
    final radius = BorderRadius.circular(20);

    return Material(
      color: isSelected
          ? theme.colorScheme.secondary.withValues(alpha: 0.12)
          : theme.colorScheme.surface,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: color),
          ),
          child: Text(
            type.labelKey.tr(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(color: color),
          ),
        ),
      ),
    );
  }
}
