import 'package:flutter/material.dart';
import '../../../failures/field_failure/credit_cvc_number_field_failure.dart';

class CreditCardCVCNumberFailureParser {
  static String mapFieldFailureToErrorMessage({
    required BuildContext context,
    required CreditCVCNumberFieldFailure failure,
  }) {
    switch (failure.error) {
      case CardCVCNumberError.notValid:
        return "Please, enter valid cvc number.";
      case CardCVCNumberError.empty:
        return "Please, enter your card cvc number.";
    }
  }
}
