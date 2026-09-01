import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_background.dart';
import 'package:skygate/core/components/app_panel.dart';
import 'package:skygate/core/components/app_title_header.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/components/document_upload_card.dart';
import 'package:skygate/core/components/image_source_sheet.dart';
import 'package:skygate/core/components/toast.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/auth/controller/cubit/register_cubit.dart';
import 'package:skygate/features/auth/views/register_success_screen.dart';
import 'package:skygate/features/auth/widgets/register_stepper.dart';

/// Step 3 — "ملفات المعتمر". Attaching files is optional; the orange link
/// skips straight to account creation.
class UmrahDocumentsScreen extends StatelessWidget {
  const UmrahDocumentsScreen({super.key});

  Future<void> _pick(BuildContext context, String id) async {
    final cubit = context.read<RegisterCubit>();
    final source = await showImageSourceSheet(context);
    if (source == null) return;
    await cubit.pickDocument(id, source);
  }

  void _onState(BuildContext context, RegisterState state) {
    if (state is RegisterSucceeded) {
      NaivgatorHelper.pushAndRemoveUntilNavigation(
        context,
        const RegisterSuccessScreen(),
      );
    } else if (state is RegisterError) {
      showToast(context, state.message.tr(), isError: true);
    } else if (state is FileTooLarge) {
      showToast(context, 'file_too_large'.tr(), isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: BlocConsumer<RegisterCubit, RegisterState>(
            listener: _onState,
            builder: (context, state) {
              final cubit = context.read<RegisterCubit>();

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
                child: Column(
                  children: [
                    const AppTitleHeader(showBack: true),
                    const Gap(24),
                    AppPanel(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                      child: Column(
                        children: [
                          const RegisterStepper(currentStep: 3),
                          const Gap(20),
                          Text(
                            'pilgrim_documents'.tr(),
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const Gap(18),
                          for (final document in cubit.documentTypes) ...[
                            DocumentUploadCard(
                              document: document,
                              file: cubit.documents[document.id],
                              onTap: () => _pick(context, document.id),
                              onRemove: () => cubit.removeDocument(document.id),
                            ),
                            const Gap(14),
                          ],
                          const Gap(6),
                          CustomButton(
                            label: 'create_account'.tr(),
                            width: double.infinity,
                            height: 48,
                            isLoading: state is RegisterLoading,
                            onPressed: cubit.submit,
                          ),
                          const Gap(14),
                          TextButton(
                            onPressed: cubit.skipDocuments,
                            child: Text(
                              'skip_this_step_now'.tr(),
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                        ],
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
