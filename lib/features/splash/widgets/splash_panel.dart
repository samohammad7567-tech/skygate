import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/features/splash/models/splash_service.dart';
import 'package:skygate/features/splash/widgets/splash_indicator.dart';
import 'package:skygate/features/splash/widgets/splash_or_divider.dart';
import 'package:skygate/features/splash/widgets/splash_outlined_button.dart';

/// Copy and the two service buttons, stacked over the bottom of the photo.
class SplashPanel extends StatelessWidget {
  const SplashPanel({
    super.key,
    required this.slideCount,
    required this.currentIndex,
    required this.onServiceSelected,
  });

  final int slideCount;
  final int currentIndex;
  final ValueChanged<SplashService> onServiceSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SplashIndicator(count: slideCount, currentIndex: currentIndex),
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
          onPressed: () => onServiceSelected(SplashService.tourism),
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
          onPressed: () => onServiceSelected(SplashService.umrah),
        ),
      ],
    );
  }
}
