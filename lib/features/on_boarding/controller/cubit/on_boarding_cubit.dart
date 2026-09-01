import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/utils/cache_util.dart';
import 'package:skygate/features/on_boarding/models/on_boarding_page_model.dart';

part 'on_boarding_state.dart';

class OnBoardingCubit extends Cubit<OnBoardingState> {
  OnBoardingCubit() : super(OnBoardingInitial());

  OnBoardingCubit get(BuildContext context) => BlocProvider.of(context);

  /// Cache flag read by `main.dart` to decide whether to show onboarding.
  static const String seenKey = 'onboarding_seen';

  final List<OnBoardingPageModel> pages = OnBoardingPageModel.pages;

  int currentPage = 0;

  bool get isLastPage => currentPage == pages.length - 1;

  void changePage(int index) {
    if (index == currentPage || index < 0 || index >= pages.length) return;
    currentPage = index;
    emit(OnBoardingPageChanged());
  }

  /// Marks onboarding as done so it is skipped on the next launch.
  Future<void> complete() async {
    await CacheUtil.setBool(key: seenKey, value: true);
    emit(OnBoardingCompleted());
  }
}
