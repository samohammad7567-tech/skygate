import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/utils/app_format.dart';

/// "مدة الرحلة: 2س 15د" — the orange line under a leg.
class JourneyDurationRow extends StatelessWidget {
  const JourneyDurationRow({super.key, required this.minutes});

  final int? minutes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Text(
          '${'trip_duration'.tr()}: ',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall,
        ),
        Flexible(
          child: Text(
            AppFormat.duration(minutes),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.secondary,
            ),
          ),
        ),
      ],
    );
  }
}
