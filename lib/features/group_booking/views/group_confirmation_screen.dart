import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/app_outlined_button.dart';
import 'package:skygate/core/components/app_page_header.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/constants/auth_assets.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/main/views/main_screen.dart';

/// "تأكيد الحجز" — the last card of the group wizard, shown once the booking
/// has been created and only the first instalment is outstanding.
class GroupConfirmationScreen extends StatelessWidget {
  const GroupConfirmationScreen({super.key});

  void _finish(BuildContext context) =>
      NaivgatorHelper.pushAndRemoveUntilNavigation(context, const MainScreen());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppPageHeader(
              title: 'booking_confirmation'.tr(),
              onBack: () => _finish(context),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                children: [
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
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      label: 'complete_payment'.tr(),
                      height: 46,
                      // Payment is not designed yet; the card closes onto the
                      // home tabs either way.
                      onPressed: () => _finish(context),
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: AppOutlinedButton(
                      label: 'back_to_home'.tr(),
                      height: 46,
                      onPressed: () => _finish(context),
                    ),
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
