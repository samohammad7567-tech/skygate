import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/app_page_header.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/constants/auth_assets.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/main/views/main_screen.dart';

/// "تأكيد الدفع" — the card shown once a transfer has been filed.
///
/// It says the transfer is *under review*, not that it was accepted: the app
/// never confirms a payment itself, the back office does, and the transaction
/// comes back `pending` until it has.
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
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          children: [
            AppPageHeader(
              title: 'payment_confirmation'.tr(),
              onBack: () => _finish(context),
            ),
            const Gap(40),
            const AppImage(AuthAssets.successCheck, height: 280),
            const Gap(32),
            Text(
              'payment_under_review'.tr(),
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall,
            ),
            const Gap(40),
            CustomButton(
              label: 'back_to_home'.tr(),
              height: 48,
              width: double.infinity,
              onPressed: () => _finish(context),
            ),
          ],
        ),
      ),
    );
  }
}
