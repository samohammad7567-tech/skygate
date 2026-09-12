import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/utils/app_scale.dart';
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
    this.padding,
  });

  final String title;
  final List<Widget> children;
  final VoidCallback? onBack;
  final VoidCallback? onMenuTap;

  /// A tab root has nothing to pop, so the shell's tabs clear this. Every
  /// pushed screen leaves it on.
  final bool showBack;

  /// Defaults to the design's 20/22/20/32 inset, scaled.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final user = context.read<ProfileCubit>().user;

          return SafeArea(
            // The header used to run under the status bar on its own coloured
            // plate; with the plate gone the inset is the scaffold's to add,
            // the same way every other tab adds it.
            bottom: false,
            child: Column(
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
                    padding:
                        padding ?? EdgeInsets.fromLTRB(20.s, 22.s, 20.s, 32.s),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [...children, Gap(8.s)],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
