import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_outlined_button.dart';
import 'package:skygate/core/components/app_panel.dart';
import 'package:skygate/core/components/app_text_field.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/components/or_divider.dart';
import 'package:skygate/core/constants/auth_assets.dart';
import 'package:skygate/core/utils/app_phone.dart';
import 'package:skygate/core/utils/app_validators.dart';

/// The white "تسجيل الدخول" card. The same layout serves both credentials —
/// only the identifier field and the two button labels swap.
class LoginCard extends StatelessWidget {
  const LoginCard({
    super.key,
    required this.formKey,
    required this.isPhoneLogin,
    required this.identifierController,
    required this.passwordController,
    required this.obscurePassword,
    required this.isLoading,
    required this.onTogglePassword,
    required this.onForgotPassword,
    required this.onSubmit,
    required this.onSwitchMethod,
  });

  final GlobalKey<FormState> formKey;
  final bool isPhoneLogin;
  final TextEditingController identifierController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool isLoading;
  final VoidCallback onTogglePassword;
  final VoidCallback onForgotPassword;
  final VoidCallback onSubmit;
  final VoidCallback onSwitchMethod;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppPanel(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Text('login_title'.tr(), style: theme.textTheme.headlineSmall),
            const Gap(22),
            AppTextField(
              controller: identifierController,
              hint: isPhoneLogin ? 'phone_number'.tr() : 'email'.tr(),
              icon: isPhoneLogin ? AuthAssets.phone : AuthAssets.mail,
              keyboardType: isPhoneLogin
                  ? TextInputType.phone
                  : TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              inputFormatters: isPhoneLogin ? AppPhone.formatters : null,
              validator: isPhoneLogin
                  ? AppValidators.phone
                  : AppValidators.email,
            ),
            const Gap(12),
            AppTextField(
              controller: passwordController,
              hint: 'password'.tr(),
              icon: AuthAssets.visibility,
              obscureText: obscurePassword,
              onIconTap: onTogglePassword,
              textInputAction: TextInputAction.done,
              validator: AppValidators.password,
            ),
            const Gap(8),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: GestureDetector(
                onTap: onForgotPassword,
                child: Text(
                  'forgot_password'.tr(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const Gap(16),
            CustomButton(
              label: isPhoneLogin
                  ? 'login_with_phone'.tr()
                  : 'login_with_email'.tr(),
              width: double.infinity,
              height: 48,
              isLoading: isLoading,
              onPressed: onSubmit,
            ),
            const Gap(16),
            const OrDivider(),
            const Gap(16),
            AppOutlinedButton(
              label: isPhoneLogin
                  ? 'login_with_email'.tr()
                  : 'login_with_phone'.tr(),
              onPressed: onSwitchMethod,
            ),
          ],
        ),
      ),
    );
  }
}
