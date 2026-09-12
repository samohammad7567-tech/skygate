import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_circle_badge.dart';
import 'package:skygate/core/components/app_status_chip.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/models/traveler_audience.dart';
import 'package:skygate/core/utils/app_scale.dart';

class AudienceChip extends StatelessWidget {
  const AudienceChip({super.key, required this.audience});

  final TravelerAudience audience;

  Color get _foreground => switch (audience) {
    TravelerAudience.adult => AppColors.primary,
    TravelerAudience.child => AppColors.ritual,
    TravelerAudience.infant => AppColors.success,
  };

  Color get _background => switch (audience) {
    TravelerAudience.adult => AppColors.surfaceTint,
    TravelerAudience.child => AppColors.ritualSurface,
    TravelerAudience.infant => AppColors.successSurface,
  };

  @override
  Widget build(BuildContext context) {
    return AppStatusChip(
      labelKey: audience.labelKey,
      background: _background,
      foreground: _foreground,
      padding: EdgeInsets.symmetric(horizontal: 12.s, vertical: 4.s),
      borderAlpha: 0.4,
    );
  }
}

class PositionBadge extends StatelessWidget {
  const PositionBadge({super.key, required this.position, this.size});

  final int position;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return AppCircleBadge(text: '$position', size: (size ?? 34.s));
  }
}

class SecondInfantBadge extends StatelessWidget {
  const SecondInfantBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCircleBadge(
      text: '2',
      background: AppColors.ritualSurface.withValues(alpha: 0.5),
      foreground: AppColors.ritual,
      textStyle: Theme.of(context).textTheme.bodySmall,
    );
  }
}
