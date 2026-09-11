import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_page_indicator.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/features/splash/models/splash_service.dart';
import 'package:skygate/features/splash/widgets/splash_or_divider.dart';
import 'package:skygate/features/splash/widgets/splash_outlined_button.dart';

class SplashPanel extends StatelessWidget {
  const SplashPanel({
    super.key,
    required this.slideCount,
    required this.currentIndex,
    required this.onServiceSelected,
    this.isBootingTourism = false,
  });

  final int slideCount;
  final int currentIndex;
  final ValueChanged<SplashService> onServiceSelected;
  final bool isBootingTourism;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppPageIndicator(
          count: slideCount,
          currentIndex: currentIndex,
          dotSize: 7,
          activeWidth: 18,
          inactiveColor: Colors.white.withValues(alpha: 0.55),
        ),
        const Gap(18),
        Text(
          'journey_starts_here'.tr(),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontSize: 26,
            height: 1.4,
          ),
        ),
        const Gap(26),
        SplashOutlinedButton(
          label: SplashService.tourism.labelKey.tr(),
          isLoading: isBootingTourism,
          onPressed: isBootingTourism
              ? null
              : () => onServiceSelected(SplashService.tourism),
        ),
        const Gap(16),
        const SplashOrDivider(),
        const Gap(16),
        CustomButton(
          label: SplashService.umrah.labelKey.tr(),
          width: double.infinity,
          height: 47,
          radius: 8,
          backgroundColor: theme.colorScheme.secondary,
          onPressed: isBootingTourism
              ? null
              : () => onServiceSelected(SplashService.umrah),
        ),
      ],
    );
  }
}
