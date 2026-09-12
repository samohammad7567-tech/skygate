import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/app_sheet.dart';
import 'package:skygate/core/components/cached_image.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/components/sheet_handle.dart';
import 'package:skygate/core/constants/journey_assets.dart';

/// One place blown up on its own — the sheet a tap on either map inside
/// [ActivityDetailsSheet] opens, so the pilgrim can read the pin.
class ActivityMapSheet extends StatelessWidget {
  const ActivityMapSheet({
    super.key,
    required this.labelKey,
    required this.place,
    this.mapUrl,
  });

  final String labelKey;
  final String? place;

  /// The rendered map the API publishes for the point. Nothing is fetched
  /// live — the bundled route map stands in until one arrives.
  final String? mapUrl;

  static Future<void> show(
    BuildContext context, {
    required String labelKey,
    required String? place,
    String? mapUrl,
  }) => showAppSheet<void>(
    context,
    builder: (_) =>
        ActivityMapSheet(labelKey: labelKey, place: place, mapUrl: mapUrl),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SheetHandle(),
            const Gap(16),
            Row(
              children: [
                AppImage(
                  JourneyAssets.location,
                  height: 20,
                  width: 20,
                  color: theme.colorScheme.primary,
                ),
                const Gap(10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        labelKey.tr(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall,
                      ),
                      const Gap(2),
                      Text(
                        place ?? '—',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(16),
            AspectRatio(
              aspectRatio: 8 / 5,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedImage(
                  url: mapUrl,
                  fallbackAsset: JourneyAssets.routeMap,
                  width: double.infinity,
                ),
              ),
            ),
            const Gap(20),
            CustomButton(
              label: 'back'.tr(),
              height: 48,
              width: double.infinity,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
