import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_list_card.dart';
import 'package:skygate/core/components/coming_soon_view.dart';
import 'package:skygate/core/constants/app_info.dart';
import 'package:skygate/core/constants/settings_assets.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/settings/widgets/settings_tile.dart';

/// "حول" — the build the reader is on, and the two legal pages.
class SettingsAboutSection extends StatelessWidget {
  const SettingsAboutSection({super.key});

  void _openSoon(BuildContext context, String titleKey) {
    NaivgatorHelper.pushNavigation(context, ComingSoonView(titleKey: titleKey));
  }

  @override
  Widget build(BuildContext context) {
    return AppListCard(
      children: [
        SettingsTile(
          icon: SettingsAssets.version,
          title: 'settings_version_title'.tr(),
          // Nowhere to go — the row states the build and draws no chevron.
          value: 'v${AppInfo.version}',
        ),
        SettingsTile(
          icon: SettingsAssets.privacy,
          title: 'privacy-policy'.tr(),
          onTap: () => _openSoon(context, 'privacy-policy'),
        ),
        SettingsTile(
          icon: SettingsAssets.terms,
          title: 'settings_terms_title'.tr(),
          onTap: () => _openSoon(context, 'settings_terms_title'),
        ),
      ],
    );
  }
}
