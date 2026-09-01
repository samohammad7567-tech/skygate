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
import 'package:skygate/features/booking/widgets/booking_section_title.dart';
import 'package:skygate/features/booking/widgets/booking_step_scaffold.dart';
import 'package:skygate/features/group_booking/controller/cubit/group_booking_cubit.dart';
import 'package:skygate/features/group_booking/views/group_documents_screen.dart';
import 'package:skygate/features/group_booking/widgets/group_guardian_field.dart';

/// Steps 2 and 4 (scanned path) — the MRZ read back from the passport, plus
/// the guardian every traveller after the leader travels under.
class GroupPassportConfirmScreen extends StatefulWidget {
  const GroupPassportConfirmScreen({super.key});

  @override
  State<GroupPassportConfirmScreen> createState() =>
      _GroupPassportConfirmScreenState();
}

class _GroupPassportConfirmScreenState
    extends State<GroupPassportConfirmScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _rescan() {
    context.read<GroupBookingCubit>().resetScan();
    NaivgatorHelper.popNavigation(context);
  }

  void _continue() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() != true) return;

    final cubit = context.read<GroupBookingCubit>();
    NaivgatorHelper.pushNavigation(
      context,
      BlocProvider.value(value: cubit, child: const GroupDocumentsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupBookingCubit, GroupBookingState>(
      builder: (context, state) {
        final cubit = context.read<GroupBookingCubit>();
        final isLeader = cubit.isAddingLeader;

        return BookingStepScaffold(
          step: isLeader ? 2 : 4,
          total: GroupBookingCubit.totalSteps,
          onContinue: _continue,
          children: [
            BookingSectionTitle(
              title: isLeader
                  ? 'data_verification'.tr()
                  : 'add_new_traveler'.tr(),
              subtitle: isLeader
                  ? 'first_traveler_data'.tr()
                  : 'complete_traveler_data'.tr(),
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
                    if (!isLeader) ...[
                      const Gap(18),
                      const GroupGuardianNote(),
                      const Gap(12),
                      GroupGuardianField(
                        adults: cubit.adults,
                        value: cubit.draftGuardianId,
                        onChanged: cubit.selectGuardian,
                        isRequired: cubit.draftAudience.needsGuardian,
                      ),
                    ],
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
