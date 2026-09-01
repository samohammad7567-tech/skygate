part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class LoginMethodChanged extends AuthState {}

final class PasswordVisibilityChanged extends AuthState {}

final class LoginLoading extends AuthState {}

final class LoginLoaded extends AuthState {}

final class LoginError extends AuthState {
  final String message;

  LoginError({required this.message});
}

final class ForgotPasswordLoading extends AuthState {}

final class ForgotPasswordSent extends AuthState {}

final class ForgotPasswordError extends AuthState {
  final String message;

  ForgotPasswordError({required this.message});
}
