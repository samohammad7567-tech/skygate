import 'package:formz/formz.dart';
import '../failures/field_failure/otp_field_failure.dart';

class OtpField extends FormzInput<String, OtpFieldFailure> {
  int length;

  OtpField.pure({
    required this.length,
  }) : super.pure('');

  OtpField.dirty(
    String value, {
    required this.length,
  }) : super.dirty(value);

  @override
  validator(String value) {
    return value.isEmpty
        ?OtpFieldFailure(OtpFieldError.empty):
    value.length < length
            ? OtpFieldFailure(OtpFieldError.otpLessThanNumber)
            : null;
  }

  factory OtpField.fromJson(String json, int length) {
    return OtpField.dirty(json, length: length);
  }

  String toJson() {
    return super.value;
  }
}
