import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_card.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/constants/map_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/sos/utils/open_trip_chat.dart';

/// The trip is `almost-done`: the server refuses location pings from here on,
/// but the group chat stays open until the trip is completed or cancelled.
///
/// The two features close at different moments by design, so this screen says
/// tracking has stopped without claiming the trip is over.
class MapWrappingUpView extends StatelessWidget {
  const MapWrappingUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                  color: AppColors.accent.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: AppImage(
                  MapAssets.timer,
                  height: 28.s,
                  width: 28.s,
                  color: AppColors.accent,
                ),
              ),
              Gap(18.s),
              Text(
                'map_wrapping_up_title'.tr(),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge,
              ),
              Gap(8.s),
              Text(
                'map_wrapping_up_desc'.tr(),
                textAlign: TextAlign.center,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall,
              ),
              Gap(18.s),
              CustomButton(
                label: 'map_wrapping_up_open_chat'.tr(),
                height: 48.s,
                onPressed: () => openTripChat(context),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
