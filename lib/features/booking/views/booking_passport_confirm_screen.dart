import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_outlined_button.dart';
import 'package:skygate/core/components/app_panel.dart';
import 'package:skygate/core/components/form_section_title.dart';
import 'package:skygate/core/components/passport_fields_form.dart';
import 'package:skygate/core/components/passport_scan_banner.dart';
import 'package:skygate/core/components/scan_launcher.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/booking/controller/cubit/booking_cubit.dart';
import 'package:skygate/features/booking/views/booking_documents_screen.dart';
import 'package:skygate/core/components/booking_section_title.dart';
import 'package:skygate/core/components/booking_step_scaffold.dart';

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
          total: BookingCubit.totalSteps,
          onContinue: _continue,
          children: [
            BookingSectionTitle(
              title: 'data_verification'.tr(),
              subtitle: 'complete_personal_data'.tr(),
            ),
            Gap(16.s),
            AppPanel(
              padding: EdgeInsets.fromLTRB(16.s, 20.s, 16.s, 20.s),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    if (cubit.isScanned) ...[
                      const PassportScanBanner(),
                      Gap(18.s),
                    ],
                    FormSectionTitle(text: 'confirm_data_below'.tr()),
                    Gap(14.s),
                    PassportFieldsForm(
                      form: cubit.passportForm,
                      labeled: true,
                      onChanged: cubit.passportChanged,
                    ),
                    Gap(22.s),
                    ScanLauncher(onTap: _rescan),
                    Gap(22.s),
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
