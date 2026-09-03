import 'package:formz/formz.dart';
import '../failures/field_failure/required_field_failure.dart';

class ConditionalRequiredField extends FormzInput<String, RequiredFieldFailure> {
  bool required;
  ConditionalRequiredField.pure(this.required) : super.pure('');
  ConditionalRequiredField.dirty(String value,this.required) : super.dirty(value);

  @override
  validator(String value) {
    if(required) {
      return value.isNotEmpty == true ? null : RequiredFieldFailure();
    } else {
      return null;
    }
  }
  ConditionalRequiredField.fromJson(String json,this.required)
      : super.dirty(json);

  String toJson() {
    return super.value;
  }

}
