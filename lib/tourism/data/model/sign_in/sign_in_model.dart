import 'package:formz/formz.dart';
import '../../../core/utils/fields/password_field.dart';
import '../../../core/utils/fields/required_filed.dart';

class _SignInKeys {
  static const userName = 'Card';
  static const password = 'Password';
}

class SignInModel with FormzMixin {
  RequiredField userName;
  PasswordField password;

  SignInModel({required this.userName, required this.password});

  factory SignInModel.empty() {
    return SignInModel(
        userName: RequiredField.dirty(''), password: PasswordField.dirty(''));
  }

  SignInModel copyWith({String? userName, String? password}) {
    return SignInModel(
      userName: RequiredField.dirty(userName ?? this.userName.value),
      password: PasswordField.dirty(password ?? this.password.value),
    );
  }

  @override
  List<FormzInput> get inputs => [userName, password];

  Map<String, dynamic> toJson() {
    return {
      _SignInKeys.userName: userName.toJson(),
      _SignInKeys.password: password.toJson(),
    };
  }
}
