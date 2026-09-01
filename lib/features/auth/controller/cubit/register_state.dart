part of 'register_cubit.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class StepChanged extends RegisterState {}

final class PasswordVisibilityToggled extends RegisterState {}

final class ProfileImagePicked extends RegisterState {}

final class DocumentPicked extends RegisterState {}

/// The picked file is over `ImagePickerService.maxSizeInBytes`.
final class FileTooLarge extends RegisterState {}

final class PassportFieldChanged extends RegisterState {}

final class PassportScanLoading extends RegisterState {}

/// The user dismissed the camera / gallery picker without choosing a file.
final class PassportScanCancelled extends RegisterState {}

final class PassportScanned extends RegisterState {}

final class PassportScanError extends RegisterState {
  final String message;

  PassportScanError({required this.message});
}

final class RegisterLoading extends RegisterState {}

final class RegisterSucceeded extends RegisterState {}

final class RegisterError extends RegisterState {
  final String message;

  RegisterError({required this.message});
}
