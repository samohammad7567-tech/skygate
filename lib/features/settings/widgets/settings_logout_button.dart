import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/confirm_dialog.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/constants/settings_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/auth/controller/cubit/auth_cubit.dart';
import 'package:skygate/features/auth/views/auth_landing_screen.dart';

/// The outlined "تسجيل الخروج" that closes the page.
class SettingsLogoutButton extends StatelessWidget {
  const SettingsLogoutButton({super.key});

  Future<void> _confirm(BuildContext context) async {
    final authCubit = context.read<AuthCubit>();

    final confirmed = await showConfirmDialog(
      context,
      message: 'logout_question'.tr(),
      confirmKey: 'yes',
      cancelKey: 'no',
      asset: SettingsAssets.logout,
      tint: AppColors.error,
    );

    if (!confirmed || authCubit.isClosed) return;
    await authCubit.logout();
  }

  void _onState(BuildContext context, AuthState state) {
    // The session is already cleared by the time this arrives, so every route
    // behind the tab shell goes with it.
    if (state is LogoutDone) {
      NaivgatorHelper.pushAndRemoveUntilNavigation(
        context,
        const AuthLandingScreen(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<AuthCubit, AuthState>(
      listener: _onState,
      builder: (context, state) => SizedBox(
        height: 50.s,
        width: double.infinity,
        child: OutlinedButton(
          onPressed: state is LogoutLoading ? null : () => _confirm(context),
          style: OutlinedButton.styleFrom(
            backgroundColor: theme.colorScheme.surface,
            side: BorderSide(color: theme.colorScheme.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.s),
            ),
          ),
          child: state is LogoutLoading
              ? SizedBox(
                  height: 20.s,
                  width: 20.s,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.s,
                    color: theme.colorScheme.primary,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        'logout'.tr(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    Gap(10.s),
                    AppImage(
                      SettingsAssets.logout,
                      height: 18.s,
                      width: 18.s,
                      color: theme.colorScheme.primary,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
