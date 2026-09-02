import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/constants/api_endpoints.dart';
import 'package:skygate/core/services/dio_service.dart';
import 'package:skygate/core/services/trip_service.dart';
import 'package:skygate/core/utils/api_error.dart';
import 'package:skygate/core/utils/app_phone.dart';
import 'package:skygate/core/utils/cache_util.dart';
import 'package:skygate/features/auth/models/auth_user_model.dart';

part 'auth_state.dart';

/// Which credential the login card is asking for. The design ships both
/// variants of the same card and swaps them with the outlined button.
enum LoginMethod { phone, email }

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  AuthCubit get(BuildContext context) => BlocProvider.of(context);

  /// Cache key holding the bearer token; `main.dart` reads it to decide
  /// whether the app opens on the auth flow or on the home tabs.
  static const String tokenKey = 'token';

  static bool get isLoggedIn {
    final token = CacheUtil.get(key: tokenKey);
    return token is String && token.isNotEmpty;
  }

  /// Cache key holding the pilgrim id created with the account.
  static const String pilgrimIdKey = 'pilgrim_id';

  /// Re-attaches the token when one survived the last run. Called once from
  /// `main.dart`, after [CacheUtil.init].
  static void restoreSession() {
    final token = CacheUtil.get(key: tokenKey);
    if (token is! String || token.isEmpty) return;
    DioService.updateToken(token);
  }

  // ── Form ───────────────────────────────────────────────────────────────
  /// Opens on the dial code so the common case is no extra typing; a pilgrim
  /// abroad edits it. Nothing is ever assumed on their behalf — see [AppPhone].
  final TextEditingController phoneController = TextEditingController(
    text: AppPhone.defaultDialCode,
  );
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginMethod method = LoginMethod.phone;
  bool obscurePassword = true;

  bool get isPhoneLogin => method == LoginMethod.phone;

  /// Swaps the card between "تسجيل باستخدام رقم الهاتف" and "... الإيميل".
  void switchMethod() {
    method = isPhoneLogin ? LoginMethod.email : LoginMethod.phone;
    emit(LoginMethodChanged());
  }

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    emit(PasswordVisibilityChanged());
  }

  // ── Login ──────────────────────────────────────────────────────────────
  AuthUserModel? user;

  /// `POST auth/login`. The documented body is `mobile` + `password`; the
  /// design's second card variant sends `email` instead.
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
          debugPrint('login error: $error');
          emit(LoginError(message: messageOf(error)));
        });
  }

  // ── Forgot password ────────────────────────────────────────────────────
  /// Not part of the OpenAPI document — the path and body are still a guess.
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
      debugPrint('forgotPassword error: $error');
      emit(ForgotPasswordError(message: messageOf(error)));
    });
  }

  /// Stores the token — and the pilgrim id `app/pilgrim-documents` needs —
  /// then attaches the token to every later request.
  ///
  /// The trip kept from the previous session is dropped first: the next
  /// account must not open the browse screens on someone else's trip.
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

  /// Shared by [RegisterCubit]. Delegates to [ApiError] so error copy lives in
  /// exactly one place.
  static String messageOf(dynamic error) => ApiError.messageOf(error);

  /// Called by [RegisterCubit] once the signup response comes back.
  static void persist(AuthUserModel user) => _persistSession(user);

  @override
  Future<void> close() {
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
