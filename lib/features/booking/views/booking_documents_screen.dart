import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/document_upload_card.dart';
import 'package:skygate/core/components/image_source_sheet.dart';
import 'package:skygate/core/components/toast.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/booking/controller/cubit/booking_cubit.dart';
import 'package:skygate/features/booking/views/booking_route_screen.dart';
import 'package:skygate/core/components/booking_section_title.dart';
import 'package:skygate/features/booking/widgets/booking_step_scaffold.dart';

/// Step 2 (last card) — "إرفاق الملفات". Attaching files is optional; the
/// wizard moves on either way.
class BookingDocumentsScreen extends StatelessWidget {
  const BookingDocumentsScreen({super.key});

  Future<void> _pick(BuildContext context, String id) async {
    final cubit = context.read<BookingCubit>();
    final source = await showImageSourceSheet(context);
    if (source == null) return;
    await cubit.pickDocument(id, source);
  }

  void _continue(BuildContext context) {
    final cubit = context.read<BookingCubit>();
    cubit.goToStep(3);
    NaivgatorHelper.pushNavigation(
      context,
      BlocProvider.value(value: cubit, child: const BookingRouteScreen()),
    );
  }

  void _onState(BuildContext context, BookingState state) {
    if (state is FileTooLarge) {
      showToast(context, 'file_too_large'.tr(), isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingCubit, BookingState>(
      listener: _onState,
      builder: (context, state) {
        final cubit = context.read<BookingCubit>();

        return BookingStepScaffold(
          step: 2,
          onContinue: () => _continue(context),
          children: [
            BookingSectionTitle(
              title: 'data_verification'.tr(),
              subtitle: 'complete_personal_data'.tr(),
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
