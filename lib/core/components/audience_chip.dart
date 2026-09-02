import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/models/traveler_audience.dart';

/// "بالغ / طفل / رضيع" pill printed on every traveller card, picker row and
/// payments traveller line.
///
/// Each class keeps its own tint across the whole flow, so a traveller is
/// recognisable at a glance whichever screen they turn up on.
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: _background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _foreground.withValues(alpha: 0.4)),
      ),
      child: Text(
        audience.labelKey.tr(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: _foreground),
      ),
    );
  }
}

/// Round blue badge carrying a traveller's place in the group.
class PositionBadge extends StatelessWidget {
  const PositionBadge({super.key, required this.position, this.size = 34});

  final int position;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: size,
      width: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        shape: BoxShape.circle,
      ),
      child: Text(
        '$position',
        maxLines: 1,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.onPrimary,
        ),
      ),
    );
  }
}

/// Small pink "٢" the design prints next to an infant charged the
/// "الرضيع الثاني" rate.
class SecondInfantBadge extends StatelessWidget {
  const SecondInfantBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 18,
      width: 18,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.ritualSurface.withValues(alpha: 0.5),
        shape: BoxShape.circle,
      ),
      child: Text(
        '2',
        maxLines: 1,
        style: theme.textTheme.bodySmall?.copyWith(color: AppColors.ritual),
      ),
    );
  }
}
