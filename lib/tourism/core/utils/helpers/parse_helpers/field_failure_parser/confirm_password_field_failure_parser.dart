import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import '../../../failures/field_failure/confirm_password_field_failure.dart';

class ConfirmPasswordFieldFailureParser {
  static String mapFieldFailureToErrorMessage({
    required ConfirmPasswordFieldFailure failure,
    required BuildContext context,
  }) {
    switch (failure.error) {
      case ConfirmPasswordFieldError.empty:
        return tr('passwordEmpty');
      case ConfirmPasswordFieldError.passwordDoNotMatch:
        return tr('newPasswordHaveNotBeSameOfOldPassword');
    }
  }
}
