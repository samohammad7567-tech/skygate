import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_page_header.dart';
import 'package:skygate/core/components/app_section_title.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/settings/controller/cubit/settings_cubit.dart';
import 'package:skygate/features/settings/widgets/settings_about_section.dart';
import 'package:skygate/features/settings/widgets/settings_logout_button.dart';
import 'package:skygate/features/settings/widgets/settings_notifications_section.dart';
import 'package:skygate/features/settings/widgets/settings_preferences_section.dart';
import 'package:skygate/features/settings/widgets/settings_privacy_section.dart';
import 'package:skygate/features/settings/widgets/settings_support_section.dart';

/// The page under "الإعدادات": five titled groups, then تسجيل الخروج.
class SettingsBody extends StatelessWidget {
  const SettingsBody({super.key, this.onMenuTap, this.showBack = false});

  final VoidCallback? onMenuTap;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AppPageHeader(
              title: 'nav_settings'.tr(),
              onMenuTap: onMenuTap,
              showBack: showBack,
            ),
            Expanded(
              // Rebuilt from the cubit so every switch, and the language row,
              // paint the value the cubit now holds.
              child: BlocBuilder<SettingsCubit, SettingsState>(
                builder: (context, state) => ListView(
                  padding: EdgeInsets.fromLTRB(20.s, 8.s, 20.s, 28.s),
                  children: [
                    AppSectionTitle(text: 'notifications'.tr()),
                    Gap(12.s),
                    const SettingsNotificationsSection(),
                    Gap(22.s),
                    AppSectionTitle(text: 'settings_privacy_security'.tr()),
                    Gap(12.s),
                    const SettingsPrivacySection(),
                    Gap(22.s),
                    AppSectionTitle(text: 'settings_preferences'.tr()),
                    Gap(12.s),
                    const SettingsPreferencesSection(),
                    Gap(22.s),
                    AppSectionTitle(text: 'drawer_support_section'.tr()),
                    Gap(12.s),
                    const SettingsSupportSection(),
                    Gap(22.s),
                    AppSectionTitle(text: 'settings_about'.tr()),
                    Gap(12.s),
                    const SettingsAboutSection(),
                    Gap(24.s),
                    const SettingsLogoutButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
