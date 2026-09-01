import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/utils/app_format.dart';
import 'package:skygate/features/journey_details/models/journey_route_model.dart';

/// Time, city, terminal and date of one end of the leg.
class JourneyStopColumn extends StatelessWidget {
  const JourneyStopColumn({
    super.key,
    required this.stop,
    required this.showCode,
    required this.alignment,
  });

  final JourneyStopModel? stop;
  final bool showCode;
  final CrossAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = context.locale.languageCode;
    final textAlign = alignment == CrossAxisAlignment.start
        ? TextAlign.start
        : TextAlign.end;

    final code = stop?.code;
    final city = [
      if (stop?.city != null) stop!.city!,
      if (showCode && code != null && code.isNotEmpty) '($code)',
    ].join(' ');

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          AppFormat.time(stop?.at, locale),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: textAlign,
          style: theme.textTheme.titleMedium,
        ),
        Text(
          city,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: textAlign,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          stop?.place ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: textAlign,
          style: theme.textTheme.bodySmall,
        ),
        Text(
          AppFormat.fullDate(stop?.at, locale),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: textAlign,
          style: theme.textTheme.bodySmall?.copyWith(fontSize: 9),
        ),
      ],
    );
  }
}
