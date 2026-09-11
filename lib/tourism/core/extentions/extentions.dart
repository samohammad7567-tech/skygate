import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/failures/base_failure.dart';
import '../utils/failures/field_failure/field_failure.dart';
import '../utils/helpers/parse_helpers/failure_parser.dart';
import '../utils/helpers/parse_helpers/field_failure_parser/field_failure_parser.dart';

extension ContextMethods on BuildContext {
  String failureParser(Failure failure) =>
      FailureParser.mapFailureToString(failure: failure, context: this);
  String? fieldFailureParser(FieldFailure? failure) => failure == null
      ? null
      : FieldFailureParser.mapFieldFailureToErrorMessage(
          failure: failure,
          context: this,
        );

  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => Theme.of(this).textTheme;
}

extension DoubleMethods on double {
  double roundTo2DigitsAfterDecimalPoint() => double.parse(toStringAsFixed(2));
}

extension StringMethods on String {
  bool get isValidEmail => contains(
    RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ),
  );
}

extension Date on DateTime {
  String getDayName({String? locale}) {
    return DateFormat('EEEE', locale).format(this);
  }

  String getDateWithMonthNameDayAndYear() {
    return DateFormat("MMM dd, yyyy").format(this);
  }

  String getTime() {
    return DateFormat("jm").format(this);
  }
}

extension DurationEx on Duration {
  String toMinuteWithSeconds() {
    int seconds = inSeconds;
    int minutes = seconds ~/ 60;
    String ret = minutes < 10 ? '0$minutes' : '$minutes';
    ret += ':';
    seconds -= minutes * 60;
    ret += seconds < 10 ? '0$seconds' : '$seconds';
    return ret;
  }
}
