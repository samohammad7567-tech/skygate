import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import '../../../failures/field_failure/phone_number_field_failure.dart';


class PhoneNumberFieldFailureParser{
  static String mapFieldFailureToErrorMessage({
    required PhoneNumberFieldFailure failure, required BuildContext context}) {
    switch(failure.error){
      case PhoneNumberError.empty:
        return tr('phoneNumberRequired');
      case PhoneNumberError.notValid:
        return tr('enterValidPhoneNumber');
    }

  }
}