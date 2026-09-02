import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_text_field.dart';
import 'package:skygate/core/constants/auth_assets.dart';
import 'package:skygate/core/utils/app_phone.dart';
import 'package:skygate/core/utils/app_validators.dart';
import 'package:skygate/features/auth/controller/cubit/register_cubit.dart';

/// The five personal-detail fields on step 1 of the signup wizard.
class RegisterPersonalForm extends StatelessWidget {
  const RegisterPersonalForm({
    super.key,
    required this.cubit,
    required this.onTogglePassword,
    required this.onToggleConfirmPassword,
  });

  /// Read for its controllers and obscure flags only; taps are forwarded back
  /// through the callbacks so the widget stays dumb.
  final RegisterCubit cubit;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirmPassword;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          controller: cubit.nameController,
          hint: 'full_name_triple'.tr(),
          icon: AuthAssets.profile,
          textInputAction: TextInputAction.next,
          validator: AppValidators.required,
        ),
        const Gap(12),
        AppTextField(
          controller: cubit.phoneController,
          hint: 'phone_number'.tr(),
          icon: AuthAssets.phone,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          inputFormatters: AppPhone.formatters,
          validator: AppValidators.phone,
        ),
        const Gap(12),
        AppTextField(
          controller: cubit.emailController,
          hint: 'email'.tr(),
          icon: AuthAssets.mail,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: AppValidators.email,
        ),
        const Gap(12),
        AppTextField(
          controller: cubit.passwordController,
          hint: 'password'.tr(),
          icon: AuthAssets.visibility,
          obscureText: cubit.obscurePassword,
          onIconTap: onTogglePassword,
          textInputAction: TextInputAction.next,
          validator: AppValidators.password,
        ),
        const Gap(12),
        AppTextField(
          controller: cubit.confirmPasswordController,
          hint: 'confirm_password'.tr(),
          icon: AuthAssets.visibility,
          obscureText: cubit.obscureConfirmPassword,
          onIconTap: onToggleConfirmPassword,
          textInputAction: TextInputAction.done,
          validator: (value) => AppValidators.confirmPassword(
            value,
            cubit.passwordController.text,
          ),
        ),
      ],
    );
  }
}
