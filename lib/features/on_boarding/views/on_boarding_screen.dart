import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/auth/views/auth_landing_screen.dart';
import 'package:skygate/features/on_boarding/controller/cubit/on_boarding_cubit.dart';
import 'package:skygate/features/on_boarding/widgets/on_boarding_actions.dart';
import 'package:skygate/features/on_boarding/widgets/on_boarding_page_view.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnBoardingCubit(),
      child: const _OnBoardingBody(),
    );
  }
}

class _OnBoardingBody extends StatefulWidget {
  const _OnBoardingBody();

  @override
  State<_OnBoardingBody> createState() => _OnBoardingBodyState();
}

class _OnBoardingBodyState extends State<_OnBoardingBody> {
  /// Owned by the screen; the cubit only holds the resulting index.
  final PageController _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    final cubit = context.read<OnBoardingCubit>();
    await cubit.complete();
    if (!mounted) return;
    NaivgatorHelper.pushAndRemoveUntilNavigation(
      context,
      const AuthLandingScreen(),
    );
  }

  void _next() {
    final cubit = context.read<OnBoardingCubit>();
    if (cubit.isLastPage) {
      _finish();
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.fromLTRB(42, 16, 42, 24),
        child: BlocBuilder<OnBoardingCubit, OnBoardingState>(
          builder: (context, state) {
            final cubit = context.read<OnBoardingCubit>();

            return Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: cubit.pages.length,
                    onPageChanged: cubit.changePage,
                    itemBuilder: (_, index) => OnBoardingPageView(
                      page: cubit.pages[index],
                      pageCount: cubit.pages.length,
                      currentIndex: cubit.currentPage,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                OnBoardingActions(onSkip: _finish, onNext: _next),
              ],
            );
          },
        ),
      ),
    );
  }
}
