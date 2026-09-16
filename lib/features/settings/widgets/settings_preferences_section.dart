import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/components/app_list_card.dart';
import 'package:skygate/core/constants/settings_assets.dart';
import 'package:skygate/features/settings/controller/cubit/settings_cubit.dart';
import 'package:skygate/features/settings/widgets/settings_language_sheet.dart';
import 'package:skygate/features/settings/widgets/settings_tile.dart';

class SettingsPreferencesSection extends StatelessWidget {
  const SettingsPreferencesSection({super.key});

  Future<void> _changeLanguage(BuildContext context) async {
    final cubit = context.read<SettingsCubit>();

    final chosen = await showSettingsLanguageSheet(
      context,
      current: cubit.language,
    );
    if (chosen == null || chosen == cubit.language || !context.mounted) return;
    await context.setLocale(Locale(chosen));
    if (cubit.isClosed) return;
    await cubit.changeLanguage(chosen);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final code = context.read<SettingsCubit>().language;

        return AppListCard(
          children: [
            SettingsTile(
              icon: SettingsAssets.language,
              title: 'settings_language_title'.tr(),
              subtitle: 'settings_language_desc'.tr(),
              value: (settingsLanguages[code] ?? 'settings_language_arabic')
                  .tr(),
              onTap: () => _changeLanguage(context),
            ),
          ],
        );
      },
    );
  }
}
