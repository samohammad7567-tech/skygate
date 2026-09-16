import 'package:formz/formz.dart';
import '../../../core/utils/fields/confirm_password_field.dart';
import '../../../core/utils/fields/otp_field.dart';
import '../../../core/utils/fields/password_field.dart';

class _ForgetPasswordOtpModelKeys {
  static const String otp = 'OTP';
  static const String password = 'Password';
  static const String cardNumber = 'Membercard';
}

class ForgetPasswordOtpModel with FormzMixin {
  OtpField otp;
  PasswordField newPassword;
  ConfirmPasswordField confirmPassword;
  String cardNumber;

  ForgetPasswordOtpModel({
    required this.cardNumber,
    required this.otp,
    required this.newPassword,
    required this.confirmPassword,
  });

  factory ForgetPasswordOtpModel.empty(int length, String cardNumber) {
    return ForgetPasswordOtpModel(
      otp: OtpField.pure(length: length),
      cardNumber: cardNumber,
      newPassword: PasswordField.pure(),
      confirmPassword: ConfirmPasswordField.pure(originPassword: ''),
    );
  }

  ForgetPasswordOtpModel copyWith({
    OtpField? otp,
    String? cardNumber,
    PasswordField? newPassword,
    ConfirmPasswordField? confirmPassword,
  }) {
    return ForgetPasswordOtpModel(
      otp: otp ?? this.otp,
      cardNumber: cardNumber ?? this.cardNumber,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      _ForgetPasswordOtpModelKeys.otp: otp.toJson(),
      _ForgetPasswordOtpModelKeys.cardNumber: cardNumber,
      _ForgetPasswordOtpModelKeys.password: newPassword.toJson(),
    };
  }

  factory ForgetPasswordOtpModel.fromJson(Map<String, dynamic> map, optLength) {
    return ForgetPasswordOtpModel(
      otp: OtpField.fromJson(
        map[_ForgetPasswordOtpModelKeys.otp] ?? '',
        optLength,
      ),
      cardNumber: map[_ForgetPasswordOtpModelKeys.cardNumber] ?? '',
      newPassword: PasswordField.fromJson(
        map[_ForgetPasswordOtpModelKeys.password] ?? '',
      ),
      confirmPassword: ConfirmPasswordField.fromJson(
        '',
        map[_ForgetPasswordOtpModelKeys.password] ?? '',
      ),
    );
  }

  @override
  List<FormzInput> get inputs => [otp, newPassword, confirmPassword];
}
