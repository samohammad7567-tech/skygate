import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/app_outlined_button.dart';
import 'package:skygate/core/components/app_page_header.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/constants/auth_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/main/views/main_screen.dart';

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
                padding: EdgeInsets.fromLTRB(24.s, 20.s, 24.s, 20.s),
                children: [
                  AppImage(AuthAssets.successCheck, height: 280.vs),
                  Gap(28.s),
                  Text(
                    'congratulations'.tr(),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.headlineSmall,
                  ),
                  Gap(12.s),
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
              padding: EdgeInsets.fromLTRB(20.s, 0, 20.s, 20.s),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      label: 'complete_payment'.tr(),
                      height: 46.s,
                      // Payment is not designed yet; the card closes onto the
                      // home tabs either way.
                      onPressed: () => _finish(context),
                    ),
                  ),
                  Gap(12.s),
                  Expanded(
                    child: AppOutlinedButton(
                      label: 'back_to_home'.tr(),
                      height: 46.s,
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
