import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/confirm_dialog.dart';
import 'package:skygate/core/components/toast.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/constants/profile_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/auth/controller/cubit/auth_cubit.dart';
import 'package:skygate/features/auth/views/auth_landing_screen.dart';
import 'package:skygate/features/profile/controller/cubit/profile_cubit.dart';
import 'package:skygate/features/profile/views/edit_password_screen.dart';
import 'package:skygate/features/profile/views/edit_profile_screen.dart';
import 'package:skygate/features/profile/views/passport_info_screen.dart';
import 'package:skygate/features/profile/views/pilgrim_files_screen.dart';
import 'package:skygate/core/components/app_list_card.dart';
import 'package:skygate/features/profile/widgets/profile_scaffold.dart';
import 'package:skygate/core/components/app_section_title.dart';
import 'package:skygate/features/profile/widgets/profile_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, this.onMenuTap});

  /// Opens the shell's drawer. The shell owns the panel, so a tab only
  /// forwards the tap.
  final VoidCallback? onMenuTap;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProfileCubit()..getProfile()),
        BlocProvider(create: (_) => AuthCubit()),
      ],
      child: ProfileView(onMenuTap: onMenuTap),
    );
  }
}

class ProfileView extends StatefulWidget {
  const ProfileView({super.key, this.onMenuTap});

  /// Opens the shell's drawer. The shell owns the panel, so a tab only
  /// forwards the tap.
  final VoidCallback? onMenuTap;

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  void _open(Widget screen) {
    NaivgatorHelper.pushNavigation(
      context,
      BlocProvider.value(value: context.read<ProfileCubit>(), child: screen),
    );
  }

  Future<void> _confirmLogout() async {
    final authCubit = context.read<AuthCubit>();

    final confirmed = await showConfirmDialog(
      context,
      message: 'logout_question'.tr(),
      confirmKey: 'yes',
      cancelKey: 'no',
      asset: ProfileAssets.logout,
      tint: AppColors.error,
    );

    if (!confirmed || authCubit.isClosed) return;
    await authCubit.logout();
  }

  void _onAuthState(BuildContext context, AuthState state) {
    // The session is already cleared by the time this arrives, so every route
    // behind the tab shell goes with it.
    if (state is LogoutDone) {
      NaivgatorHelper.pushAndRemoveUntilNavigation(
        context,
        const AuthLandingScreen(),
      );
    }
  }

  void _onProfileState(BuildContext context, ProfileState state) {
    if (state is ProfileError) {
      showToast(context, state.message.tr(), isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthState>(listener: _onAuthState),
        BlocListener<ProfileCubit, ProfileState>(listener: _onProfileState),
      ],
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final cubit = context.read<ProfileCubit>();
          final user = cubit.user;

          return ProfileScaffold(
            title: 'nav_account'.tr(),
            onMenuTap: widget.onMenuTap,
            // A tab root has nothing to pop; the system back button is what
            // walks the reader to الرئيسية and then out.
            showBack: false,
            children: [
              AppSectionTitle(text: 'profile_information'.tr()),
              Gap(12.s),
              AppListCard(
                children: [
                  ProfileTile(
                    icon: ProfileAssets.account,
                    title: 'username'.tr(),
                    subtitle: user?.fullName,
                  ),
                  ProfileTile(
                    icon: ProfileAssets.phone,
                    title: 'phone_number'.tr(),
                    subtitle: user?.mobile,
                  ),
                  ProfileTile(
                    icon: ProfileAssets.mail,
                    title: 'email'.tr(),
                    subtitle: user?.email,
                  ),
                ],
              ),
              Gap(14.s),
              AppListCard(
                children: [
                  ProfileTile(
                    icon: ProfileAssets.passport,
                    title: 'passport_information'.tr(),
                    subtitle: user?.passportNumber,
                    showChevron: true,
                    onTap: () => _open(const PassportInfoScreen()),
                  ),
                ],
              ),
              Gap(14.s),
              AppListCard(
                children: [
                  ProfileTile(
                    icon: ProfileAssets.files,
                    title: 'files'.tr(),
                    subtitle: 'pilgrim_files'.tr(),
                    showChevron: true,
                    onTap: () => _open(const PilgrimFilesScreen()),
                  ),
                ],
              ),
              Gap(22.s),
              AppSectionTitle(text: 'account_management'.tr()),
              Gap(12.s),
              AppListCard(
                children: [
                  ProfileTile(
                    icon: ProfileAssets.lock,
                    title: 'password'.tr(),
                    subtitle: 'edit_password'.tr(),
                    showChevron: true,
                    onTap: () => _open(const EditPasswordScreen()),
                  ),
                  ProfileTile(
                    icon: ProfileAssets.edit,
                    title: 'edit_account'.tr(),
                    subtitle: 'edit_account_information'.tr(),
                    showChevron: true,
                    onTap: () => _open(const EditProfileScreen()),
                  ),
                  ProfileTile(
                    icon: ProfileAssets.logout,
                    title: 'logout'.tr(),
                    color: AppColors.error,
                    onTap: _confirmLogout,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
