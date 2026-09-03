import 'package:flutter/material.dart';
import '../../../failures/field_failure/credit_card_expiry_date_field_failure.dart';


class CreditCardExpiryDateFailureParser{
  static String mapFieldFailureToErrorMessage({
    required BuildContext context,
    required CreditCardExpiryDateFieldFailure failure,
}) {
    switch(failure.error) {
      case CardExpiryDateError.notValid:
        return "Please, enter valid card expiry date.";
      case CardExpiryDateError.empty:
        return "Please, enter your card expiry date.";
      case CardExpiryDateError.expired:
        return "Sorry, your credit card is no longer valid.";
    }
}
}
