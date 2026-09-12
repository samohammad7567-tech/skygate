import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_card.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/constants/map_assets.dart';
import 'package:skygate/core/services/location_service.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/map/controller/cubit/map_cubit.dart';
import 'package:skygate/features/map/models/map_feature_model.dart';
import 'package:skygate/features/map/widgets/map_feature_strip.dart';

class MapProtocolView extends StatelessWidget {
  const MapProtocolView({super.key});

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
              padding: EdgeInsets.zero,
              radius: 16.s,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16.s),
                    ),
                    child: AppImage(
                      MapAssets.protocolShield,
                      height: 190.vs,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(18.s, 4.s, 18.s, 18.s),
                    child: Column(
                      children: [
                        Text(
                          'map_protocol_title'.tr(),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleLarge,
                        ),
                        Gap(10.s),
                        Text(
                          'map_protocol_desc'.tr(),
                          textAlign: TextAlign.center,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.65,
                            ),
                            height: 1.7.s,
                          ),
                        ),
                        Gap(16.s),
                        Divider(height: 1.s),
                        Gap(16.s),
                        const MapFeatureStrip(
                          features: MapFeatureModel.protocol,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Gap(20.s),
            CustomButton(
              label: _label(cubit.access),
              height: 48.s,
              isLoading: state is MapPermissionRequesting,
              onPressed: cubit.acceptProtocol,
            ),
            if (state is MapPermissionDenied) ...[
              Gap(12.s),
              Text(
                _denialCopy(state.access),
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

  String _label(LocationAccess access) => switch (access) {
    LocationAccess.serviceOff => 'map_enable_location_service'.tr(),
    LocationAccess.deniedForever => 'map_open_settings'.tr(),
    _ => 'continue_action'.tr(),
  };

  String _denialCopy(LocationAccess access) => switch (access) {
    LocationAccess.serviceOff => 'map_location_service_off'.tr(),
    LocationAccess.deniedForever => 'map_permission_denied_forever'.tr(),
    _ => 'map_permission_denied'.tr(),
  };
}
