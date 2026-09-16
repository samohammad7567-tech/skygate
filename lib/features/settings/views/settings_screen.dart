import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/features/auth/controller/cubit/auth_cubit.dart';
import 'package:skygate/features/settings/controller/cubit/settings_cubit.dart';
import 'package:skygate/features/settings/widgets/settings_body.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, this.onMenuTap, this.showBack = false});
  final VoidCallback? onMenuTap;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SettingsCubit()..loadSettings()),
        BlocProvider(create: (_) => AuthCubit()),
      ],
      child: SafeArea(
        child: SettingsBody(onMenuTap: onMenuTap, showBack: showBack),
      ),
    );
  }
}
