import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/constants/splash_assets.dart';
import 'package:skygate/core/utils/cache_util.dart';
import 'package:skygate/features/auth/controller/cubit/auth_cubit.dart';
import 'package:skygate/features/on_boarding/controller/cubit/on_boarding_cubit.dart';
import 'package:skygate/features/splash/models/splash_service.dart';

part 'splash_state.dart';

/// Drives the entry screen: the background slideshow and the service choice.
///
/// The screen owns the [PageController]; this cubit only decides *when* to
/// advance (by emitting [SplashSlideAdvanced]) and remembers which slide is
/// showing so the indicator can rebuild.
class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  SplashCubit get(BuildContext context) => BlocProvider.of(context);

  /// Cache key holding the chosen service line.
  static const String serviceKey = 'service_type';

  /// How long each photo stays on screen.
  static const Duration slideInterval = Duration(seconds: 5);

  final List<String> backgrounds = SplashAssets.backgrounds;

  /// Raw `PageView` page. The carousel scrolls forever, so this keeps growing
  /// and the slide is resolved with a modulo — that way the last photo rolls
  /// over to the first without a backwards rewind.
  int page = 0;

  SplashService? selectedService;

  Timer? _timer;

  /// Index into [backgrounds] of the photo currently on screen.
  int get activeIndex => page % backgrounds.length;

  /// Page the slideshow moves to on the next tick.
  int get nextPage => page + 1;

  /// Photo for a raw carousel [index].
  String backgroundAt(int index) => backgrounds[index % backgrounds.length];

  /// Whether onboarding was already dismissed on an earlier run.
  bool get hasSeenOnBoarding =>
      CacheUtil.get(key: OnBoardingCubit.seenKey) == true;

  /// Whether a session survived the last run.
  bool get isLoggedIn => AuthCubit.isLoggedIn;

  /// Restores the service picked on an earlier run, if any.
  void loadSelectedService() {
    selectedService = SplashService.fromCache(CacheUtil.get(key: serviceKey));
  }

  /// Starts — or restarts — the auto-advance timer.
  void startSlideshow() {
    _timer?.cancel();
    _timer = Timer.periodic(slideInterval, (_) => emit(SplashSlideAdvanced()));
  }

  void stopSlideshow() {
    _timer?.cancel();
    _timer = null;
  }

  /// Called by the carousel once a page settles, whether the timer or a swipe
  /// moved it. Restarts the timer so a manual swipe gets a full interval.
  void changeSlide(int index) {
    if (index == page) return;
    page = index;
    startSlideshow();
    emit(SplashSlideChanged());
  }

  /// Persists the tapped service line and signals the screen to move on.
  Future<void> selectService(SplashService service) async {
    selectedService = service;
    stopSlideshow();
    await CacheUtil.setString(key: serviceKey, value: service.cacheValue);
    emit(SplashServiceSelected(service: service));
  }

  @override
  Future<void> close() {
    stopSlideshow();
    return super.close();
  }
}
