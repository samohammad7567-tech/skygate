import 'package:formz/formz.dart';
import '../failures/field_failure/confirm_password_field_failure.dart';

class ConfirmPasswordField
    extends FormzInput<String, ConfirmPasswordFieldFailure> {
  final String originPassword;

  const ConfirmPasswordField.pure({required this.originPassword}) : super.pure('');

  const ConfirmPasswordField.dirty(super.value, {required this.originPassword})
    : super.dirty();

  @override
  validator(String value) {
    return value.isNotEmpty == true
        ? value == originPassword
              ? null
              : ConfirmPasswordFieldFailure(
                  ConfirmPasswordFieldError.passwordDoNotMatch,
                )
        : ConfirmPasswordFieldFailure(ConfirmPasswordFieldError.empty);
  }

  factory ConfirmPasswordField.fromJson(String json, String originPassword) {
    return ConfirmPasswordField.dirty(json, originPassword: originPassword);
  }

  String toJson() {
    return super.value;
  }
}
