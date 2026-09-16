import 'package:formz/formz.dart';
import '../failures/field_failure/otp_field_failure.dart';

class OtpField extends FormzInput<String, OtpFieldFailure> {
  final int length;

  const OtpField.pure({required this.length}) : super.pure('');

  const OtpField.dirty(super.value, {required this.length}) : super.dirty();

  @override
  validator(String value) {
    return value.isEmpty
        ? OtpFieldFailure(OtpFieldError.empty)
        : value.length < length
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
