import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/app_sheet.dart';
import 'package:skygate/core/components/cached_image.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/components/sheet_handle.dart';
import 'package:skygate/core/constants/journey_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';

class ActivityMapSheet extends StatelessWidget {
  const ActivityMapSheet({
    super.key,
    required this.labelKey,
    required this.place,
    this.mapUrl,
  });

  final String labelKey;
  final String? place;
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
        padding: EdgeInsets.fromLTRB(20.s, 12.s, 20.s, 20.s),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SheetHandle(),
            Gap(16.s),
            Row(
              children: [
                AppImage(
                  JourneyAssets.location,
                  height: 20.s,
                  width: 20.s,
                  color: theme.colorScheme.primary,
                ),
                Gap(10.s),
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
                      Gap(2.s),
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
            Gap(16.s),
            AspectRatio(
              aspectRatio: 8 / 5,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.s),
                child: CachedImage(
                  url: mapUrl,
                  fallbackAsset: JourneyAssets.routeMap,
                  width: double.infinity,
                ),
              ),
            ),
            Gap(20.s),
            CustomButton(
              label: 'back'.tr(),
              height: 48.s,
              width: double.infinity,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
