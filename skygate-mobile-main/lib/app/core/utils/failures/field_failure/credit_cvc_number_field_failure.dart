import 'field_failure.dart';

enum CardCVCNumberError {
  empty,
  notValid,
}
class CreditCVCNumberFieldFailure extends FieldFailure{

  CardCVCNumberError error;

  CreditCVCNumberFieldFailure(this.error);
}