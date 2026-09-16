import 'package:formz/formz.dart';
import '../failures/field_failure/required_field_failure.dart';

class RequiredField extends FormzInput<String, RequiredFieldFailure> {
  const RequiredField.pure() : super.pure('');

  const RequiredField.dirty(super.value) : super.dirty();

  @override
  validator(String value) {
    return value.isNotEmpty == true ? null : RequiredFieldFailure();
  }

  const RequiredField.fromJson(super.json) : super.dirty();

  String toJson() {
    return super.value;
  }
}
