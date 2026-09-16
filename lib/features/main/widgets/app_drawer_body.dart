import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/components/confirm_dialog.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/constants/drawer_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/auth/controller/cubit/auth_cubit.dart';
import 'package:skygate/features/auth/views/auth_landing_screen.dart';
import 'package:skygate/features/main/controller/cubit/main_cubit.dart';
import 'package:skygate/features/main/models/drawer_item_model.dart';
import 'package:skygate/features/main/utils/drawer_route.dart';
import 'package:skygate/features/main/widgets/app_drawer_footer.dart';
import 'package:skygate/features/main/widgets/app_drawer_header.dart';
import 'package:skygate/features/main/widgets/app_drawer_section_label.dart';
import 'package:skygate/features/main/widgets/app_drawer_tile.dart';

class AppDrawerBody extends StatelessWidget {
  const AppDrawerBody({super.key});
  void _openItem(BuildContext context, DrawerItemModel item) {
    final mainCubit = context.read<MainCubit>();
    final navigator = Navigator.of(context);

    navigator.pop();

    if (item.isTab) {
      mainCubit.changeTab(item.tabIndex!);
      return;
    }

    navigator.push(MaterialPageRoute(builder: (_) => drawerItemScreen(item)));
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final authCubit = context.read<AuthCubit>();

    final confirmed = await showConfirmDialog(
      context,
      message: 'logout_question'.tr(),
      confirmKey: 'yes',
      cancelKey: 'no',
      asset: DrawerAssets.logout,
      tint: AppColors.error,
    );

    if (!confirmed || authCubit.isClosed) return;
    await authCubit.logout();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainState>(
      builder: (context, _) {
        final currentIndex = context.read<MainCubit>().currentIndex;

        return Column(
          children: [
            const AppDrawerHeader(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(top: 10.s, bottom: 8.s),
                children: [
                  for (final section in DrawerSectionModel.catalogue) ...[
                    if (section.titleKey != null)
                      AppDrawerSectionLabel(titleKey: section.titleKey!),
                    for (final item in section.items)
                      AppDrawerTile(
                        item: item,
                        isSelected: item.tabIndex == currentIndex,
                        onTap: () => _openItem(context, item),
                      ),
                  ],
                ],
              ),
            ),
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is LogoutDone) {
                  NaivgatorHelper.pushAndRemoveUntilNavigation(
                    context,
                    const AuthLandingScreen(),
                  );
                }
              },
              builder: (context, state) => AppDrawerFooter(
                isLoggingOut: state is LogoutLoading,
                onLogout: () => _confirmLogout(context),
              ),
            ),
          ],
        );
      },
    );
  }
}
