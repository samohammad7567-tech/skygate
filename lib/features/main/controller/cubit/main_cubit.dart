import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/utils/cache_util.dart';

part 'main_state.dart';

/// Owns the selected bottom-nav tab and the app-wide theme mode.
class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainInitial());

  MainCubit get(BuildContext context) => BlocProvider.of(context);

  int currentIndex = 0;

  bool isDark = false;

  void changeTab(int index) {
    if (currentIndex == index) return;
    currentIndex = index;
    emit(TabChanged());
  }

  /// Restores the persisted theme choice. Call once at startup.
  void loadTheme() {
    isDark = (CacheUtil.get(key: 'isDark') as bool?) ?? false;
    emit(ThemeChanged());
  }

  Future<void> toggleTheme() async {
    isDark = !isDark;
    await CacheUtil.setBool(key: 'isDark', value: isDark);
    emit(ThemeChanged());
  }
}
