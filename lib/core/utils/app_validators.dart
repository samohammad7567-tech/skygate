import 'package:easy_localization/easy_localization.dart';

/// Field validators for the auth forms. Every message is already translated so
/// `TextFormField.validator` can return it as-is.
class AppValidators {
  AppValidators._();

  static final RegExp _email = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');
  static final RegExp _phone = RegExp(r'^\+?\d{8,15}$');

  static const int minPasswordLength = 8;

  static String? required(String? value) =>
      (value == null || value.trim().isEmpty) ? 'field_required'.tr() : null;

  static String? requiredDate(DateTime? value) =>
      value == null ? 'field_required'.tr() : null;

  static String? phone(String? value) {
    final empty = required(value);
    if (empty != null) return empty;
    final digits = value!.trim().replaceAll(RegExp(r'[\s-]'), '');
    return _phone.hasMatch(digits) ? null : 'invalid_phone'.tr();
  }

  static String? email(String? value) {
    final empty = required(value);
    if (empty != null) return empty;
    return _email.hasMatch(value!.trim()) ? null : 'invalid_email'.tr();
  }

  static String? password(String? value) {
    final empty = required(value);
    if (empty != null) return empty;
    return value!.length >= minPasswordLength
        ? null
        : 'password_too_short'.tr(args: ['$minPasswordLength']);
  }

  /// Confirms [value] matches the password typed in the field above.
  static String? confirmPassword(String? value, String password) {
    final empty = required(value);
    if (empty != null) return empty;
    return value == password ? null : 'passwords_not_match'.tr();
  }
}
