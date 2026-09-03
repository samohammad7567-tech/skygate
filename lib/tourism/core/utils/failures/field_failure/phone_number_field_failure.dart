
import 'field_failure.dart';

enum PhoneNumberError {
  empty,
  notValid,
}

class PhoneNumberFieldFailure extends FieldFailure{
PhoneNumberError error;
PhoneNumberFieldFailure(this.error);
}
