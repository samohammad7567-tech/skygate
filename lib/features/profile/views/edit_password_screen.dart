import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_text_field.dart';
import 'package:skygate/core/components/labeled_field.dart';
import 'package:skygate/core/components/toast.dart';
import 'package:skygate/core/constants/profile_assets.dart';
import 'package:skygate/core/utils/app_validators.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/profile/controller/cubit/profile_cubit.dart';
import 'package:skygate/features/profile/widgets/profile_form_actions.dart';
import 'package:skygate/features/profile/widgets/profile_scaffold.dart';
import 'package:skygate/features/profile/widgets/profile_section_title.dart';

class EditPasswordScreen extends StatefulWidget {
  const EditPasswordScreen({super.key});

  @override
  State<EditPasswordScreen> createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _save() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() != true) return;
    context.read<ProfileCubit>().changePassword();
  }

  void _cancel() {
    context.read<ProfileCubit>().clearPasswordForm();
    NaivgatorHelper.popNavigation(context);
  }

  void _onState(BuildContext context, ProfileState state) {
    if (state is PasswordSaved) {
      showToast(context, 'password_changed'.tr());
      NaivgatorHelper.popNavigation(context);
    } else if (state is PasswordSaveError) {
      showToast(context, state.message.tr(), isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: _onState,
      builder: (context, state) {
        final cubit = context.read<ProfileCubit>();

        return ProfileScaffold(
          title: 'edit_password'.tr(),
          onBack: _cancel,
          children: [
            ProfileSectionTitle(text: 'edit_password'.tr()),
            const Gap(14),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  LabeledField(
                    label: 'current_password'.tr(),
                    child: AppTextField(
                      controller: cubit.currentPasswordController,
                      hint: 'current_password'.tr(),
                      icon: ProfileAssets.lock,
                      obscureText: cubit.obscureCurrentPassword,
                      textInputAction: TextInputAction.next,
                      onIconTap: cubit.toggleCurrentPasswordVisibility,
                      validator: AppValidators.required,
                    ),
                  ),
                  const Gap(14),
                  LabeledField(
                    label: 'new_password_label'.tr(),
                    child: AppTextField(
                      controller: cubit.newPasswordController,
                      hint: 'new_password_label'.tr(),
                      icon: ProfileAssets.lock,
                      obscureText: cubit.obscureNewPassword,
                      textInputAction: TextInputAction.next,
                      onIconTap: cubit.toggleNewPasswordVisibility,
                      validator: AppValidators.password,
                    ),
                  ),
                  const Gap(14),
                  LabeledField(
                    label: 'confirm_new_password_label'.tr(),
                    child: AppTextField(
                      controller: cubit.confirmPasswordController,
                      hint: 'new_password_label'.tr(),
                      icon: ProfileAssets.lock,
                      obscureText: cubit.obscureConfirmPassword,
                      textInputAction: TextInputAction.done,
                      onIconTap: cubit.toggleConfirmPasswordVisibility,
                      validator: (value) => AppValidators.confirmPassword(
                        value,
                        cubit.newPasswordController.text,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(22),
            ProfileFormActions(
              isSaving: state is PasswordSaving,
              onSave: _save,
              onCancel: _cancel,
            ),
          ],
        );
      },
    );
  }
}
