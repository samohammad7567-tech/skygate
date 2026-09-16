import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' hide Trans;
import 'package:skygate/core/components/toast.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/auth/views/auth_landing_screen.dart';
import 'package:skygate/features/main/views/main_screen.dart';
import 'package:skygate/features/on_boarding/views/on_boarding_screen.dart';
import 'package:skygate/features/splash/controller/cubit/splash_cubit.dart';
import 'package:skygate/features/splash/models/splash_service.dart';
import 'package:skygate/features/splash/widgets/splash_background_carousel.dart';
import 'package:skygate/features/splash/widgets/splash_panel.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashCubit()
        ..loadSelectedService()
        ..startSlideshow(),
      child: const _SplashBody(),
    );
  }
}

class _SplashBody extends StatefulWidget {
  const _SplashBody();

  @override
  State<_SplashBody> createState() => _SplashBodyState();
}

class _SplashBodyState extends State<_SplashBody> {
  final PageController _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _advance(SplashCubit cubit) {
    if (!_controller.hasClients) return;
    _controller.animateToPage(
      cubit.nextPage,
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeInOut,
    );
  }

  Widget _nextScreen(SplashCubit cubit) {
    if (!cubit.hasSeenOnBoarding) return const OnBoardingScreen();
    return cubit.isLoggedIn ? const MainScreen() : const AuthLandingScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SplashCubit, SplashState>(
        listener: (context, state) {
          final cubit = context.read<SplashCubit>();
          if (state is SplashSlideAdvanced) {
            _advance(cubit);
          } else if (state is SplashServiceSelected) {
            NaivgatorHelper.pushAndRemoveUntilNavigation(
              context,
              _nextScreen(cubit),
            );
          } else if (state is SplashTourismReady) {
            Get.toNamed(state.route);
          } else if (state is SplashTourismFailed) {
            showToast(context, state.errorKey.tr(), isError: true);
          }
        },
        builder: (context, state) {
          final cubit = context.read<SplashCubit>();

          return Stack(
            fit: StackFit.expand,
            children: [
              SplashBackgroundCarousel(
                controller: _controller,
                backgroundAt: cubit.backgroundAt,
                onPageChanged: cubit.changeSlide,
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 480.s),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(40.s, 0, 40.s, 40.s),
                      child: SplashPanel(
                        slideCount: cubit.backgrounds.length,
                        currentIndex: cubit.activeIndex,
                        isBootingTourism: cubit.isBootingTourism,
                        onServiceSelected: (service) =>
                            _onServiceSelected(context, service),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _onServiceSelected(BuildContext context, SplashService service) {
    context.read<SplashCubit>().selectService(service);
  }
}
