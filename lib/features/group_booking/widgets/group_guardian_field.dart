import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_field_decoration.dart';
import 'package:skygate/core/components/labeled_field.dart';
import 'package:skygate/core/constants/auth_assets.dart';
import 'package:skygate/features/group_booking/models/group_traveler_model.dart';

/// "اسم ولي الأمر" — the adult a child or an infant travels under, picked from
/// the adults already on the booking.
///
/// The field is offered to every traveller after the leader, and only insisted
/// on when the passport says the traveller cannot stand on their own.
class GroupGuardianField extends StatelessWidget {
  const GroupGuardianField({
    super.key,
    required this.adults,
    required this.value,
    required this.onChanged,
    required this.isRequired,
  });

  final List<GroupTravelerModel> adults;

  /// `GroupTravelerModel.localId` of the guardian, or `null` while unset.
  final int? value;

  final ValueChanged<int?> onChanged;

  /// Turns the validator on for children and infants.
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    final selected = adults.any((adult) => adult.localId == value)
        ? value
        : null;

    return LabeledField(
      label: 'guardian_name'.tr(),
      child: DropdownButtonFormField<int>(
        initialValue: selected,
        isExpanded: true,
        // Suppressed like `AppGenderField`, so the field glyph the shared
        // chrome puts in the suffix slot is the only marker on the row.
        icon: const SizedBox.shrink(),
        dropdownColor: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        decoration: appInputDecoration(
          context,
          hint: 'guardian_name'.tr(),
          icon: AuthAssets.man,
        ),
        items: [
          for (final adult in adults)
            DropdownMenuItem(
              value: adult.localId,
              child: Text(
                adult.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
        ],
        onChanged: onChanged,
        validator: (picked) =>
            isRequired && picked == null ? 'field_required'.tr() : null,
      ),
    );
  }
}

/// "معلومة مهمة • يرجى إضافة اسم ولي الأمر" note printed above the field.
class GroupGuardianNote extends StatelessWidget {
  const GroupGuardianNote({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 22, color: theme.colorScheme.primary),
          const Gap(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'important_note'.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                Text(
                  '• ${'guardian_note'.tr()}',
                  textAlign: TextAlign.end,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
