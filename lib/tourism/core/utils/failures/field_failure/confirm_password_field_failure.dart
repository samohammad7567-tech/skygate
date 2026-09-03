import 'field_failure.dart';

enum ConfirmPasswordFieldError {
  empty,
  passwordDoNotMatch,
}

class ConfirmPasswordFieldFailure extends FieldFailure{
  ConfirmPasswordFieldError error;
  ConfirmPasswordFieldFailure(this.error);
}
