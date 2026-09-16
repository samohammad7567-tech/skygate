import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/constants/launch_assets.dart';
import 'package:video_player/video_player.dart';

part 'launch_splash_state.dart';

class LaunchSplashCubit extends Cubit<LaunchSplashState> {
  LaunchSplashCubit() : super(LaunchSplashInitial());

  LaunchSplashCubit get(BuildContext context) => BlocProvider.of(context);
  static const Duration maxDuration = Duration(seconds: 6);

  VideoPlayerController? _video;

  Timer? _failSafe;

  bool _finished = false;
  VideoPlayerController? get video =>
      _video?.value.isInitialized == true ? _video : null;

  Future<void> playIntro() async {
    _failSafe = Timer(maxDuration, _finish);

    final controller = VideoPlayerController.asset(LaunchAssets.splashVideo);
    _video = controller;

    try {
      await controller.initialize();
    } catch (_) {
      _finish();
      return;
    }
    if (isClosed) return;

    await controller.setLooping(false);
    controller.addListener(_watchForEnd);
    emit(LaunchSplashReady());
    await controller.play();
  }

  void _watchForEnd() {
    final value = _video?.value;
    if (value == null || !value.isInitialized) return;
    if (value.position >= value.duration) _finish();
  }

  void _finish() {
    if (_finished) return;
    _finished = true;
    _failSafe?.cancel();
    _failSafe = null;
    if (isClosed) return;
    emit(LaunchSplashFinished());
  }

  void skip() => _finish();

  @override
  Future<void> close() {
    _failSafe?.cancel();
    _video?.removeListener(_watchForEnd);
    _video?.dispose();
    return super.close();
  }
}
