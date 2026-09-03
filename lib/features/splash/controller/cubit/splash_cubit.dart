import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/constants/splash_assets.dart';
import 'package:skygate/core/utils/cache_util.dart';
import 'package:skygate/features/auth/controller/cubit/auth_cubit.dart';
import 'package:skygate/features/on_boarding/controller/cubit/on_boarding_cubit.dart';
import 'package:skygate/features/splash/models/splash_service.dart';
import 'package:skygate/tourism/tourism_bootstrap.dart';

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

  /// True while the tourism module is starting up, so the panel can show the
  /// button busy and a second tap cannot start a second boot.
  bool isBootingTourism = false;

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
  ///
  /// The two lines part company here: Umrah is this app's own stack, so the
  /// screen just pushes the next widget. Tourism is a merged-in module that
  /// used to be its own app — it has to be booted before any of its screens
  /// can build, which is the one slow branch and why [isBootingTourism] exists.
  Future<void> selectService(SplashService service) async {
    if (isBootingTourism) return;
    selectedService = service;
    stopSlideshow();
    await CacheUtil.setString(key: serviceKey, value: service.cacheValue);

    if (service == SplashService.umrah) {
      emit(SplashServiceSelected(service: service));
      return;
    }

    isBootingTourism = true;
    emit(SplashTourismBooting());
    try {
      await TourismBootstrap.ensureInitialized();
    } catch (error, stackTrace) {
      // The module boots a lot at once (storage, sqflite, Firebase, FCM); the
      // user only sees "something went wrong", so keep the real cause in the
      // log rather than swallowing it.
      debugPrint('Tourism bootstrap failed: $error\n$stackTrace');
      isBootingTourism = false;
      if (isClosed) return;
      startSlideshow();
      emit(SplashTourismFailed(errorKey: 'errorUnknown'));
      return;
    }
    isBootingTourism = false;
    if (isClosed) return;
    emit(SplashTourismReady(route: TourismBootstrap.entryRoute));
  }

  @override
  Future<void> close() {
    stopSlideshow();
    return super.close();
  }
}
