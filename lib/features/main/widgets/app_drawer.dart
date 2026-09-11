import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/features/auth/controller/cubit/auth_cubit.dart';
import 'package:skygate/features/main/widgets/app_drawer_body.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      // The panel is a plain rectangle in the design — the only rounded corner
      // is the one on the blue header. Material's default would round the
      // drawer's own inner edge on top of it.
      shape: const RoundedRectangleBorder(),
      child: BlocProvider(
        create: (_) => AuthCubit(),
        child: const AppDrawerBody(),
      ),
    );
  }
}
