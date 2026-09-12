import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/journey_details/models/journey_route_model.dart';

class SegmentPlaceSection extends StatelessWidget {
  const SegmentPlaceSection({
    super.key,
    required this.titleKey,
    required this.place,
  });

  final String titleKey;
  final JourneyPlaceModel? place;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${titleKey.tr()} :',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleLarge,
        ),
        SizedBox(height: 6.s),
        Text(
          place?.name ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        SizedBox(height: 4.s),
        Text(
          place?.description ?? '',
          textAlign: TextAlign.justify,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}
