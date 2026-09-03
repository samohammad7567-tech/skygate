import 'package:formz/formz.dart';
import '../failures/field_failure/email_faild_failure.dart';
import '../helpers/regular_expression_helper.dart';



class EmailField extends FormzInput<String, EmailFieldFailure> {
  EmailField.pure() : super.pure('');

  EmailField.dirty(String value) : super.dirty(value);

  @override
  validator(String value) {
    if (value.isEmpty) {
      return EmailFieldFailure(EmailError.empty);
    }
    if (!RegularExpressionsHelper.emailReg.hasMatch(value)) {
      return EmailFieldFailure(EmailError.notValid);
    }
    return null;
  }

  factory EmailField.fromJson(String json) {
    return EmailField.dirty(json);
  }

  String toJson() {
    return super.value;
  }
}
