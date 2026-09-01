import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skygate/core/components/app_field_decoration.dart';

/// The bordered field used by every auth form.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.hint,
    required this.icon,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.validator,
    this.obscureText = false,
    this.onIconTap,
    this.filled = false,
  });

  final String hint;

  /// Bundled SVG rendered in the suffix slot.
  final String icon;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final bool obscureText;

  /// Set for password fields so tapping the eye toggles visibility.
  final VoidCallback? onIconTap;

  /// Tinted fill used by the read-only passport fields.
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      validator: validator,
      obscureText: obscureText,
      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      decoration: appInputDecoration(
        context,
        hint: hint,
        icon: icon,
        onIconTap: onIconTap,
        filled: filled,
      ),
    );
  }
}
