import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/capture_instructions_card.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/components/form_section_title.dart';
import 'package:skygate/core/components/image_source_sheet.dart';
import 'package:skygate/core/components/passport_fields_form.dart';
import 'package:skygate/core/components/passport_scan_banner.dart';
import 'package:skygate/core/components/toast.dart';
import 'package:skygate/core/constants/profile_assets.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/profile/controller/cubit/profile_cubit.dart';
import 'package:skygate/features/profile/views/passport_scan_screen.dart';
import 'package:skygate/features/profile/widgets/passport_scan_trigger.dart';
import 'package:skygate/features/profile/widgets/profile_form_actions.dart';
import 'package:skygate/features/profile/widgets/profile_scaffold.dart';
import 'package:skygate/core/components/app_section_title.dart';

class EditPassportScreen extends StatefulWidget {
  const EditPassportScreen({super.key});

  @override
  State<EditPassportScreen> createState() => _EditPassportScreenState();
}

class _EditPassportScreenState extends State<EditPassportScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future<void> _scan() async {
    final cubit = context.read<ProfileCubit>();
    final source = await showImageSourceSheet(context);
    if (source == null || !mounted) return;

    NaivgatorHelper.pushNavigation(
      context,
      BlocProvider.value(
        value: cubit,
        child: PassportScanScreen(source: source),
      ),
    );
  }

  void _save() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() != true) return;
    context.read<ProfileCubit>().savePassport();
  }

  void _cancel() {
    context.read<ProfileCubit>().resetPassportForm();
    NaivgatorHelper.popNavigation(context);
  }

  void _onState(BuildContext context, ProfileState state) {
    if (state is PassportSaved) {
      showToast(context, 'passport_saved'.tr());
      NaivgatorHelper.popNavigation(context);
    } else if (state is PassportSaveError) {
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
        final hasVerdict = cubit.isScanned || cubit.scanFailed;

        return ProfileScaffold(
          title: 'edit_account'.tr(),
          onBack: _cancel,
          children: [
            AppSectionTitle(text: 'edit_passport_information'.tr()),
            const Gap(14),
            if (hasVerdict) ...[
              PassportScanBanner(succeeded: cubit.isScanned),
              const Gap(16),
              FormSectionTitle(text: 'confirm_data_below'.tr()),
              const Gap(14),
              PassportScanTrigger(
                caption:
                    (cubit.isScanned
                            ? 'you_can_rescan'
                            : 'you_can_rescan_or_type')
                        .tr(),
                captionFirst: false,
                onTap: _scan,
              ),
            ] else ...[
              PassportScanTrigger(
                caption: 'you_can_use_camera'.tr(),
                onTap: _scan,
              ),
              const Gap(16),
              const CaptureInstructionsCard(),
            ],
            const Gap(16),
            CustomButton(
              label: 'capture_and_read_passport'.tr(),
              height: 48,
              icon: const AppImage(
                ProfileAssets.camera,
                height: 18,
                color: Colors.white,
              ),
              onPressed: _scan,
            ),
            const Gap(18),
            Form(
              key: _formKey,
              child: PassportFieldsForm(
                form: cubit.passportForm,
                labeled: true,
                onChanged: cubit.passportChanged,
              ),
            ),
            const Gap(22),
            ProfileFormActions(
              isSaving: state is PassportSaving,
              onSave: _save,
              onCancel: _cancel,
            ),
          ],
        );
      },
    );
  }
}
