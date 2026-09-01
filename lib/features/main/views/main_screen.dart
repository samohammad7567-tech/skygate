import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/features/account/views/account_screen.dart';
import 'package:skygate/features/home/controller/cubit/home_cubit.dart';
import 'package:skygate/features/home/views/home_screen.dart';
import 'package:skygate/features/main/controller/cubit/main_cubit.dart';
import 'package:skygate/features/main/widgets/app_bottom_nav_bar.dart';
import 'package:skygate/features/map/views/map_screen.dart';
import 'package:skygate/features/settings/views/settings_screen.dart';
import 'package:skygate/features/trips/views/trips_screen.dart';

/// Tab shell holding the five bottom-nav destinations.
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  static const List<Widget> _tabs = [
    HomeScreen(),
    TripsScreen(),
    MapScreen(),
    AccountScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: BlocBuilder<MainCubit, MainState>(
        builder: (context, state) {
          final cubit = context.read<MainCubit>();

          return Scaffold(
            extendBody: true,
            body: IndexedStack(index: cubit.currentIndex, children: _tabs),
            bottomNavigationBar: AppBottomNavBar(
              currentIndex: cubit.currentIndex,
              onTap: cubit.changeTab,
            ),
          );
        },
      ),
    );
  }
}
