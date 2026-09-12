import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/app_outlined_button.dart';
import 'package:skygate/core/components/app_sheet.dart';
import 'package:skygate/core/components/cached_image.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/components/sheet_handle.dart';
import 'package:skygate/core/constants/journey_assets.dart';
import 'package:skygate/core/models/activity_model.dart';
import 'package:skygate/features/journey_details/widgets/activity_map_sheet.dart';

/// "تفاصيل النشاط" — what the activity is, when it runs, where it happens and
/// where the group gathers, closing on the check-in.
class ActivityDetailsSheet extends StatelessWidget {
  const ActivityDetailsSheet({
    super.key,
    required this.activity,
    required this.onConfirm,
  });

  final ActivityModel activity;

  /// Null once the pilgrim has already checked in — the sheet then closes on
  /// the "إلغاء" button alone.
  final VoidCallback? onConfirm;

  static Future<void> show(
    BuildContext context, {
    required ActivityModel activity,
    required VoidCallback? onConfirm,
  }) => showAppSheet<void>(
    context,
    builder: (_) =>
        ActivityDetailsSheet(activity: activity, onConfirm: onConfirm),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SheetHandle(),
              const Gap(14),
              Center(
                child: Text(
                  'activity_details'.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge,
                ),
              ),
              const Gap(16),
              _Field(
                asset: activity.kind.icon,
                labelKey: 'activity',
                value: activity.title,
              ),
              const Gap(12),
              Row(
                children: [
                  Expanded(
                    child: _Field(
                      asset: JourneyAssets.clockFrom,
                      labelKey: 'from_hour_label',
                      value: activity.fromTime,
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: _Field(
                      asset: JourneyAssets.clockTo,
                      labelKey: 'to_hour_label',
                      value: activity.toTime,
                    ),
                  ),
                ],
              ),
              const Gap(12),
              const Divider(height: 1),
              const Gap(12),
              _Place(
                labelKey: 'activity_place',
                value: activity.place,
                asset: JourneyAssets.location,
              ),
              const Gap(12),
              const Divider(height: 1),
              const Gap(12),
              _Place(
                labelKey: 'meeting_point',
                value: activity.meetingPoint,
                asset: JourneyAssets.meetingPoint,
              ),
              const Gap(20),
              Row(
                children: [
                  if (onConfirm != null) ...[
                    Expanded(
                      child: CustomButton(
                        label: 'confirm_attendance'.tr(),
                        height: 48,
                        onPressed: () {
                          Navigator.of(context).pop();
                          onConfirm!();
                        },
                      ),
                    ),
                    const Gap(12),
                  ],
                  Expanded(
                    child: AppOutlinedButton(
                      label: 'cancel'.tr(),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A plate-and-text line: the round glyph, the caption, and the value.
class _Field extends StatelessWidget {
  const _Field({
    required this.asset,
    required this.labelKey,
    required this.value,
  });

  final String asset;
  final String labelKey;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          height: 42,
          width: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            shape: BoxShape.circle,
          ),
          child: AppImage(
            asset,
            height: 20,
            width: 20,
            color: theme.colorScheme.primary,
          ),
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
                value ?? '—',
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
    );
  }
}

/// A place: the same line, with the map under it that opens on its own.
class _Place extends StatelessWidget {
  const _Place({
    required this.labelKey,
    required this.value,
    required this.asset,
  });

  final String labelKey;
  final String? value;
  final String asset;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Field(asset: asset, labelKey: labelKey, value: value),
        const Gap(10),
        InkWell(
          onTap: () =>
              ActivityMapSheet.show(context, labelKey: labelKey, place: value),
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: 8 / 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: const CachedImage(
                url: null,
                fallbackAsset: JourneyAssets.routeMap,
                width: double.infinity,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
