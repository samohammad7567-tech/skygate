import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/components/app_list_card.dart';
import 'package:skygate/core/constants/settings_assets.dart';
import 'package:skygate/features/settings/controller/cubit/settings_cubit.dart';
import 'package:skygate/features/settings/models/settings_toggle.dart';
import 'package:skygate/features/settings/widgets/settings_switch_row.dart';

class SettingsNotificationsSection extends StatelessWidget {
  const SettingsNotificationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final cubit = context.read<SettingsCubit>();

        return AppListCard(
          children: [
            SettingsSwitchRow(
              icon: SettingsAssets.push,
              title: 'settings_push_title'.tr(),
              subtitle: 'settings_push_desc'.tr(),
              value: cubit.isOn(SettingsToggle.push),
              onChanged: (value) => cubit.toggle(SettingsToggle.push, value),
            ),
            SettingsSwitchRow(
              icon: SettingsAssets.geofence,
              title: 'settings_geofence_title'.tr(),
              subtitle: 'settings_geofence_desc'.tr(),
              value: cubit.isOn(SettingsToggle.geofence),
              onChanged: (value) =>
                  cubit.toggle(SettingsToggle.geofence, value),
            ),
            SettingsSwitchRow(
              icon: SettingsAssets.tripUpdates,
              title: 'settings_trip_updates_title'.tr(),
              subtitle: 'settings_trip_updates_desc'.tr(),
              value: cubit.isOn(SettingsToggle.tripUpdates),
              onChanged: (value) =>
                  cubit.toggle(SettingsToggle.tripUpdates, value),
            ),
          ],
        );
      },
    );
  }
}
