import 'package:flutter/material.dart';

import '../../../failures/field_failure/credit_card_pin_code_field_failure.dart';


class CreditCardPINCodeFailureParser{
  static String mapFieldFailureToErrorMessage({
    required BuildContext context,
    required CreditCardPINCodeFieldFailure failure,
  }) {
    switch(failure.error) {
      case CardPINCodeError.notValid:
        return "Please, enter valid card pin code.";
      case CardPINCodeError.empty:
        return "Please, enter your credit card pin code.";
    }
  }
}
