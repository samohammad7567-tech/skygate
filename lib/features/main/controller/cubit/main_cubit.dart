import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/utils/cache_util.dart';
import 'package:skygate/features/main/models/back_action.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainInitial());

  MainCubit get(BuildContext context) => BlocProvider.of(context);

  int currentIndex = 0;

  bool isDark = false;
  final Set<int> _visited = {0};

  bool hasVisited(int index) => _visited.contains(index);

  void changeTab(int index) {
    if (currentIndex == index) return;
    currentIndex = index;
    _visited.add(index);
    // Leaving الرئيسية drops a pending exit warning, so a press from before
    // the trip cannot quit the app on the reader's return.
    _exitPromptAt = null;
    emit(TabChanged());
  }

  DateTime? _exitPromptAt;

  /// The Android convention: the second press only quits while the warning it
  /// answers is still on screen.
  static const Duration exitWindow = Duration(seconds: 2);

  /// Decides what a system back press means. Any tab but الرئيسية goes there
  /// first, so the reader is never more than three presses from leaving.
  BackAction pressBack() {
    if (currentIndex != 0) {
      changeTab(0);
      return BackAction.goHome;
    }

    final prompt = _exitPromptAt;
    if (prompt != null && DateTime.now().difference(prompt) <= exitWindow) {
      return BackAction.exitApp;
    }

    _exitPromptAt = DateTime.now();
    return BackAction.warnBeforeExit;
  }

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
