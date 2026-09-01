import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_background.dart';
import 'package:skygate/core/components/app_outlined_button.dart';
import 'package:skygate/core/components/app_panel.dart';
import 'package:skygate/core/components/app_title_header.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/components/form_section_title.dart';
import 'package:skygate/core/components/passport_fields_form.dart';
import 'package:skygate/core/components/passport_success_banner.dart';
import 'package:skygate/core/components/scan_launcher.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/auth/controller/cubit/register_cubit.dart';
import 'package:skygate/features/auth/views/umrah_documents_screen.dart';
import 'package:skygate/features/auth/widgets/register_stepper.dart';

/// Step 2 (scanned path) — "تأكيد بيانات الجواز".
class PassportConfirmScreen extends StatefulWidget {
  const PassportConfirmScreen({super.key});

  @override
  State<PassportConfirmScreen> createState() => _PassportConfirmScreenState();
}

class _PassportConfirmScreenState extends State<PassportConfirmScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _rescan() {
    context.read<RegisterCubit>().resetScan();
    NaivgatorHelper.popNavigation(context);
  }

  void _continue() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() != true) return;

    final cubit = context.read<RegisterCubit>();
    cubit.goToStep(3);
    NaivgatorHelper.pushNavigation(
      context,
      BlocProvider.value(value: cubit, child: const UmrahDocumentsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: BlocBuilder<RegisterCubit, RegisterState>(
            builder: (context, state) {
              final cubit = context.read<RegisterCubit>();

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
                child: Column(
                  children: [
                    AppTitleHeader(
                      title: 'confirm_passport_data'.tr(),
                      showBack: true,
                    ),
                    const Gap(24),
                    AppPanel(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const RegisterStepper(currentStep: 2),
                            const Gap(18),
                            if (cubit.isScanned) ...[
                              const PassportSuccessBanner(),
                              const Gap(18),
                            ],
                            FormSectionTitle(text: 'confirm_data_below'.tr()),
                            const Gap(14),
                            PassportFieldsForm(
                              form: cubit.passportForm,
                              labeled: true,
                              onChanged: cubit.passportChanged,
                            ),
                            const Gap(22),
                            ScanLauncher(onTap: _rescan),
                            const Gap(22),
                            AppOutlinedButton(
                              label: 'rescan'.tr(),
                              onPressed: _rescan,
                            ),
                            const Gap(12),
                            CustomButton(
                              label: 'create_account_action'.tr(),
                              width: double.infinity,
                              height: 48,
                              onPressed: _continue,
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
