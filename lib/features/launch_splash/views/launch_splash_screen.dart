import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/launch_splash/controller/cubit/launch_splash_cubit.dart';
import 'package:skygate/features/splash/views/splash_screen.dart';
import 'package:video_player/video_player.dart';

class LaunchSplashScreen extends StatelessWidget {
  const LaunchSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LaunchSplashCubit()..playIntro(),
      child: const _LaunchSplashBody(),
    );
  }
}

class _LaunchSplashBody extends StatelessWidget {
  const _LaunchSplashBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: BlocConsumer<LaunchSplashCubit, LaunchSplashState>(
        listener: (context, state) {
          if (state is! LaunchSplashFinished) return;
          NaivgatorHelper.pushAndRemoveUntilNavigation(
            context,
            const SplashScreen(),
          );
        },
        builder: (context, state) {
          final video = context.read<LaunchSplashCubit>().video;
          if (video == null) return const SizedBox.expand();

          return GestureDetector(
            onTap: context.read<LaunchSplashCubit>().skip,
            child: _FullBleedVideo(controller: video),
          );
        },
      ),
    );
  }
}

class _FullBleedVideo extends StatelessWidget {
  const _FullBleedVideo({required this.controller});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: controller.value.size.width,
          height: controller.value.size.height,
          child: VideoPlayer(controller),
        ),
      ),
    );
  }
}
