import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/app_page_header.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/constants/auth_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/main/views/main_screen.dart';

class VipSuccessScreen extends StatelessWidget {
  const VipSuccessScreen({super.key});

  void _home(BuildContext context) =>
      NaivgatorHelper.pushAndRemoveUntilNavigation(context, const MainScreen());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AppPageHeader(
              title: 'confirm_request'.tr(),
              onBack: () => _home(context),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(20.s, 30.s, 20.s, 24.s),
                children: [
                  AppImage(AuthAssets.successCheck, height: 250.vs),
                  Gap(30.s),
                  Text(
                    'congratulations'.tr(),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall,
                  ),
                  Gap(12.s),
                  Text(
                    'private_trip_request_sent'.tr(),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Gap(34.s),
                  CustomButton(
                    label: 'back_to_home'.tr(),
                    width: double.infinity,
                    height: 48.s,
                    onPressed: () => _home(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
