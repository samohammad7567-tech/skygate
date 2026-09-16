import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_glyph_plate.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/booking/models/booking_option_model.dart';
import 'package:skygate/features/booking/widgets/booking_criteria_list.dart';
import 'package:skygate/core/components/booking_selectable_card.dart';

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
            padding: EdgeInsets.fromLTRB(14.s, 14.s, 14.s, 12.s),
            child: Row(
              children: [
                AppGlyphPlate(asset: option.icon, size: 40.s, glyphSize: 20.s),
                Gap(12.s),
                Text(
                  option.titleKey.tr(),
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge,
                ),
                Spacer(),
                BookingRadio(isSelected: isSelected),
              ],
            ),
          ),
          Divider(height: 1.s),
          Padding(
            padding: EdgeInsets.fromLTRB(14.s, 12.s, 14.s, 12.s),
            child: Text(
              option.descKey.tr(),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
              ),
            ),
          ),
          Divider(height: 1.s),
          Padding(
            padding: EdgeInsets.fromLTRB(14.s, 12.s, 14.s, 14.s),
            child: BookingCriteriaList(criteriaKeys: option.criteriaKeys),
          ),
        ],
      ),
    );
  }
}
