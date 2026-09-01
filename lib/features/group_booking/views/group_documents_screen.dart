import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/document_upload_card.dart';
import 'package:skygate/core/components/image_source_sheet.dart';
import 'package:skygate/core/components/toast.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/booking/widgets/booking_section_title.dart';
import 'package:skygate/features/booking/widgets/booking_step_scaffold.dart';
import 'package:skygate/features/group_booking/controller/cubit/group_booking_cubit.dart';
import 'package:skygate/features/group_booking/views/group_composition_screen.dart';

/// Steps 2 and 4 (last card) — "إرفاق الملفات" for the traveller being added.
///
/// Attaching files is optional; continuing commits the traveller to the group
/// and drops back on "تكوين المجموعة".
class GroupDocumentsScreen extends StatelessWidget {
  const GroupDocumentsScreen({super.key});

  Future<void> _pick(BuildContext context, String id) async {
    final cubit = context.read<GroupBookingCubit>();
    final source = await showImageSourceSheet(context);
    if (source == null) return;
    await cubit.pickDocument(id, source);
  }

  /// Adds the traveller, then rewinds to the composition card rather than
  /// stacking another copy of it on top of the one the user came from.
  void _continue(BuildContext context) {
    final cubit = context.read<GroupBookingCubit>();
    final isFirst = cubit.isAddingLeader;
    cubit.commitTraveler();
    cubit.goToStep(isFirst ? 3 : 5);

    if (isFirst) {
      NaivgatorHelper.pushAnchor(
        context,
        BlocProvider.value(value: cubit, child: const GroupCompositionScreen()),
        GroupCompositionScreen.routeName,
      );
      return;
    }
    NaivgatorHelper.popBackTo(context, GroupCompositionScreen.routeName);
  }

  void _onState(BuildContext context, GroupBookingState state) {
    if (state is GroupFileTooLarge) {
      showToast(context, 'file_too_large'.tr(), isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupBookingCubit, GroupBookingState>(
      listener: _onState,
      builder: (context, state) {
        final cubit = context.read<GroupBookingCubit>();
        final isLeader = cubit.isAddingLeader;

        return BookingStepScaffold(
          step: isLeader ? 2 : 4,
          total: GroupBookingCubit.totalSteps,
          onContinue: () => _continue(context),
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
            for (final document in cubit.documentTypes) ...[
              DocumentUploadCard(
                document: document,
                file: cubit.documents[document.id],
                onTap: () => _pick(context, document.id),
                onRemove: () => cubit.removeDocument(document.id),
              ),
              const Gap(14),
            ],
          ],
        );
      },
    );
  }
}
