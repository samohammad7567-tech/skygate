import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_date_field.dart';
import 'package:skygate/core/components/app_page_header.dart';
import 'package:skygate/core/components/app_text_field.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/components/image_source_sheet.dart';
import 'package:skygate/core/components/labeled_field.dart';
import 'package:skygate/core/components/toast.dart';
import 'package:skygate/core/constants/sos_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/sos/controller/cubit/lost_items_cubit.dart';
import 'package:skygate/features/sos/widgets/lost_photo_picker.dart';
import 'package:skygate/features/sos/widgets/sos_note_banner.dart';

class ReportLostItemScreen extends StatefulWidget {
  const ReportLostItemScreen({super.key});

  @override
  State<ReportLostItemScreen> createState() => _ReportLostItemScreenState();
}

class _ReportLostItemScreenState extends State<ReportLostItemScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _pickPhoto() async {
    final cubit = context.read<LostItemsCubit>();
    final source = await showImageSourceSheet(context);
    if (source != null) await cubit.pickPhoto(source);
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<LostItemsCubit>().submitReport();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<LostItemsCubit, LostItemsState>(
          listener: (context, state) {
            if (state is LostItemReported) {
              showToast(context, 'lost_report_sent'.tr());
              NaivgatorHelper.popNavigation(context);
            } else if (state is LostItemReportError) {
              showToast(context, state.message.tr(), isError: true);
            }
          },
          builder: (context, state) {
            final cubit = context.read<LostItemsCubit>();

            return Column(
              children: [
                AppPageHeader(title: 'lost_report_title'.tr()),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      padding: EdgeInsets.fromLTRB(20.s, 4.s, 20.s, 28.s),
                      children: [
                        const SosNoteBanner(messageKey: 'lost_report_note'),
                        Gap(18.s),
                        LabeledField(
                          label: 'lost_field_description'.tr(),
                          child: AppTextField(
                            hint: 'lost_hint_description'.tr(),
                            icon: SosAssets.description,
                            controller: cubit.descriptionController,
                            textInputAction: TextInputAction.next,
                            validator: (value) =>
                                (value?.trim().isEmpty ?? true)
                                ? 'lost_description_required'.tr()
                                : null,
                          ),
                        ),
                        Gap(16.s),
                        LabeledField(
                          label: 'lost_field_photo'.tr(),
                          child: LostPhotoPicker(
                            photo: cubit.photo,
                            onPick: _pickPhoto,
                            onRemove: cubit.removePhoto,
                          ),
                        ),
                        Gap(16.s),
                        LabeledField(
                          label: 'lost_field_place'.tr(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'lost_place_example'.tr(),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Gap(6.s),
                              AppTextField(
                                hint: 'lost_hint_place'.tr(),
                                icon: SosAssets.place,
                                controller: cubit.placeController,
                                textInputAction: TextInputAction.next,
                              ),
                            ],
                          ),
                        ),
                        Gap(16.s),
                        LabeledField(
                          label: 'lost_field_time'.tr(),
                          child: AppDateField(
                            hint: 'lost_hint_time'.tr(),
                            value: cubit.lostAt,
                            onPicked: cubit.selectLostAt,
                            // An item can only have been lost on a day that
                            // has already happened.
                            firstDate: DateTime(now.year - 1),
                            lastDate: now,
                          ),
                        ),
                        Gap(16.s),
                        LabeledField(
                          label: 'lost_field_notes'.tr(),
                          child: TextFormField(
                            controller: cubit.notesController,
                            maxLines: 4,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              hintText: 'lost_hint_notes'.tr(),
                              alignLabelWithHint: true,
                            ),
                          ),
                        ),
                        Gap(24.s),
                        CustomButton(
                          label: 'lost_submit'.tr(),
                          height: 48.s,
                          width: double.infinity,
                          isLoading: state is LostItemReportSending,
                          onPressed: _submit,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
