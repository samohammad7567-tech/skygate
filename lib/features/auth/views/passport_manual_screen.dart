import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_background.dart';
import 'package:skygate/core/components/app_panel.dart';
import 'package:skygate/core/components/app_title_header.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/components/form_section_title.dart';
import 'package:skygate/core/components/important_note_card.dart';
import 'package:skygate/core/components/passport_fields_form.dart';
import 'package:skygate/core/components/pledge_checkbox.dart';
import 'package:skygate/core/components/toast.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/auth/controller/cubit/register_cubit.dart';
import 'package:skygate/features/auth/views/umrah_documents_screen.dart';
import 'package:skygate/features/auth/widgets/register_stepper.dart';

class PassportManualScreen extends StatefulWidget {
  const PassportManualScreen({super.key});

  @override
  State<PassportManualScreen> createState() => _PassportManualScreenState();
}

class _PassportManualScreenState extends State<PassportManualScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _continue() {
    FocusScope.of(context).unfocus();
    final cubit = context.read<RegisterCubit>();

    if (_formKey.currentState?.validate() != true) return;
    if (!cubit.pledgeAccepted) {
      showToast(context, 'must_accept_pledge'.tr(), isError: true);
      return;
    }

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
                padding: EdgeInsets.fromLTRB(24.s, 32.s, 24.s, 32.s),
                child: Column(
                  children: [
                    const AppTitleHeader(showBack: true),
                    Gap(24.s),
                    AppPanel(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const RegisterStepper(currentStep: 2),
                            Gap(20.s),
                            Text(
                              'manual_entry_title'.tr(),
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            Gap(14.s),
                            FormSectionTitle(text: 'passport_info'.tr()),
                            Gap(14.s),
                            PassportFieldsForm(
                              form: cubit.passportForm,
                              labeled: false,
                              onChanged: cubit.passportChanged,
                            ),
                            Gap(16.s),
                            PledgeCheckbox(
                              value: cubit.pledgeAccepted,
                              onChanged: cubit.togglePledge,
                            ),
                            Gap(14.s),
                            const ImportantNoteCard(),
                            Gap(18.s),
                            CustomButton(
                              label: 'create_account'.tr(),
                              width: double.infinity,
                              height: 48.s,
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
