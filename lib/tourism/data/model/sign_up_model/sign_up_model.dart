import 'dart:developer';
import 'dart:io';
import 'package:formz/formz.dart';
import '../../../core/utils/fields/confirm_password_field.dart';
import '../../../core/utils/fields/password_field.dart';
import '../../../core/utils/fields/phone_number_filed.dart';
import '../../../core/utils/fields/required_filed.dart';
import '../../../modules/language/language_controller.dart';
import 'package:get/get.dart';

class _SignUpKeys {
  static const lang = 'Lang';
  static const memberCard = 'MemberCard';
  static const phoneNumber = 'PhoneNumber';
  static const password = 'Password';
  static const memberName = 'MemberName';
  static const dob = 'DOB';
  static const signUpSource = 'SignupSource';
}

class SignUpModel with FormzMixin {
  late String lang;
  RequiredField memberCard;
  PhoneNumberField phoneNumber;
  PasswordField password;
  ConfirmPasswordField confirmPassword;
  RequiredField memberName;
  RequiredField dob;
  late int signUpSource;

  SignUpModel({
    required this.memberCard,
    required this.phoneNumber,
    required this.password,
    required this.confirmPassword,
    required this.memberName,
    required this.dob,
  }) {
    try {
      signUpSource = Platform.isIOS ? 5 : 6;
      lang = Get.find<LanguageController>().appLanguage;
    } catch (e) {
      log("sign up model :$e");
    }
  }

  factory SignUpModel.empty() {
    return SignUpModel(
      memberCard: RequiredField.pure(),
      phoneNumber: PhoneNumberField.pure(),
      password: PasswordField.pure(),
      confirmPassword: ConfirmPasswordField.pure(originPassword: ""),
      memberName: RequiredField.pure(),
      dob: RequiredField.pure(),
    );
  }

  SignUpModel copyWith({
    String? memberCard,
    String? phoneNumber,
    String? password,
    String? confirmPassword,
    String? memberName,
    String? dob,
  }) {
    return SignUpModel(
      memberCard: RequiredField.dirty(memberCard ?? this.memberCard.value),
      phoneNumber: PhoneNumberField.dirty(
        phoneNumber ?? this.phoneNumber.value,
      ),
      password: PasswordField.dirty(password ?? this.password.value),
      confirmPassword: ConfirmPasswordField.dirty(
        confirmPassword ?? this.confirmPassword.value,
        originPassword: password ?? this.password.value,
      ),
      memberName: RequiredField.dirty(memberName ?? this.memberName.value),
      dob: RequiredField.dirty(dob ?? this.dob.value),
    );
  }

  @override
  List<FormzInput> get inputs => [
    memberCard,
    phoneNumber,
    password,
    memberName,
    dob,
  ];

  Map<String, dynamic> toJson() {
    return {
      _SignUpKeys.memberCard: memberCard.value.toString(),
      _SignUpKeys.phoneNumber: phoneNumber.value.toString(),
      _SignUpKeys.password: password.value.toString(),
      _SignUpKeys.memberName: memberName.value.toString(),
      _SignUpKeys.dob: dob.value.toString(),
      _SignUpKeys.lang: lang,
      _SignUpKeys.signUpSource: signUpSource.toString(),
    };
  }
}
