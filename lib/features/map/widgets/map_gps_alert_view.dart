import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_card.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/constants/map_assets.dart';
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
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
          children: [
            AppCard(
              padding: const EdgeInsets.fromLTRB(18, 24, 18, 22),
              radius: 16,
              child: Column(
                children: [
                  Container(
                    height: 64,
                    width: 64,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: AppImage(
                      MapAssets.alert,
                      height: 30,
                      width: 30,
                      color: AppColors.error,
                    ),
                  ),
                  const Gap(18),
                  Text(
                    'map_gps_alert_title'.tr(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                  const Gap(8),
                  Text(
                    'map_gps_alert_desc'.tr(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                  const Gap(14),
                  Text(
                    cubit.breach?.pilgrimName ?? cubit.user?.fullName ?? '—',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const Gap(14),
                  _SinceChip(elapsed: cubit.outageFor),
                  const Gap(16),
                  Text(
                    'map_gps_alert_note'.tr(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                  const Gap(16),
                  const Divider(height: 1),
                  const Gap(14),
                  Text(
                    'map_last_known_location'.tr(),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                  const Gap(6),
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
            const Gap(18),
            CustomButton(
              label: 'map_reconnect'.tr(),
              height: 48,
              isLoading: state is MapReconnecting,
              onPressed: cubit.reconnect,
              icon: AppImage(
                MapAssets.pin,
                height: 18,
                width: 18,
                color: theme.colorScheme.onPrimary,
              ),
            ),
            if (state is MapReconnectFailed) ...[
              const Gap(12),
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppImage(
            MapAssets.timer,
            height: 14,
            width: 14,
            color: AppColors.error,
          ),
          const Gap(6),
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
