import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/journey_assets.dart';

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
          height: 18,
          width: 18,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 6),
        Text(
          labelKey.tr(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(6),
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
                const SizedBox(width: 6),
                AppImage(
                  JourneyAssets.pinpoint,
                  height: 14,
                  width: 14,
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
