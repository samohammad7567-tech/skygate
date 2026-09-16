import 'package:flutter/material.dart';

import '../../../failures/field_failure/credit_card_number_field_failure.dart';

class CreditCardNumberFailureParser {
  static String mapFieldFailureToErrorMessage({
    required BuildContext context,
    required CreditCardNumberFieldFailure failure,
  }) {
    switch (failure.error) {
      case CardNumberError.notValid:
        return "Please, enter valid card number.";
      case CardNumberError.empty:
        return "Please, enter your credit card number.";
    }
  }
}
