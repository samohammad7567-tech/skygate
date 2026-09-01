import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_date_field.dart';
import 'package:skygate/core/components/app_gender_field.dart';
import 'package:skygate/core/components/app_text_field.dart';
import 'package:skygate/core/components/labeled_field.dart';
import 'package:skygate/core/constants/auth_assets.dart';
import 'package:skygate/core/models/passport_form.dart';
import 'package:skygate/core/utils/app_validators.dart';

/// The ten passport rows, shared by the scan-confirmation card and the manual
/// entry card of both the signup and the booking wizard.
///
/// [labeled] switches between the two treatments in the design: the confirm
/// screen captions every row, the manual form leans on placeholders. It also
/// swaps the passport / national number order, matching the mockups.
///
/// The widget writes straight into [form] and calls [onChanged] afterwards, so
/// the cubit that owns the form decides when to rebuild.
class PassportFieldsForm extends StatelessWidget {
  const PassportFieldsForm({
    super.key,
    required this.form,
    required this.labeled,
    required this.onChanged,
  });

  final PassportForm form;
  final bool labeled;

  /// Called after a date or the gender changes; the text rows keep their own
  /// controllers and do not need it.
  final VoidCallback onChanged;

  Widget _wrap(String labelKey, Widget child) =>
      labeled ? LabeledField(label: labelKey.tr(), child: child) : child;

  String _hint(String labelKey, String hintKey) =>
      labeled ? labelKey.tr() : hintKey.tr();

  @override
  Widget build(BuildContext context) {
    final passportNumber = _wrap(
      'passport_number',
      AppTextField(
        controller: form.passportNumberController,
        hint: _hint('passport_number', 'passport_number_hint'),
        icon: AuthAssets.passport,
        textInputAction: TextInputAction.next,
        validator: AppValidators.required,
      ),
    );

    final nationalNumber = _wrap(
      'national_number',
      AppTextField(
        controller: form.nationalNumberController,
        hint: _hint('national_number', 'national_number_hint'),
        icon: AuthAssets.idCard,
        textInputAction: TextInputAction.next,
        validator: AppValidators.required,
      ),
    );

    return Column(
      children: [
        _wrap(
          'full_name_ar',
          AppTextField(
            controller: form.fullNameArController,
            hint: _hint('full_name_ar', 'full_name_ar_hint'),
            icon: AuthAssets.accountCircle,
            textInputAction: TextInputAction.next,
            validator: AppValidators.required,
          ),
        ),
        const Gap(12),
        _wrap(
          'full_name_en',
          AppTextField(
            controller: form.fullNameEnController,
            hint: _hint('full_name_en', 'full_name_en_hint'),
            icon: AuthAssets.accountCircle,
            textInputAction: TextInputAction.next,
            validator: AppValidators.required,
          ),
        ),
        const Gap(12),
        _wrap(
          'birth_date',
          AppDateField(
            hint: 'birth_date'.tr(),
            value: form.birthDate,
            onPicked: (date) {
              form.birthDate = date;
              onChanged();
            },
            validator: AppValidators.requiredDate,
            lastDate: DateTime.now(),
          ),
        ),
        const Gap(12),
        _wrap(
          'gender',
          AppGenderField(
            value: form.gender,
            onChanged: (value) {
              form.gender = value;
              onChanged();
            },
            validator: AppValidators.required,
          ),
        ),
        const Gap(12),
        _wrap(
          'nationality',
          AppTextField(
            controller: form.nationalityController,
            hint: 'nationality'.tr(),
            icon: AuthAssets.globe,
            textInputAction: TextInputAction.next,
            validator: AppValidators.required,
          ),
        ),
        const Gap(12),
        // The confirm card lists the passport number first; the manual form
        // asks for the national number first.
        if (labeled) passportNumber else nationalNumber,
        const Gap(12),
        if (labeled) nationalNumber else passportNumber,
        const Gap(12),
        _wrap(
          'passport_issue_place',
          AppTextField(
            controller: form.issuePlaceController,
            hint: _hint('passport_issue_place', 'passport_issue_place_hint'),
            icon: AuthAssets.assignmentGlobe,
            textInputAction: TextInputAction.done,
            validator: AppValidators.required,
          ),
        ),
        const Gap(12),
        _wrap(
          'issue_date',
          AppDateField(
            hint: _hint('issue_date', 'passport_issue_date'),
            value: form.issueDate,
            onPicked: (date) {
              form.issueDate = date;
              onChanged();
            },
            validator: AppValidators.requiredDate,
          ),
        ),
        const Gap(12),
        _wrap(
          'expiry_date',
          AppDateField(
            hint: _hint('expiry_date', 'passport_expiry_date'),
            value: form.expiryDate,
            onPicked: (date) {
              form.expiryDate = date;
              onChanged();
            },
            validator: AppValidators.requiredDate,
          ),
        ),
      ],
    );
  }
}
