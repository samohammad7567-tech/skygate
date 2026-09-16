import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/group_booking/models/group_traveler_model.dart';
import 'package:skygate/core/components/audience_chip.dart';

class GroupPickerRow extends StatelessWidget {
  const GroupPickerRow({
    super.key,
    required this.traveler,
    required this.position,
    required this.price,
    required this.currency,
    required this.isSecondInfant,
    required this.isSelected,
    required this.onChanged,
  });

  final GroupTravelerModel traveler;
  final int position;

  final num price;
  final String? currency;
  final bool isSecondInfant;

  final bool isSelected;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => onChanged(!isSelected),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.s),
        child: Row(
          children: [
            PositionBadge(position: position, size: 30.s),
            Gap(12.s),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          traveler.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      if (isSecondInfant) ...[
                        Gap(6.s),
                        const SecondInfantBadge(),
                      ],
                    ],
                  ),
                  Gap(4.s),
                  Row(
                    children: [
                      Text(
                        '$price${currency ?? ''}',
                        maxLines: 1,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                      Gap(10.s),
                      AudienceChip(audience: traveler.audience),
                    ],
                  ),
                ],
              ),
            ),
            Gap(10.s),
            SizedBox(
              height: 24.s,
              width: 24.s,
              child: Checkbox(
                value: isSelected,
                onChanged: (value) => onChanged(value ?? false),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
