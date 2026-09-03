/// Input validation shared by every form.
///
/// Keeps the regular expressions in one place and exposes the boolean checks
/// on top of them, so screens stop re-implementing the same password rules.
class ValidationService {
  ValidationService._();

  static final ValidationService instance = ValidationService._();

  static final RegExp minLength = RegExp(r'^.{8,}');
  static final RegExp upperCase = RegExp(r'^(?=.*?[A-Z])');
  static final RegExp lowerCase = RegExp(r'^(?=.*?[a-z])');
  static final RegExp number = RegExp(r'^(?=.*?[0-9])');
  static final RegExp specialCharacter = RegExp(r'^(?=.*?[!@#\$&*~])');
  static final RegExp phoneNumber = RegExp(r'^(?:[+00]9)?[0-9]{10,14}$');
  static final RegExp email = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  bool hasMinLength(String value) => minLength.hasMatch(value);

  bool hasUpperCase(String value) => upperCase.hasMatch(value);

  bool hasLowerCase(String value) => lowerCase.hasMatch(value);

  bool hasNumber(String value) => number.hasMatch(value);

  bool hasSpecialCharacter(String value) => specialCharacter.hasMatch(value);

  bool isValidEmail(String value) => email.hasMatch(value.trim());

  bool isValidPhone(String value) =>
      phoneNumber.hasMatch(value.replaceAll(' ', ''));

  /// A password is accepted when it satisfies every individual rule.
  bool isStrongPassword(String value) =>
      hasMinLength(value) &&
      hasUpperCase(value) &&
      hasLowerCase(value) &&
      hasNumber(value) &&
      hasSpecialCharacter(value);

  /// The rules [value] still fails, so the UI can show a checklist rather than
  /// a single "invalid password" line.
  List<PasswordRule> failedPasswordRules(String value) => [
        if (!hasMinLength(value)) PasswordRule.minLength,
        if (!hasUpperCase(value)) PasswordRule.upperCase,
        if (!hasLowerCase(value)) PasswordRule.lowerCase,
        if (!hasNumber(value)) PasswordRule.number,
        if (!hasSpecialCharacter(value)) PasswordRule.specialCharacter,
      ];

  bool isNotEmpty(String? value) => value != null && value.trim().isNotEmpty;
}

enum PasswordRule {
  minLength,
  upperCase,
  lowerCase,
  number,
  specialCharacter,
}
