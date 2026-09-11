import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_text_field.dart';
import 'package:skygate/core/components/image_source_sheet.dart';
import 'package:skygate/core/components/labeled_field.dart';
import 'package:skygate/core/components/toast.dart';
import 'package:skygate/core/constants/profile_assets.dart';
import 'package:skygate/core/utils/app_phone.dart';
import 'package:skygate/core/utils/app_validators.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/profile/controller/cubit/profile_cubit.dart';
import 'package:skygate/features/profile/widgets/profile_form_actions.dart';
import 'package:skygate/features/profile/widgets/profile_photo_field.dart';
import 'package:skygate/features/profile/widgets/profile_scaffold.dart';
import 'package:skygate/features/profile/widgets/profile_section_title.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _pickPhoto() async {
    final cubit = context.read<ProfileCubit>();
    final source = await showImageSourceSheet(context);
    if (source == null) return;
    await cubit.pickProfileImage(source);
  }

  void _save() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() != true) return;
    context.read<ProfileCubit>().saveAccount();
  }

  void _cancel() {
    context.read<ProfileCubit>().resetAccountForm();
    NaivgatorHelper.popNavigation(context);
  }

  void _onState(BuildContext context, ProfileState state) {
    if (state is AccountSaved) {
      showToast(context, 'account_saved'.tr());
      NaivgatorHelper.popNavigation(context);
    } else if (state is AccountSaveError) {
      showToast(context, state.message.tr(), isError: true);
    } else if (state is FileTooLarge) {
      showToast(context, 'file_too_large'.tr(), isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: _onState,
      builder: (context, state) {
        final cubit = context.read<ProfileCubit>();

        return ProfileScaffold(
          title: 'edit_account'.tr(),
          onBack: _cancel,
          children: [
            ProfileSectionTitle(text: 'edit_account_information'.tr()),
            const Gap(14),
            ProfilePhotoField(
              image: cubit.profileImage,
              url: cubit.user?.avatar,
              onTap: _pickPhoto,
              onRemove: cubit.removeProfileImage,
            ),
            const Gap(20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  LabeledField(
                    label: 'username'.tr(),
                    child: AppTextField(
                      controller: cubit.nameController,
                      hint: 'username'.tr(),
                      icon: ProfileAssets.account,
                      textInputAction: TextInputAction.next,
                      validator: AppValidators.required,
                    ),
                  ),
                  const Gap(14),
                  LabeledField(
                    label: 'phone_number'.tr(),
                    child: AppTextField(
                      controller: cubit.phoneController,
                      hint: 'phone_number'.tr(),
                      icon: ProfileAssets.phone,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      inputFormatters: AppPhone.formatters,
                      validator: AppValidators.phone,
                    ),
                  ),
                  const Gap(14),
                  LabeledField(
                    label: 'email'.tr(),
                    child: AppTextField(
                      controller: cubit.emailController,
                      hint: 'email'.tr(),
                      icon: ProfileAssets.mail,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      validator: AppValidators.email,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(22),
            ProfileFormActions(
              isSaving: state is AccountSaving,
              onSave: _save,
              onCancel: _cancel,
            ),
          ],
        );
      },
    );
  }
}
