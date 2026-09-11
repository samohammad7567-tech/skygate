import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/components/toast.dart';
import 'package:skygate/features/home/controller/cubit/home_cubit.dart';
import 'package:skygate/features/home/views/home_screen.dart';
import 'package:skygate/features/main/controller/cubit/main_cubit.dart';
import 'package:skygate/features/main/models/back_action.dart';
import 'package:skygate/features/main/widgets/app_bottom_nav_bar.dart';
import 'package:skygate/features/main/widgets/app_drawer.dart';
import 'package:skygate/features/main/widgets/main_tabs_view.dart';
import 'package:skygate/features/map/views/map_screen.dart';
import 'package:skygate/features/profile/views/profile_screen.dart';
import 'package:skygate/features/settings/views/settings_screen.dart';
import 'package:skygate/features/sos/controller/cubit/sos_cubit.dart';
import 'package:skygate/features/trips/views/trips_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // The drawer belongs to the shell rather than to each tab: one panel behind
  // all five, and a handle the back press can reach.
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() => _scaffoldKey.currentState?.openDrawer();

  late final List<Widget> _tabs = [
    HomeScreen(onMenuTap: _openDrawer),
    TripsScreen(onMenuTap: _openDrawer),
    MapScreen(onMenuTap: _openDrawer),
    ProfileScreen(onMenuTap: _openDrawer),
    SettingsScreen(onMenuTap: _openDrawer),
  ];

  /// An open drawer takes the press first. `PopScope` makes the navigator
  /// claim it, so `ScaffoldState` — which otherwise closes the drawer from
  /// its own `didPopRoute` — never hears about it.
  void _onBack(MainCubit cubit) {
    final scaffold = _scaffoldKey.currentState;
    if (scaffold != null && scaffold.isDrawerOpen) {
      scaffold.closeDrawer();
      return;
    }

    switch (cubit.pressBack()) {
      case BackAction.goHome:
        break;
      case BackAction.warnBeforeExit:
        showToast(context, 'press_back_again_to_exit'.tr());
      case BackAction.exitApp:
        SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeCubit()),
        BlocProvider(create: (_) => SosCubit()),
      ],
      child: BlocBuilder<MainCubit, MainState>(
        builder: (context, state) {
          final cubit = context.read<MainCubit>();

          return PopScope(
            // The shell is the last route, so a press here never pops — it
            // walks the reader to الرئيسية and then out of the app.
            canPop: false,
            onPopInvokedWithResult: (didPop, _) {
              if (didPop) return;
              _onBack(cubit);
            },
            child: Scaffold(
              key: _scaffoldKey,
              drawer: const AppDrawer(),
              extendBody: true,
              body: MainTabsView(
                tabs: _tabs,
                currentIndex: cubit.currentIndex,
                hasVisited: cubit.hasVisited,
              ),
              bottomNavigationBar: AppBottomNavBar(
                currentIndex: cubit.currentIndex,
                onTap: cubit.changeTab,
              ),
            ),
          );
        },
      ),
    );
  }
}
