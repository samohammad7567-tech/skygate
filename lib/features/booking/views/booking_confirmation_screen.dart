import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/app_page_header.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/constants/auth_assets.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/main/views/main_screen.dart';

/// "تأكيد الحجز" — the last card of the wizard, shown once the booking has
/// been created and only the first instalment is outstanding.
class BookingConfirmationScreen extends StatelessWidget {
  const BookingConfirmationScreen({super.key});

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
              title: 'booking_confirmation'.tr(),
              onBack: () => _finish(context),
            ),
            const Gap(40),
            const AppImage(AuthAssets.successCheck, height: 280),
            const Gap(28),
            Text(
              'congratulations'.tr(),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.headlineSmall,
            ),
            const Gap(12),
            Text(
              'booking_saved_note'.tr(),
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const Gap(36),
            CustomButton(
              label: 'next'.tr(),
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
