import 'package:formz/formz.dart';
import '../../../core/utils/fields/otp_field.dart';

class _VerifySignUpModelKeys {
  static const String otp = 'OTP';
  static const String password = 'Password';
  static const String cardNumber = 'membercard';
}

class VerifySignUpModel with FormzMixin {
  OtpField otp;
  String password;
  String cardNumber;

  VerifySignUpModel({
    required this.cardNumber,
    required this.otp,
    required this.password,
  });

  factory VerifySignUpModel.empty(
    int length,
    String cardNumber,
    String password,
  ) {
    return VerifySignUpModel(
      otp: OtpField.pure(length: length),
      cardNumber: cardNumber,
      password: password,
    );
  }

  VerifySignUpModel copyWith({OtpField? otp}) {
    return VerifySignUpModel(
      otp: otp ?? this.otp,
      cardNumber: cardNumber,
      password: password,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      _VerifySignUpModelKeys.otp: otp.toJson(),
      _VerifySignUpModelKeys.cardNumber: cardNumber,
      _VerifySignUpModelKeys.password: password,
    };
  }

  factory VerifySignUpModel.fromJson(Map<String, dynamic> map, optLength) {
    return VerifySignUpModel(
      otp: OtpField.fromJson(
        map[_VerifySignUpModelKeys.password] ?? '',
        optLength,
      ),
      cardNumber: map[_VerifySignUpModelKeys.cardNumber] ?? '',
      password: map[_VerifySignUpModelKeys.password] ?? '',
    );
  }

  @override
  List<FormzInput> get inputs => [otp];
}
