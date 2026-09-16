import 'field_failure.dart';

enum OtpFieldError { empty, otpLessThanNumber }

class OtpFieldFailure extends FieldFailure {
  OtpFieldError error;
  OtpFieldFailure(this.error);
}
