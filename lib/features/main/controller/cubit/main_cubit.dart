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
    _exitPromptAt = null;
    emit(TabChanged());
  }

  DateTime? _exitPromptAt;
  static const Duration exitWindow = Duration(seconds: 2);
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
