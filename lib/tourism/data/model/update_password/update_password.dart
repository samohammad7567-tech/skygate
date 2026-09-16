import 'package:formz/formz.dart';
import '../../../core/utils/fields/confirm_password_field.dart';
import '../../../core/utils/fields/password_field.dart';

class _UpdatePasswordModelKeys {
  static const String memberCard = 'membercard';
  static const String oldPassword = 'oldPassword';
  static const String newPassword = 'newPassword';
}

class UpdatePasswordModel with FormzMixin {
  PasswordField oldPassword;
  PasswordField newPassword;
  ConfirmPasswordField confirmNewPassword;
  String memberCard;

  UpdatePasswordModel({
    required this.memberCard,
    required this.oldPassword,
    required this.newPassword,
    required this.confirmNewPassword,
  });

  factory UpdatePasswordModel.empty(String memberCard) {
    return UpdatePasswordModel(
      memberCard: memberCard,
      oldPassword: PasswordField.pure(),
      newPassword: PasswordField.pure(),
      confirmNewPassword: ConfirmPasswordField.pure(originPassword: ''),
    );
  }

  UpdatePasswordModel copyWith({
    String? memberCard,
    PasswordField? oldPassword,
    PasswordField? newPassword,
    ConfirmPasswordField? confirmNewPassword,
  }) {
    return UpdatePasswordModel(
      memberCard: memberCard ?? this.memberCard,
      oldPassword: oldPassword ?? this.oldPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmNewPassword: confirmNewPassword ?? this.confirmNewPassword,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      _UpdatePasswordModelKeys.memberCard: memberCard,
      _UpdatePasswordModelKeys.oldPassword: oldPassword.toJson(),
      _UpdatePasswordModelKeys.newPassword: newPassword.toJson(),
    };
  }

  @override
  List<FormzInput> get inputs => [oldPassword, newPassword, confirmNewPassword];
}
