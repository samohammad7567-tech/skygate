import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/utils/app_scale.dart';

class BookingCriteriaList extends StatelessWidget {
  const BookingCriteriaList({super.key, required this.criteriaKeys});

  final List<String> criteriaKeys;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'booking_terms_criteria'.tr(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        Gap(6.s),
        for (final key in criteriaKeys) ...[
          Text(
            '• ${key.tr()}',
            textAlign: TextAlign.end,
            style: theme.textTheme.bodySmall,
          ),
          Gap(4.s),
        ],
      ],
    );
  }
}
