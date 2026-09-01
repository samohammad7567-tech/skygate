import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/auth/views/auth_landing_screen.dart';
import 'package:skygate/features/main/views/main_screen.dart';
import 'package:skygate/features/on_boarding/views/on_boarding_screen.dart';
import 'package:skygate/features/splash/controller/cubit/splash_cubit.dart';
import 'package:skygate/features/splash/models/splash_service.dart';
import 'package:skygate/features/splash/widgets/splash_background_carousel.dart';
import 'package:skygate/features/splash/widgets/splash_panel.dart';

/// App entry: a photo slideshow over which the user picks the service line
/// their journey starts with.
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
  /// Owned by the screen; the cubit only holds the resulting page.
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

  /// Where the chosen service line drops the user: onboarding on a first run,
  /// then the home tabs or the auth flow depending on the stored session.
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
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(40, 0, 40, 40),
                      child: SplashPanel(
                        slideCount: cubit.backgrounds.length,
                        currentIndex: cubit.activeIndex,
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
