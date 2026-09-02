import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_outlined_button.dart';
import 'package:skygate/core/components/app_panel.dart';
import 'package:skygate/core/components/form_section_title.dart';
import 'package:skygate/core/components/passport_fields_form.dart';
import 'package:skygate/core/components/passport_success_banner.dart';
import 'package:skygate/core/components/scan_launcher.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/booking/controller/cubit/booking_cubit.dart';
import 'package:skygate/features/booking/views/booking_documents_screen.dart';
import 'package:skygate/core/components/booking_section_title.dart';
import 'package:skygate/features/booking/widgets/booking_step_scaffold.dart';

/// Step 2 (scanned path) — the MRZ read back from the passport, ready to be
/// checked before the documents are attached.
class BookingPassportConfirmScreen extends StatefulWidget {
  const BookingPassportConfirmScreen({super.key});

  @override
  State<BookingPassportConfirmScreen> createState() =>
      _BookingPassportConfirmScreenState();
}

class _BookingPassportConfirmScreenState
    extends State<BookingPassportConfirmScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _rescan() {
    context.read<BookingCubit>().resetScan();
    NaivgatorHelper.popNavigation(context);
  }

  void _continue() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() != true) return;

    final cubit = context.read<BookingCubit>();
    NaivgatorHelper.pushNavigation(
      context,
      BlocProvider.value(value: cubit, child: const BookingDocumentsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        final cubit = context.read<BookingCubit>();

        return BookingStepScaffold(
          step: 2,
          onContinue: _continue,
          children: [
            BookingSectionTitle(
              title: 'data_verification'.tr(),
              subtitle: 'complete_personal_data'.tr(),
            ),
            const Gap(16),
            AppPanel(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
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
                    AppOutlinedButton(label: 'rescan'.tr(), onPressed: _rescan),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
