import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/document_upload_card.dart';
import 'package:skygate/core/components/image_source_sheet.dart';
import 'package:skygate/core/components/toast.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/profile/controller/cubit/profile_cubit.dart';
import 'package:skygate/features/profile/widgets/profile_form_actions.dart';
import 'package:skygate/features/profile/widgets/profile_scaffold.dart';
import 'package:skygate/core/components/app_section_title.dart';

class EditFilesScreen extends StatelessWidget {
  const EditFilesScreen({super.key});

  Future<void> _pick(BuildContext context, String id) async {
    final cubit = context.read<ProfileCubit>();
    final source = await showImageSourceSheet(context);
    if (source == null) return;
    await cubit.pickDocument(id, source);
  }

  void _cancel(BuildContext context) {
    context.read<ProfileCubit>().resetDocumentsForm();
    NaivgatorHelper.popNavigation(context);
  }

  void _onState(BuildContext context, ProfileState state) {
    if (state is DocumentsSaved) {
      showToast(context, 'files_saved'.tr());
      NaivgatorHelper.popNavigation(context);
    } else if (state is DocumentsSaveError) {
      showToast(context, state.message.tr(), isError: true);
    } else if (state is FileTooLarge) {
      showToast(context, 'file_too_large'.tr(), isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: _onState,
      builder: (context, state) {
        final cubit = context.read<ProfileCubit>();

        return ProfileScaffold(
          title: 'edit_account'.tr(),
          onBack: () => _cancel(context),
          children: [
            AppSectionTitle(text: 'edit_files'.tr()),
            const Gap(14),
            for (final document in cubit.documentTypes) ...[
              DocumentUploadCard(
                document: document,
                file: cubit.pendingUploads[document.id],
                onTap: () => _pick(context, document.id),
                onRemove: () => cubit.removeDocument(document.id),
              ),
              const Gap(14),
            ],
            const Gap(6),
            ProfileFormActions(
              isSaving: state is DocumentsSaving,
              onSave: cubit.saveDocuments,
              onCancel: () => _cancel(context),
            ),
          ],
        );
      },
    );
  }
}
