part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

// ── GET app/home → the `user` block ────────────────────────────────────────
final class ProfileLoading extends ProfileState {}

final class ProfileLoaded extends ProfileState {}

final class ProfileError extends ProfileState {
  final String message;

  ProfileError({required this.message});
}

// ── "تعديل معلومات الحساب" ─────────────────────────────────────────────────
final class ProfileImagePicked extends ProfileState {}

final class AccountSaving extends ProfileState {}

final class AccountSaved extends ProfileState {}

final class AccountSaveError extends ProfileState {
  final String message;

  AccountSaveError({required this.message});
}

// ── "تعديل كلمة السر" ──────────────────────────────────────────────────────
final class PasswordVisibilityToggled extends ProfileState {}

final class PasswordSaving extends ProfileState {}

final class PasswordSaved extends ProfileState {}

final class PasswordSaveError extends ProfileState {
  final String message;

  PasswordSaveError({required this.message});
}

// ── "تعديل معلومات جواز السفر" ─────────────────────────────────────────────
final class PassportFieldChanged extends ProfileState {}

final class PassportScanLoading extends ProfileState {}

final class PassportScanned extends ProfileState {}

final class PassportScanCancelled extends ProfileState {}

final class PassportScanError extends ProfileState {
  final String message;

  PassportScanError({required this.message});
}

final class PassportSaving extends ProfileState {}

final class PassportSaved extends ProfileState {}

final class PassportSaveError extends ProfileState {
  final String message;

  PassportSaveError({required this.message});
}

// ── "ملفات المسافر" ────────────────────────────────────────────────────────
final class DocumentsLoading extends ProfileState {}

final class DocumentsLoaded extends ProfileState {}

final class DocumentsError extends ProfileState {
  final String message;

  DocumentsError({required this.message});
}

final class DocumentPicked extends ProfileState {}

final class DocumentsSaving extends ProfileState {}

final class DocumentsSaved extends ProfileState {}

final class DocumentsSaveError extends ProfileState {
  final String message;

  DocumentsSaveError({required this.message});
}

final class FileTooLarge extends ProfileState {}
