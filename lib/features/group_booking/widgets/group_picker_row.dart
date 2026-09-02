import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/features/group_booking/models/group_traveler_model.dart';
import 'package:skygate/core/components/audience_chip.dart';

/// One line of "من ترغب بإضافته إلى الغرفة ؟": the traveller with the price
/// they would pay in this room, and the tick that seats them.
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

  /// 1-based place in the group, as the badge prints it.
  final int position;

  final num price;
  final String? currency;

  /// Charged the "الرضيع الثاني" rate, which the pink badge marks.
  final bool isSecondInfant;

  final bool isSelected;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => onChanged(!isSelected),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            PositionBadge(position: position, size: 30),
            const Gap(12),
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
                        const Gap(6),
                        const SecondInfantBadge(),
                      ],
                    ],
                  ),
                  const Gap(4),
                  Row(
                    children: [
                      Text(
                        '$price${currency ?? ''}',
                        maxLines: 1,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                      const Gap(10),
                      AudienceChip(audience: traveler.audience),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(10),
            SizedBox(
              height: 24,
              width: 24,
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
