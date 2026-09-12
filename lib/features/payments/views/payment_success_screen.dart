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

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  void _finish(BuildContext context) =>
      NaivgatorHelper.pushAndRemoveUntilNavigation(context, const MainScreen());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(24.s, 0, 24.s, 32.s),
          children: [
            AppPageHeader(
              title: 'payment_confirmation'.tr(),
              onBack: () => _finish(context),
            ),
            Gap(40.s),
            AppImage(AuthAssets.successCheck, height: 280.vs),
            Gap(32.s),
            Text(
              'payment_under_review'.tr(),
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall,
            ),
            Gap(40.s),
            CustomButton(
              label: 'back_to_home'.tr(),
              height: 48.s,
              width: double.infinity,
              onPressed: () => _finish(context),
            ),
          ],
        ),
      ),
    );
  }
}
