import 'package:easy_localization/easy_localization.dart';
import 'package:skygate/core/utils/app_phone.dart';

class AppValidators {
  AppValidators._();

  static final RegExp _email = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');

  static const int minPasswordLength = 8;

  static String? required(String? value) =>
      (value == null || value.trim().isEmpty) ? 'field_required'.tr() : null;

  static String? requiredDate(DateTime? value) =>
      value == null ? 'field_required'.tr() : null;
  static String? phone(String? value) {
    if (AppPhone.isBlank(value)) return 'field_required'.tr();
    return AppPhone.isValid(value) ? null : 'invalid_phone'.tr();
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

  static String? confirmPassword(String? value, String password) {
    final empty = required(value);
    if (empty != null) return empty;
    return value == password ? null : 'passwords_not_match'.tr();
  }
}
