import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_background.dart';
import 'package:skygate/core/components/app_title_header.dart';
import 'package:skygate/core/components/toast.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/auth/controller/cubit/auth_cubit.dart';
import 'package:skygate/features/auth/widgets/login_card.dart';
import 'package:skygate/features/main/views/main_screen.dart';

/// "تسجيل الدخول" — the phone and email variants of the same card.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => AuthCubit(), child: const _LoginBody());
  }
}

class _LoginBody extends StatefulWidget {
  const _LoginBody();

  @override
  State<_LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<_LoginBody> {
  /// Owned by the screen; the cubit only holds the field values.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;
    FocusScope.of(context).unfocus();
    context.read<AuthCubit>().login();
  }

  void _forgotPassword() {
    FocusScope.of(context).unfocus();
    context.read<AuthCubit>().forgotPassword();
  }

  void _onState(BuildContext context, AuthState state) {
    if (state is LoginLoaded) {
      NaivgatorHelper.pushAndRemoveUntilNavigation(context, const MainScreen());
    } else if (state is LoginError) {
      showToast(context, state.message.tr(), isError: true);
    } else if (state is ForgotPasswordSent) {
      showToast(context, 'reset_link_sent'.tr());
    } else if (state is ForgotPasswordError) {
      showToast(context, state.message.tr(), isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: _onState,
            builder: (context, state) {
              final cubit = context.read<AuthCubit>();

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
                child: Column(
                  children: [
                    const AppTitleHeader(showBack: true),
                    const Gap(28),
                    LoginCard(
                      formKey: _formKey,
                      isPhoneLogin: cubit.isPhoneLogin,
                      identifierController: cubit.isPhoneLogin
                          ? cubit.phoneController
                          : cubit.emailController,
                      passwordController: cubit.passwordController,
                      obscurePassword: cubit.obscurePassword,
                      isLoading: state is LoginLoading,
                      onTogglePassword: cubit.togglePasswordVisibility,
                      onForgotPassword: _forgotPassword,
                      onSubmit: _submit,
                      onSwitchMethod: cubit.switchMethod,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
