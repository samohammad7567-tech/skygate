import 'package:formz/formz.dart';
import '../failures/field_failure/required_field_failure.dart';

class ConditionalRequiredField
    extends FormzInput<String, RequiredFieldFailure> {
  final bool required;
  const ConditionalRequiredField.pure(this.required) : super.pure('');
  const ConditionalRequiredField.dirty(super.value, this.required)
    : super.dirty();

  @override
  validator(String value) {
    if (required) {
      return value.isNotEmpty == true ? null : RequiredFieldFailure();
    } else {
      return null;
    }
  }

  const ConditionalRequiredField.fromJson(super.json, this.required)
    : super.dirty();

  String toJson() {
    return super.value;
  }
}
