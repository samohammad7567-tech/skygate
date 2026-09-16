import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import '../../failures/base_failure.dart';
import '../../failures/field_failure/field_failure.dart';
import '../../failures/http/http_failure.dart';
import 'field_failure_parser/field_failure_parser.dart';
import 'http_failure_parser/http_failure_parser.dart';

class FailureParser {
  static String mapFailureToString({
    required Failure? failure,
    required BuildContext context,
  }) {
    if (failure is HttpFailure) {
      return HttpFailureParser.mapHttpFailureToErrorMessage(failure, context);
    } else if (failure is FieldFailure) {
      return FieldFailureParser.mapFieldFailureToErrorMessage(
        failure: failure,
        context: context,
      );
    } else {
      return tr('errorUnknown');
    }
  }
}
