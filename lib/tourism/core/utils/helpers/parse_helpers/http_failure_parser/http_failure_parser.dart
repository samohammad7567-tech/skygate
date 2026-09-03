import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import '../../../failures/http/http_failure.dart';

class HttpFailureParser{
  static String mapHttpFailureToErrorMessage(
      HttpFailure failure, BuildContext context) {
    if (failure is NoInternetConnection) {
      return tr("errorNoInternet");
    } else if (failure is UnauthorizedFailure) {
      return tr("errorUnauthorized");
    } else if (failure is ServerFailure) {
      return tr("errorServerError");
    } else if (failure is TimeOutFailure) {
      return tr("errorTimeOut");
    } else if (failure is UnexpectedResponseFailure) {
      return tr("unexpectedResponseFailure");
    } else if (failure is MethodNotAllowedFailure) {
      return tr("methodNotAllowedFailure");
    } else if (failure is CustomFailure) {
      return failure.message;
    } else {
      return tr("errorUnknown");
    }
  }
}