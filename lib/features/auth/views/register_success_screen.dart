import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_background.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/app_panel.dart';
import 'package:skygate/core/components/app_title_header.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/constants/auth_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/main/views/main_screen.dart';

class RegisterSuccessScreen extends StatelessWidget {
  const RegisterSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(24.s, 32.s, 24.s, 32.s),
            child: Column(
              children: [
                AppTitleHeader(
                  showBack: true,
                  onBack: () => NaivgatorHelper.pushAndRemoveUntilNavigation(
                    context,
                    const MainScreen(),
                  ),
                ),
                Gap(24.s),
                AppPanel(
                  padding: EdgeInsets.fromLTRB(20.s, 28.s, 20.s, 28.s),
                  child: Column(
                    children: [
                      Text(
                        'account_created'.tr(),
                        style: theme.textTheme.headlineSmall,
                      ),
                      Gap(24.s),
                      AppImage(AuthAssets.successCheck, height: 250.vs),
                      Gap(28.s),
                      CustomButton(
                        label: 'next'.tr(),
                        width: double.infinity,
                        height: 48.s,
                        onPressed: () =>
                            NaivgatorHelper.pushAndRemoveUntilNavigation(
                              context,
                              const MainScreen(),
                            ),
                      ),
                      Gap(40.s),
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
