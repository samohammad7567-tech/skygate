import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/components/empty_state.dart';
import 'package:skygate/core/models/umrah_document_model.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/profile/controller/cubit/profile_cubit.dart';
import 'package:skygate/features/profile/views/edit_files_screen.dart';
import 'package:skygate/features/profile/widgets/document_preview_sheet.dart';
import 'package:skygate/features/profile/widgets/pilgrim_file_row.dart';
import 'package:skygate/core/components/app_list_card.dart';
import 'package:skygate/features/profile/widgets/profile_scaffold.dart';
import 'package:skygate/core/components/app_section_title.dart';

class PilgrimFilesScreen extends StatefulWidget {
  const PilgrimFilesScreen({super.key});

  @override
  State<PilgrimFilesScreen> createState() => _PilgrimFilesScreenState();
}

class _PilgrimFilesScreenState extends State<PilgrimFilesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getDocuments();
  }

  void _preview(UmrahDocumentModel document) {
    final upload = context.read<ProfileCubit>().uploadFor(document);
    if (upload == null) return;
    DocumentPreviewSheet.show(context, document: document, upload: upload);
  }

  void _edit() {
    final cubit = context.read<ProfileCubit>();
    cubit.resetDocumentsForm();
    NaivgatorHelper.pushNavigation(
      context,
      BlocProvider.value(value: cubit, child: const EditFilesScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final cubit = context.read<ProfileCubit>();

        return ProfileScaffold(
          title: 'nav_account'.tr(),
          children: [
            AppSectionTitle(text: 'pilgrim_files'.tr()),
            Gap(12.s),
            if (state is DocumentsLoading)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 48.s),
                child: Center(
                  child: CircularProgressIndicator(strokeWidth: 2.s),
                ),
              )
            else if (state is DocumentsError)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 32.s),
                child: EmptyState(
                  message: state.message.tr(),
                  onRetry: cubit.getDocuments,
                ),
              )
            else
              AppListCard(
                children: [
                  for (final document in cubit.documentTypes)
                    PilgrimFileRow(
                      document: document,
                      upload: cubit.uploadFor(document),
                      onPreview: () => _preview(document),
                    ),
                ],
              ),
            Gap(18.s),
            CustomButton(
              label: 'edit_pilgrim_files'.tr(),
              height: 48.s,
              onPressed: _edit,
            ),
          ],
        );
      },
    );
  }
}
