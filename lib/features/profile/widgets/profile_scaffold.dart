import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/features/profile/controller/cubit/profile_cubit.dart';
import 'package:skygate/features/profile/widgets/profile_header.dart';

class ProfileScaffold extends StatelessWidget {
  const ProfileScaffold({
    super.key,
    required this.title,
    required this.children,
    this.onBack,
    this.onMenuTap,
    this.showBack = true,
    this.padding = const EdgeInsets.fromLTRB(20, 22, 20, 32),
  });

  final String title;
  final List<Widget> children;
  final VoidCallback? onBack;
  final VoidCallback? onMenuTap;

  /// A tab root has nothing to pop, so the shell's tabs clear this. Every
  /// pushed screen leaves it on.
  final bool showBack;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final user = context.read<ProfileCubit>().user;

          return Column(
            children: [
              ProfileHeader(
                title: title,
                name: user?.fullName ?? '',
                avatarUrl: user?.avatar,
                onBack: onBack,
                onMenuTap: onMenuTap,
                showBack: showBack,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: padding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [...children, const Gap(8)],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
