import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_field_decoration.dart';
import 'package:skygate/core/constants/auth_assets.dart';

/// "الجنس" picker. Values travel to the API as `male` / `female`.
class AppGenderField extends StatelessWidget {
  const AppGenderField({
    super.key,
    required this.value,
    required this.onChanged,
    this.validator,
    this.filled = false,
  });

  final String? value;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;
  final bool filled;

  static const List<String> values = ['male', 'female'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DropdownButtonFormField<String>(
      initialValue: values.contains(value) ? value : null,
      onChanged: onChanged,
      validator: validator,
      isExpanded: true,
      icon: const SizedBox.shrink(),
      dropdownColor: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(10),
      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      decoration: appInputDecoration(
        context,
        hint: 'gender'.tr(),
        icon: AuthAssets.man,
        filled: filled,
      ),
      items: [
        for (final gender in values)
          DropdownMenuItem(value: gender, child: Text(gender.tr())),
      ],
    );
  }
}
