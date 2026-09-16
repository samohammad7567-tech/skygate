import 'field_failure.dart';

enum CardExpiryDateError { empty, notValid, expired }

class CreditCardExpiryDateFieldFailure extends FieldFailure {
  CardExpiryDateError error;

  CreditCardExpiryDateFieldFailure(this.error);
}
