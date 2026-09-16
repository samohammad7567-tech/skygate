import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_background.dart';
import 'package:skygate/core/components/app_outlined_button.dart';
import 'package:skygate/core/components/app_title_header.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/components/or_divider.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/auth/views/login_screen.dart';
import 'package:skygate/features/auth/views/register_screen.dart';

class AuthLandingScreen extends StatelessWidget {
  const AuthLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.s),
            child: Column(
              children: [
                Gap(56.s),
                const AppTitleHeader(),
                const Spacer(flex: 3),
                CustomButton(
                  label: 'login'.tr(),
                  width: double.infinity,
                  height: 48.s,
                  onPressed: () => NaivgatorHelper.pushNavigation(
                    context,
                    const LoginScreen(),
                  ),
                ),
                Gap(16.s),
                const OrDivider(),
                Gap(16.s),
                AppOutlinedButton(
                  label: 'create_account'.tr(),
                  onPressed: () => NaivgatorHelper.pushNavigation(
                    context,
                    const RegisterScreen(),
                  ),
                ),
                const Spacer(flex: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
