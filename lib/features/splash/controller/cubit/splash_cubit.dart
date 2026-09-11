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

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  SplashCubit get(BuildContext context) => BlocProvider.of(context);
  static const String serviceKey = 'service_type';
  static const Duration slideInterval = Duration(seconds: 5);

  final List<String> backgrounds = SplashAssets.backgrounds;
  int page = 0;

  SplashService? selectedService;
  bool isBootingTourism = false;

  Timer? _timer;
  int get activeIndex => page % backgrounds.length;
  int get nextPage => page + 1;
  String backgroundAt(int index) => backgrounds[index % backgrounds.length];
  bool get hasSeenOnBoarding =>
      CacheUtil.get(key: OnBoardingCubit.seenKey) == true;
  bool get isLoggedIn => AuthCubit.isLoggedIn;
  void loadSelectedService() {
    selectedService = SplashService.fromCache(CacheUtil.get(key: serviceKey));
  }

  void startSlideshow() {
    _timer?.cancel();
    _timer = Timer.periodic(slideInterval, (_) => emit(SplashSlideAdvanced()));
  }

  void stopSlideshow() {
    _timer?.cancel();
    _timer = null;
  }

  void changeSlide(int index) {
    if (index == page) return;
    page = index;
    startSlideshow();
    emit(SplashSlideChanged());
  }

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
