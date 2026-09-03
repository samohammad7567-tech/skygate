import 'package:formz/formz.dart';
import '../failures/field_failure/confirm_password_field_failure.dart';

class ConfirmPasswordField extends FormzInput<String, ConfirmPasswordFieldFailure> {
  final String originPassword;

  ConfirmPasswordField.pure({required this.originPassword}) : super.pure('');

  ConfirmPasswordField.dirty(String value, {required this.originPassword})
      : super.dirty(value);

  @override
  validator(String value) {
    return value.isNotEmpty == true
        ? value == originPassword
            ?null: ConfirmPasswordFieldFailure(ConfirmPasswordFieldError.passwordDoNotMatch)
        : ConfirmPasswordFieldFailure(ConfirmPasswordFieldError.empty);
  }

  factory ConfirmPasswordField.fromJson(String json,String originPassword) {
    return ConfirmPasswordField.dirty(json,originPassword: originPassword);
  }

  String toJson() {
    return super.value;
  }
}
