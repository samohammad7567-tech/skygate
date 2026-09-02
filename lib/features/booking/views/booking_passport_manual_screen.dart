import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_panel.dart';
import 'package:skygate/core/components/form_section_title.dart';
import 'package:skygate/core/components/important_note_card.dart';
import 'package:skygate/core/components/passport_fields_form.dart';
import 'package:skygate/core/components/pledge_checkbox.dart';
import 'package:skygate/core/components/toast.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/booking/controller/cubit/booking_cubit.dart';
import 'package:skygate/features/booking/views/booking_documents_screen.dart';
import 'package:skygate/core/components/booking_section_title.dart';
import 'package:skygate/features/booking/widgets/booking_step_scaffold.dart';

/// Step 2 (typed path) — "إدخال يدوي" of the passport rows.
class BookingPassportManualScreen extends StatefulWidget {
  const BookingPassportManualScreen({super.key});

  @override
  State<BookingPassportManualScreen> createState() =>
      _BookingPassportManualScreenState();
}

class _BookingPassportManualScreenState
    extends State<BookingPassportManualScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _continue() {
    FocusScope.of(context).unfocus();
    final cubit = context.read<BookingCubit>();

    if (_formKey.currentState?.validate() != true) return;
    if (!cubit.pledgeAccepted) {
      showToast(context, 'must_accept_pledge'.tr(), isError: true);
      return;
    }

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
                    FormSectionTitle(text: 'passport_info'.tr()),
                    const Gap(14),
                    PassportFieldsForm(
                      form: cubit.passportForm,
                      labeled: false,
                      onChanged: cubit.passportChanged,
                    ),
                    const Gap(16),
                    PledgeCheckbox(
                      value: cubit.pledgeAccepted,
                      onChanged: cubit.togglePledge,
                    ),
                    const Gap(14),
                    const ImportantNoteCard(),
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
