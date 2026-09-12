import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/journey_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';

/// A place on an activity card: the caption, then the address in its tinted
/// box with the pin at the far end.
class ActivityPlaceField extends StatelessWidget {
  const ActivityPlaceField({
    super.key,
    required this.asset,
    required this.labelKey,
    this.value,
  });

  final String asset;
  final String labelKey;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        AppImage(
          asset,
          height: 18.s,
          width: 18.s,
          color: theme.colorScheme.primary,
        ),
        SizedBox(width: 6.s),
        Text(
          labelKey.tr(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        SizedBox(width: 8.s),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.s, vertical: 6.s),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(6.s),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
                SizedBox(width: 6.s),
                AppImage(
                  JourneyAssets.pinpoint,
                  height: 14.s,
                  width: 14.s,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
