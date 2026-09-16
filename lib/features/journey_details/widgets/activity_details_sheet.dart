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
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/journey_details/widgets/activity_map_sheet.dart';

class ActivityDetailsSheet extends StatelessWidget {
  const ActivityDetailsSheet({
    super.key,
    required this.activity,
    required this.onConfirm,
  });

  final ActivityModel activity;
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
        padding: EdgeInsets.fromLTRB(20.s, 12.s, 20.s, 20.s),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SheetHandle(),
              Gap(14.s),
              Center(
                child: Text(
                  'activity_details'.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge,
                ),
              ),
              Gap(16.s),
              _Field(
                asset: activity.kind.icon,
                labelKey: 'activity',
                value: activity.title,
              ),
              Gap(12.s),
              Row(
                children: [
                  Expanded(
                    child: _Field(
                      asset: JourneyAssets.clockFrom,
                      labelKey: 'from_hour_label',
                      value: activity.fromTime,
                    ),
                  ),
                  Gap(12.s),
                  Expanded(
                    child: _Field(
                      asset: JourneyAssets.clockTo,
                      labelKey: 'to_hour_label',
                      value: activity.toTime,
                    ),
                  ),
                ],
              ),
              Gap(12.s),
              Divider(height: 1.s),
              Gap(12.s),
              _Place(
                labelKey: 'activity_place',
                value: activity.place,
                asset: JourneyAssets.location,
              ),
              Gap(12.s),
              Divider(height: 1.s),
              Gap(12.s),
              _Place(
                labelKey: 'meeting_point',
                value: activity.meetingPoint,
                asset: JourneyAssets.meetingPoint,
              ),
              Gap(20.s),
              Row(
                children: [
                  if (onConfirm != null) ...[
                    Expanded(
                      child: CustomButton(
                        label: 'confirm_attendance'.tr(),
                        height: 48.s,
                        onPressed: () {
                          Navigator.of(context).pop();
                          onConfirm!();
                        },
                      ),
                    ),
                    Gap(12.s),
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
          height: 42.s,
          width: 42.s,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            shape: BoxShape.circle,
          ),
          child: AppImage(
            asset,
            height: 20.s,
            width: 20.s,
            color: theme.colorScheme.primary,
          ),
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
        Gap(10.s),
        InkWell(
          onTap: () =>
              ActivityMapSheet.show(context, labelKey: labelKey, place: value),
          borderRadius: BorderRadius.circular(12.s),
          child: AspectRatio(
            aspectRatio: 8 / 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.s),
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
