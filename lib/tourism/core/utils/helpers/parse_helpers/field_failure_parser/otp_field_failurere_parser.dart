import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import '../../../failures/field_failure/otp_field_failure.dart';

class OtpFieldFailureParser{
  static String mapFieldFailureToErrorMessage({
    required OtpFieldFailure failure, required BuildContext context}) {
    switch(failure.error){
      case OtpFieldError.empty:
        return tr('otpCodeEmpty');
      case OtpFieldError.otpLessThanNumber:
        return tr('otpCodeShouldNotBeLessThanNumber');
    }
  }
}