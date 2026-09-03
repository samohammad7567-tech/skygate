import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/constants/launch_assets.dart';
import 'package:video_player/video_player.dart';

part 'launch_splash_state.dart';

/// Plays the brand clip the app opens with, then hands over to the screen
/// that lets the user pick a service line.
///
/// The clip is the only thing between a cold start and the first real screen,
/// so nothing here is allowed to strand the user: a decode failure, a missing
/// file or a clip that never reports completion all fall through to
/// [LaunchSplashFinished] via [_failSafe].
class LaunchSplashCubit extends Cubit<LaunchSplashState> {
  LaunchSplashCubit() : super(LaunchSplashInitial());

  LaunchSplashCubit get(BuildContext context) => BlocProvider.of(context);

  /// Longest the splash may hold the app, however the clip behaves.
  static const Duration maxDuration = Duration(seconds: 6);

  VideoPlayerController? _video;

  Timer? _failSafe;

  bool _finished = false;

  /// `null` until the clip is ready — the screen shows the brand colour then.
  VideoPlayerController? get video =>
      _video?.value.isInitialized == true ? _video : null;

  Future<void> playIntro() async {
    _failSafe = Timer(maxDuration, _finish);

    final controller = VideoPlayerController.asset(LaunchAssets.splashVideo);
    _video = controller;

    try {
      await controller.initialize();
    } catch (_) {
      // Bad or missing asset — skip straight to the choice screen.
      _finish();
      return;
    }
    if (isClosed) return;

    await controller.setLooping(false);
    controller.addListener(_watchForEnd);
    emit(LaunchSplashReady());
    await controller.play();
  }

  /// `VideoPlayerController` has no completion callback, so the end is read
  /// off the position — `isCompleted` only reports on some platforms.
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

  /// Lets the user tap past the clip.
  void skip() => _finish();

  @override
  Future<void> close() {
    _failSafe?.cancel();
    _video?.removeListener(_watchForEnd);
    _video?.dispose();
    return super.close();
  }
}
