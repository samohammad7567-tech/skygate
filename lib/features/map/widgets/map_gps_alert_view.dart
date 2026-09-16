import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_card.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/constants/map_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/map/controller/cubit/map_cubit.dart';

class MapGpsAlertView extends StatelessWidget {
  const MapGpsAlertView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<MapCubit, MapState>(
      builder: (context, state) {
        final cubit = context.read<MapCubit>();

        return ListView(
          padding: EdgeInsets.fromLTRB(20.s, 8.s, 20.s, 120.s),
          children: [
            AppCard(
              padding: EdgeInsets.fromLTRB(18.s, 24.s, 18.s, 22.s),
              radius: 16.s,
              child: Column(
                children: [
                  Container(
                    height: 64.s,
                    width: 64.s,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: AppImage(
                      MapAssets.alert,
                      height: 30.s,
                      width: 30.s,
                      color: AppColors.error,
                    ),
                  ),
                  Gap(18.s),
                  Text(
                    'map_gps_alert_title'.tr(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                  Gap(8.s),
                  Text(
                    'map_gps_alert_desc'.tr(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                  Gap(14.s),
                  Text(
                    cubit.breach?.pilgrimName ?? cubit.user?.fullName ?? '—',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Gap(14.s),
                  _SinceChip(elapsed: cubit.outageFor),
                  Gap(16.s),
                  Text(
                    'map_gps_alert_note'.tr(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                  Gap(16.s),
                  Divider(height: 1.s),
                  Gap(14.s),
                  Text(
                    'map_last_known_location'.tr(),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                  Gap(6.s),
                  Text(
                    _lastPlace(cubit),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            Gap(18.s),
            CustomButton(
              label: 'map_reconnect'.tr(),
              height: 48.s,
              isLoading: state is MapReconnecting,
              onPressed: cubit.reconnect,
              icon: AppImage(
                MapAssets.pin,
                height: 18.s,
                width: 18.s,
                color: theme.colorScheme.onPrimary,
              ),
            ),
            if (state is MapReconnectFailed) ...[
              Gap(12.s),
              Text(
                state.message.tr(),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  String _lastPlace(MapCubit cubit) {
    final named = cubit.breach?.lastLocationText;
    if (named != null && named.isNotEmpty) return named;

    final ping = cubit.lastPing;
    if (ping?.latitude != null && ping?.longitude != null) {
      return '${ping!.latitude}, ${ping.longitude}';
    }
    return 'map_location_unknown'.tr();
  }
}

class _SinceChip extends StatelessWidget {
  const _SinceChip({required this.elapsed});

  final Duration? elapsed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gap = elapsed;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.s, vertical: 6.s),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20.s),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppImage(
            MapAssets.timer,
            height: 14.s,
            width: 14.s,
            color: AppColors.error,
          ),
          Gap(6.s),
          Text(
            gap == null ? 'map_since_unknown'.tr() : _label(gap),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(color: AppColors.error),
          ),
        ],
      ),
    );
  }

  static String _label(Duration gap) {
    if (gap.inHours >= 24) {
      return 'map_since_days'.tr(args: ['${gap.inDays}']);
    }
    if (gap.inMinutes >= 60) {
      return 'map_since_hours'.tr(args: ['${gap.inHours}']);
    }
    return 'map_since_minutes'.tr(args: ['${gap.inMinutes}']);
  }
}
