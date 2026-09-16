import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/toast.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/constants/map_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/sos/models/sos_option_model.dart';
import 'package:skygate/features/sos/utils/open_trip_chat.dart';
import 'package:url_launcher/url_launcher.dart';

/// Shown while the pilgrim reads as outside every active safe area.
///
/// The verdict behind it is computed on the device purely so the warning is
/// immediate. The server is the authority: it decides on each ping, notifies
/// the pilgrim, and alerts the leader and admins. This banner raises nothing on
/// its own — it only offers the two ways out.
class MapSafeAreaBanner extends StatelessWidget {
  const MapSafeAreaBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.fromLTRB(16.s, 8.s, 16.s, 0),
      padding: EdgeInsets.fromLTRB(14.s, 12.s, 14.s, 10.s),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14.s),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              AppImage(
                MapAssets.alert,
                height: 18.s,
                width: 18.s,
                color: AppColors.error,
              ),
              Gap(8.s),
              Expanded(
                child: Text(
                  'map_outside_safe_area'.tr(),
                  textAlign: TextAlign.start,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ),
            ],
          ),
          Gap(4.s),
          Text(
            'map_outside_safe_area_desc'.tr(),
            textAlign: TextAlign.start,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
          Gap(8.s),
          Row(
            children: [
              Expanded(
                child: _Action(
                  labelKey: 'map_outside_open_chat',
                  onTap: () => openTripChat(context),
                ),
              ),
              Gap(8.s),
              Expanded(
                child: _Action(
                  labelKey: 'map_outside_call_leader',
                  onTap: () => _dial(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _dial(BuildContext context) async {
    final launched = await launchUrl(SosContacts.dialUri);
    if (!launched && context.mounted) {
      showToast(context, 'sos_call_failed'.tr(), isError: true);
    }
  }
}

class _Action extends StatelessWidget {
  const _Action({required this.labelKey, required this.onTap});

  final String labelKey;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(10.s),
      child: InkWell(
        borderRadius: BorderRadius.circular(10.s),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.s, horizontal: 8.s),
          child: Text(
            labelKey.tr(),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(color: AppColors.error),
          ),
        ),
      ),
    );
  }
}
