import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_glyph_plate.dart';
import 'package:skygate/features/booking/models/booking_option_model.dart';
import 'package:skygate/features/booking/widgets/booking_criteria_list.dart';
import 'package:skygate/core/components/booking_selectable_card.dart';

/// One of the two cards on "نوع الحجز": the radio and title strip, the
/// description, then the accepted criteria.
class BookingTypeCard extends StatelessWidget {
  const BookingTypeCard({
    super.key,
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final BookingOptionModel option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BookingSelectableCard(
      isSelected: isSelected,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
            child: Row(
              children: [
                BookingRadio(isSelected: isSelected),
                const Gap(12),
                Expanded(
                  child: Text(
                    option.titleKey.tr(),
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                const Gap(10),
                AppGlyphPlate(asset: option.icon, size: 40, glyphSize: 20),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Text(
              option.descKey.tr(),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
              ),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: BookingCriteriaList(criteriaKeys: option.criteriaKeys),
          ),
        ],
      ),
    );
  }
}
