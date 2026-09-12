import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/components/app_list_card.dart';
import 'package:skygate/core/constants/settings_assets.dart';
import 'package:skygate/features/settings/controller/cubit/settings_cubit.dart';
import 'package:skygate/features/settings/models/settings_toggle.dart';
import 'package:skygate/features/settings/widgets/settings_switch_row.dart';

/// "الخصوصية والأمان" — how the reader signs in, and who may see where they
/// are.
class SettingsPrivacySection extends StatelessWidget {
  const SettingsPrivacySection({super.key});

  @override
  Widget build(BuildContext context) {
    // The subscription belongs here rather than to a parent: this section is
    // built `const`, so a rebuild above it is canonicalised away and never
    // reaches these switches. Owning a BlocBuilder means the element repaints
    // on its own whenever the cubit emits, whatever the caller does.
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final cubit = context.read<SettingsCubit>();

        return AppListCard(
          children: [
            SettingsSwitchRow(
              icon: SettingsAssets.biometric,
              title: 'settings_biometric_title'.tr(),
              subtitle: 'settings_biometric_desc'.tr(),
              value: cubit.isOn(SettingsToggle.biometric),
              onChanged: (value) =>
                  cubit.toggle(SettingsToggle.biometric, value),
            ),
            SettingsSwitchRow(
              icon: SettingsAssets.liveLocation,
              title: 'settings_live_location_title'.tr(),
              subtitle: 'settings_live_location_desc'.tr(),
              value: cubit.isOn(SettingsToggle.liveLocation),
              onChanged: (value) =>
                  cubit.toggle(SettingsToggle.liveLocation, value),
            ),
          ],
        );
      },
    );
  }
}
