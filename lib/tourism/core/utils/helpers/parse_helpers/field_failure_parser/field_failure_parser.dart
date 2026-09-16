import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:skygate/tourism/core/utils/failures/field_failure/custom_field_failure.dart';
import 'package:skygate/tourism/core/utils/helpers/parse_helpers/field_failure_parser/credit_card_expiry_date_field_failure_parser.dart';
import 'package:skygate/tourism/core/utils/helpers/parse_helpers/field_failure_parser/credit_card_pin_code_field_failure_parser.dart';
import 'package:skygate/tourism/core/utils/helpers/parse_helpers/field_failure_parser/credit_cvc_number_field_failure_parser.dart';
import 'package:skygate/tourism/core/utils/helpers/parse_helpers/field_failure_parser/password_field_failure_parser.dart';
import 'package:skygate/tourism/core/utils/helpers/parse_helpers/field_failure_parser/phone_number_field_parser.dart';
import '../../../failures/field_failure/confirm_password_field_failure.dart';
import '../../../failures/field_failure/credit_card_expiry_date_field_failure.dart';
import '../../../failures/field_failure/credit_card_number_field_failure.dart';
import '../../../failures/field_failure/credit_card_pin_code_field_failure.dart';
import '../../../failures/field_failure/credit_cvc_number_field_failure.dart';
import '../../../failures/field_failure/email_faild_failure.dart';
import '../../../failures/field_failure/field_failure.dart';
import '../../../failures/field_failure/otp_field_failure.dart';
import '../../../failures/field_failure/password_field_failure.dart';
import '../../../failures/field_failure/phone_number_field_failure.dart';
import '../../../failures/field_failure/required_field_failure.dart';
import 'confirm_password_field_failure_parser.dart';
import 'credit_card_number_field_failure_parser.dart';
import 'email_field_parser.dart';
import 'otp_field_failurere_parser.dart';

class FieldFailureParser {
  static String mapFieldFailureToErrorMessage({
    required FieldFailure failure,
    required BuildContext context,
  }) {
    if (failure is RequiredFieldFailure) {
      return tr('fieldRequiredError');
    } else if (failure is PasswordFieldFailure) {
      return PasswordFieldFailureParser.mapFieldFailureToErrorMessage(
        failure: failure,
        context: context,
      );
    } else if (failure is PhoneNumberFieldFailure) {
      return PhoneNumberFieldFailureParser.mapFieldFailureToErrorMessage(
        failure: failure,
        context: context,
      );
    } else if (failure is OtpFieldFailure) {
      return OtpFieldFailureParser.mapFieldFailureToErrorMessage(
        failure: failure,
        context: context,
      );
    } else if (failure is ConfirmPasswordFieldFailure) {
      return ConfirmPasswordFieldFailureParser.mapFieldFailureToErrorMessage(
        failure: failure,
        context: context,
      );
    } else if (failure is EmailFieldFailure) {
      return EmailFieldFailureParser.mapFieldFailureToErrorMessage(
        failure: failure,
        context: context,
      );
    } else if (failure is CreditCardNumberFieldFailure) {
      return CreditCardNumberFailureParser.mapFieldFailureToErrorMessage(
        failure: failure,
        context: context,
      );
    } else if (failure is CreditCVCNumberFieldFailure) {
      return CreditCardCVCNumberFailureParser.mapFieldFailureToErrorMessage(
        failure: failure,
        context: context,
      );
    } else if (failure is CreditCardExpiryDateFieldFailure) {
      return CreditCardExpiryDateFailureParser.mapFieldFailureToErrorMessage(
        failure: failure,
        context: context,
      );
    } else if (failure is CreditCardPINCodeFieldFailure) {
      return CreditCardPINCodeFailureParser.mapFieldFailureToErrorMessage(
        failure: failure,
        context: context,
      );
    } else if (failure is CustomFieldFailure) {
      return failure.message;
    } else {
      return tr('invalidFieldInfo');
    }
  }
}
