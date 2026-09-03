


import 'field_failure.dart';

enum PasswordError {
  oneUpperCase,
  oneLowerCase,
  oneSpecialCharacter,
  oneNumber,
  lengthError,
  empty,
  match,
}



class PasswordFieldFailure extends FieldFailure{
  PasswordError error;

  PasswordFieldFailure(this.error);
}