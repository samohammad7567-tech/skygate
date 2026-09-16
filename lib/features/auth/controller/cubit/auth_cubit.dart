import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/constants/api_endpoints.dart';
import 'package:skygate/core/services/dio_service.dart';
import 'package:skygate/core/services/realtime_service.dart';
import 'package:skygate/core/services/trip_service.dart';
import 'package:skygate/core/utils/api_error.dart';
import 'package:skygate/core/utils/app_phone.dart';
import 'package:skygate/core/utils/cache_util.dart';
import 'package:skygate/features/auth/models/auth_user_model.dart';

part 'auth_state.dart';

enum LoginMethod { phone, email }

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  AuthCubit get(BuildContext context) => BlocProvider.of(context);
  static const String tokenKey = 'token';

  static bool get isLoggedIn {
    final token = CacheUtil.get(key: tokenKey);
    return token is String && token.isNotEmpty;
  }

  static const String pilgrimIdKey = 'pilgrim_id';
  static void restoreSession() {
    final token = CacheUtil.get(key: tokenKey);
    if (token is! String || token.isEmpty) return;
    DioService.updateToken(token);
  }

  final TextEditingController phoneController = TextEditingController(
    text: AppPhone.defaultDialCode,
  );
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginMethod method = LoginMethod.phone;
  bool obscurePassword = true;

  bool get isPhoneLogin => method == LoginMethod.phone;
  void switchMethod() {
    method = isPhoneLogin ? LoginMethod.email : LoginMethod.phone;
    emit(LoginMethodChanged());
  }

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    emit(PasswordVisibilityChanged());
  }

  AuthUserModel? user;
  Future<void> login() async {
    emit(LoginLoading());
    return DioService.post(
          ApiEndpoints.login,
          data: {
            if (isPhoneLogin)
              'mobile': AppPhone.normalize(phoneController.text)
            else
              'email': emailController.text.trim(),
            'password': passwordController.text,
          },
        )
        .then((response) {
          user = AuthUserModel.fromJson(response.data);
          _persistSession(user!);
          emit(LoginLoaded());
        })
        .catchError((error) {
          debugPrint('login error: ${_describe(error)}');
          emit(LoginError(message: messageOf(error)));
        });
  }

  Future<void> forgotPassword() async {
    emit(ForgotPasswordLoading());
    return DioService.post(
      ApiEndpoints.forgotPassword,
      data: {
        if (isPhoneLogin)
          'mobile': AppPhone.normalize(phoneController.text)
        else
          'email': emailController.text.trim(),
      },
    ).then((_) => emit(ForgotPasswordSent())).catchError((error) {
      debugPrint('forgotPassword error: ${_describe(error)}');
      emit(ForgotPasswordError(message: messageOf(error)));
    });
  }

  static void _persistSession(AuthUserModel user) {
    TripService.clear();

    final pilgrimId = user.pilgrimId;
    if (pilgrimId != null) {
      CacheUtil.setInt(key: pilgrimIdKey, value: pilgrimId);
    }

    final token = user.token;
    if (token == null || token.isEmpty) return;
    CacheUtil.setString(key: tokenKey, value: token);

    final refreshToken = user.refreshToken;
    if (refreshToken != null && refreshToken.isNotEmpty) {
      CacheUtil.setString(key: 'refresh_token', value: refreshToken);
    }

    DioService.updateToken(token);
  }

  Future<void> logout() async {
    emit(LogoutLoading());
    try {
      await DioService.post(ApiEndpoints.logout);
    } catch (error) {
      debugPrint('logout error: ${_describe(error)}');
    }
    clearSession();
    emit(LogoutDone());
  }

  static void clearSession() {
    // A forgotten socket keeps draining the battery long after the session is
    // gone, and would keep delivering another account's trip traffic.
    unawaited(RealtimeService.shutdown());
    TripService.clear();
    CacheUtil.remove(key: tokenKey);
    CacheUtil.remove(key: pilgrimIdKey);
    CacheUtil.remove(key: 'refresh_token');
    DioService.updateToken(null);
  }

  static String messageOf(dynamic error) => ApiError.messageOf(error);
  static String _describe(Object? error) {
    if (error is! DioException) return '$error';

    final request = error.requestOptions;
    final response = error.response;
    final location = response?.headers.value('location');

    return [
      '${request.method} ${request.uri}',
      if (response != null) '-> ${response.statusCode}',
      if (location != null) 'Location: $location',
      error.message ?? error.type.name,
    ].join(' | ');
  }

  static void persist(AuthUserModel user) => _persistSession(user);

  @override
  Future<void> close() {
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
