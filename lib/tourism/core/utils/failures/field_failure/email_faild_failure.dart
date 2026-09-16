import 'field_failure.dart';

enum EmailError { empty, notValid }

class EmailFieldFailure extends FieldFailure {
  EmailError error;

  EmailFieldFailure(this.error);
}
