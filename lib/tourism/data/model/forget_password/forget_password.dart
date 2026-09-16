import 'package:formz/formz.dart';
import '../../../core/utils/fields/phone_number_filed.dart';
import '../../../core/utils/fields/required_filed.dart';

class _ForgetPasswordKeys {
  static String cardNumber = 'membercard';
  static String dob = 'dob';
  static String mobileNumber = 'mobileNumber';
}

class ForgetPasswordModel with FormzMixin {
  RequiredField cardNumber;
  RequiredField dob;
  PhoneNumberField mobileNumber;

  ForgetPasswordModel({
    required this.cardNumber,
    required this.dob,
    required this.mobileNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      _ForgetPasswordKeys.cardNumber: cardNumber.toJson(),
      _ForgetPasswordKeys.mobileNumber: mobileNumber.toJson(),
      _ForgetPasswordKeys.dob: dob.toJson(),
    };
  }

  factory ForgetPasswordModel.fromJson(Map<String, dynamic> json) {
    return ForgetPasswordModel(
      cardNumber: RequiredField.fromJson(
        json[_ForgetPasswordKeys.cardNumber] ?? '',
      ),
      dob: RequiredField.fromJson(json[_ForgetPasswordKeys.dob] ?? ''),
      mobileNumber: PhoneNumberField.fromJson(
        json[_ForgetPasswordKeys.mobileNumber] ?? '',
      ),
    );
  }

  factory ForgetPasswordModel.empty() {
    return ForgetPasswordModel(
      cardNumber: RequiredField.dirty(''),
      dob: RequiredField.dirty(''),
      mobileNumber: PhoneNumberField.dirty(''),
    );
  }

  ForgetPasswordModel copyWith({
    RequiredField? cardNumber,
    RequiredField? dob,
    PhoneNumberField? mobileNumber,
  }) {
    return ForgetPasswordModel(
      cardNumber: cardNumber ?? this.cardNumber,
      dob: dob ?? this.dob,
      mobileNumber: mobileNumber ?? this.mobileNumber,
    );
  }

  @override
  List<FormzInput> get inputs => [cardNumber, dob, mobileNumber];
}
