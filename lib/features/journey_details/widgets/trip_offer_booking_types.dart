import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/journey_assets.dart';
import 'package:skygate/core/models/booking_type.dart';
import 'package:skygate/core/utils/app_scale.dart';

class TripOfferBookingTypes extends StatelessWidget {
  const TripOfferBookingTypes({
    super.key,
    required this.types,
    required this.selectedType,
    required this.onSelected,
    this.labels = const {},
  });

  final List<BookingType> types;
  final BookingType? selectedType;
  final ValueChanged<BookingType> onSelected;
  final Map<BookingType, String> labels;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        AppImage(
          JourneyAssets.supervisors,
          height: 20.s,
          width: 20.s,
          color: theme.colorScheme.primary,
        ),
        SizedBox(width: 10.s),
        Expanded(
          child: Wrap(
            spacing: 8.s,
            runSpacing: 8.s,
            children: [
              for (final type in types)
                _BookingTypeChip(
                  label: labels[type] ?? type.labelKey.tr(),
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
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isSelected
        ? theme.colorScheme.secondary
        : theme.colorScheme.primary;
    final radius = BorderRadius.circular(20.s);

    return Material(
      color: isSelected
          ? theme.colorScheme.secondary.withValues(alpha: 0.12)
          : theme.colorScheme.surface,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.s, vertical: 7.s),
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: color),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(color: color),
          ),
        ),
      ),
    );
  }
}
