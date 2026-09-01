import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_background.dart';
import 'package:skygate/core/components/app_outlined_button.dart';
import 'package:skygate/core/components/app_panel.dart';
import 'package:skygate/core/components/app_title_header.dart';
import 'package:skygate/core/components/form_section_title.dart';
import 'package:skygate/core/components/image_source_sheet.dart';
import 'package:skygate/core/components/or_divider.dart';
import 'package:skygate/core/components/scan_launcher.dart';
import 'package:skygate/core/components/toast.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/auth/controller/cubit/register_cubit.dart';
import 'package:skygate/features/auth/views/passport_manual_screen.dart';
import 'package:skygate/features/auth/views/passport_scan_screen.dart';
import 'package:skygate/features/auth/widgets/profile_photo_picker.dart';
import 'package:skygate/features/auth/widgets/register_personal_form.dart';
import 'package:skygate/features/auth/widgets/register_stepper.dart';

/// Step 1 of "إنشاء حساب" — personal details, profile photo, and the two ways
/// into the passport step. It owns the [RegisterCubit] the whole wizard shares.
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterCubit(),
      child: const _RegisterBody(),
    );
  }
}

class _RegisterBody extends StatefulWidget {
  const _RegisterBody();

  @override
  State<_RegisterBody> createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<_RegisterBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Both routes into step 2 need complete personal details first.
  bool _validate() {
    FocusScope.of(context).unfocus();
    return _formKey.currentState?.validate() == true;
  }

  Future<void> _pickProfilePhoto() async {
    final cubit = context.read<RegisterCubit>();
    final source = await showImageSourceSheet(context);
    if (source == null) return;
    await cubit.pickProfileImage(source);
  }

  Future<void> _scanPassport() async {
    if (!_validate()) return;
    final cubit = context.read<RegisterCubit>();
    final source = await showImageSourceSheet(context);
    if (source == null || !mounted) return;

    cubit.goToStep(2);
    NaivgatorHelper.pushNavigation(
      context,
      BlocProvider.value(
        value: cubit,
        child: PassportScanScreen(source: source),
      ),
    );
  }

  void _enterManually() {
    if (!_validate()) return;
    final cubit = context.read<RegisterCubit>();
    cubit.goToStep(2);
    NaivgatorHelper.pushNavigation(
      context,
      BlocProvider.value(value: cubit, child: const PassportManualScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: BlocConsumer<RegisterCubit, RegisterState>(
            listener: (context, state) {
              if (state is FileTooLarge) {
                showToast(context, 'file_too_large'.tr(), isError: true);
              }
            },
            builder: (context, state) {
              final cubit = context.read<RegisterCubit>();

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
                child: Column(
                  children: [
                    const AppTitleHeader(showBack: true),
                    const Gap(24),
                    AppPanel(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const RegisterStepper(currentStep: 1),
                            const Gap(20),
                            Text(
                              'create_account'.tr(),
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const Gap(18),
                            FormSectionTitle(
                              text: 'personal_info'.tr(),
                              subtitle: 'add_profile_photo'.tr(),
                            ),
                            const Gap(12),
                            ProfilePhotoPicker(
                              image: cubit.profileImage,
                              onTap: _pickProfilePhoto,
                              onRemove: cubit.removeProfileImage,
                            ),
                            const Gap(18),
                            RegisterPersonalForm(
                              cubit: cubit,
                              onTogglePassword: cubit.togglePasswordVisibility,
                              onToggleConfirmPassword:
                                  cubit.toggleConfirmPasswordVisibility,
                            ),
                            const Gap(20),
                            FormSectionTitle(text: 'passport_info'.tr()),
                            const Gap(18),
                            ScanLauncher(onTap: _scanPassport),
                            const Gap(24),
                            const OrDivider(),
                            const Gap(16),
                            AppOutlinedButton(
                              label: 'manual_entry'.tr(),
                              onPressed: _enterManually,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
