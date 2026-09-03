import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import '../../../failures/field_failure/password_field_failure.dart';


class PasswordFieldFailureParser{
  static String mapFieldFailureToErrorMessage({
    required PasswordFieldFailure failure, required BuildContext context}) {
    switch(failure.error){

      case PasswordError.oneUpperCase:
        return tr('passwordUpperCase');
       case PasswordError.oneLowerCase:
         return tr('passwordLowerCase');

      case PasswordError.oneSpecialCharacter:
        return tr('passwordSpecialCharacter');

      case PasswordError.oneNumber:
        return tr('passwordNumericValue');

      case PasswordError.lengthError:
        return tr('password8Characters');

      case PasswordError.empty:
        return tr('passwordEmpty');

      case PasswordError.match:
        return tr('newPasswordHaveNotBeSameOfOldPassword');

    }

  }
}