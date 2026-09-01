import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_background.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/app_panel.dart';
import 'package:skygate/core/components/app_title_header.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/constants/auth_assets.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/main/views/main_screen.dart';

/// "تم إنشاء الحساب" — the last card of the signup wizard.
class RegisterSuccessScreen extends StatelessWidget {
  const RegisterSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
            child: Column(
              children: [
                AppTitleHeader(
                  showBack: true,
                  onBack: () => NaivgatorHelper.pushAndRemoveUntilNavigation(
                    context,
                    const MainScreen(),
                  ),
                ),
                const Gap(24),
                AppPanel(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
                  child: Column(
                    children: [
                      Text(
                        'account_created'.tr(),
                        style: theme.textTheme.headlineSmall,
                      ),
                      const Gap(24),
                      const AppImage(AuthAssets.successCheck, height: 250),
                      const Gap(28),
                      CustomButton(
                        label: 'next'.tr(),
                        width: double.infinity,
                        height: 48,
                        onPressed: () =>
                            NaivgatorHelper.pushAndRemoveUntilNavigation(
                              context,
                              const MainScreen(),
                            ),
                      ),
                      const Gap(40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
