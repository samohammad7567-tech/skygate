import 'package:formz/formz.dart';
import '../failures/field_failure/required_field_failure.dart';

class RequiredField extends FormzInput<String, RequiredFieldFailure> {
  RequiredField.pure() : super.pure('');

  RequiredField.dirty(String value) : super.dirty(value);

  @override
  validator(String value) {
    return value.isNotEmpty == true ? null : RequiredFieldFailure();
  }

  RequiredField.fromJson(String json) : super.dirty(json);

  String toJson() {
    return super.value;
  }
}
