import 'field_failure.dart';

enum CardPINCodeError { empty, notValid }

class CreditCardPINCodeFieldFailure extends FieldFailure {
  CardPINCodeError error;

  CreditCardPINCodeFieldFailure(this.error);
}
