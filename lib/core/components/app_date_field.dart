import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_field_decoration.dart';
import 'package:skygate/core/constants/auth_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';

class AppDateField extends StatelessWidget {
  const AppDateField({
    super.key,
    required this.hint,
    required this.value,
    required this.onPicked,
    this.validator,
    this.filled = false,
    this.firstDate,
    this.lastDate,
  });

  final String hint;
  final DateTime? value;
  final ValueChanged<DateTime> onPicked;
  final String? Function(DateTime?)? validator;
  final bool filled;
  final DateTime? firstDate;
  final DateTime? lastDate;

  static final DateFormat _format = DateFormat('dd / MM / yyyy');

  Future<void> _pick(BuildContext context) async {
    final now = DateTime.now();
    final first = firstDate ?? DateTime(1900);
    final last = lastDate ?? DateTime(now.year + 30);

    // `showDatePicker` asserts the initial date is inside the range, and the
    // range is set by the call site: a field that only accepts future dates
    // has a `firstDate` that today is already behind. Clamping here means no
    // caller has to pass an `initialDate` just to keep the picker from
    // throwing.
    final wanted = value ?? now;
    final initial = wanted.isBefore(first)
        ? first
        : (wanted.isAfter(last) ? last : wanted);

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
      helpText: 'select_date'.tr(),
    );
    if (picked != null) onPicked(picked);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FormField<DateTime>(
      initialValue: value,
      validator: validator,
      builder: (field) {
        // `initialValue` is only read once, so mirror the cubit's value here.
        if (field.value != value) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (field.mounted) field.didChange(value);
          });
        }

        return InkWell(
          onTap: () => _pick(context),
          borderRadius: BorderRadius.circular(10.s),
          child: InputDecorator(
            isEmpty: value == null,
            decoration: appInputDecoration(
              context,
              hint: hint,
              icon: AuthAssets.calendar,
              filled: filled,
            ).copyWith(errorText: field.errorText),
            child: value == null
                ? null
                : Text(
                    _format.format(value!),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
