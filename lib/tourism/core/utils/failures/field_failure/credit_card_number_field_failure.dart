import 'field_failure.dart';

enum CardNumberError {
  empty,
  notValid,
}
class CreditCardNumberFieldFailure extends FieldFailure{

  CardNumberError error;

  CreditCardNumberFieldFailure(this.error);
}