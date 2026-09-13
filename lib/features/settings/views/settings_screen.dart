import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/features/auth/controller/cubit/auth_cubit.dart';
import 'package:skygate/features/settings/controller/cubit/settings_cubit.dart';
import 'package:skygate/features/settings/widgets/settings_body.dart';

/// "الإعدادات" — every preference the pilgrim can turn, and the way out of
/// the session.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, this.onMenuTap, this.showBack = false});

  /// Opens the shell's drawer. The shell owns the panel, so a tab only
  /// forwards the tap.
  final VoidCallback? onMenuTap;

  /// A tab root has nothing to pop; reached as a pushed route it does.
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
