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
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/core/components/booking_section_title.dart';
import 'package:skygate/core/components/booking_step_scaffold.dart';
import 'package:skygate/features/group_booking/controller/cubit/group_booking_cubit.dart';
import 'package:skygate/features/group_booking/views/group_documents_screen.dart';
import 'package:skygate/features/group_booking/widgets/group_guardian_field.dart';

class GroupPassportManualScreen extends StatefulWidget {
  const GroupPassportManualScreen({super.key});

  @override
  State<GroupPassportManualScreen> createState() =>
      _GroupPassportManualScreenState();
}

class _GroupPassportManualScreenState extends State<GroupPassportManualScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _continue() {
    FocusScope.of(context).unfocus();
    final cubit = context.read<GroupBookingCubit>();

    if (_formKey.currentState?.validate() != true) return;
    if (!cubit.pledgeAccepted) {
      showToast(context, 'must_accept_pledge'.tr(), isError: true);
      return;
    }

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
            Gap(16.s),
            AppPanel(
              padding: EdgeInsets.fromLTRB(16.s, 20.s, 16.s, 20.s),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    FormSectionTitle(text: 'passport_info'.tr()),
                    Gap(14.s),
                    PassportFieldsForm(
                      form: cubit.passportForm,
                      labeled: false,
                      onChanged: cubit.passportChanged,
                    ),
                    if (!isLeader) ...[
                      Gap(16.s),
                      const GroupGuardianNote(),
                      Gap(12.s),
                      GroupGuardianField(
                        adults: cubit.adults,
                        value: cubit.draftGuardianId,
                        onChanged: cubit.selectGuardian,
                        isRequired: cubit.draftAudience.needsGuardian,
                      ),
                    ],
                    Gap(16.s),
                    PledgeCheckbox(
                      value: cubit.pledgeAccepted,
                      onChanged: cubit.togglePledge,
                    ),
                    Gap(14.s),
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
