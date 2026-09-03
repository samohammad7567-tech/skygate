import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import '../../../failures/field_failure/email_faild_failure.dart';

class EmailFieldFailureParser{
  static String mapFieldFailureToErrorMessage({
    required EmailFieldFailure failure, required BuildContext context}) {
    switch(failure.error){
      case EmailError.empty:
        return tr('emailEmpty');
      case EmailError.notValid:
        return tr('emailNotValid');
    }
  }
}