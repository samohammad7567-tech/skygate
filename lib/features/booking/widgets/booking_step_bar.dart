import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/features/booking/controller/cubit/booking_cubit.dart';

/// "إبدأ حجزك من خطوات الحجز التالية : الخطوة 2 من 6" card, with the progress
/// rule under it.
class BookingStepBar extends StatelessWidget {
  const BookingStepBar({
    super.key,
    required this.step,
    this.total = BookingCubit.totalSteps,
  });

  /// 1-based index of the step being shown.
  final int step;

  /// Steps the wizard has in total — six for the individual flow, nine for the
  /// group one.
  final int total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'start_booking_steps'.tr(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall,
                ),
              ),
              const Gap(10),
              Text(
                'step_of'.tr(
                  namedArgs: {'current': '$step', 'total': '$total'},
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const Gap(10),
          _ProgressRule(step: step, total: total),
        ],
      ),
    );
  }
}

/// Rule filled from the start side — the right under Arabic — with the dot the
/// design prints at the far end of the track.
class _ProgressRule extends StatelessWidget {
  const _ProgressRule({required this.step, required this.total});

  final int step;
  final int total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = (step / total).clamp(0.0, 1.0);

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 4,
            child: Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outline,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: FractionallySizedBox(
                    widthFactor: progress,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Gap(6),
        Container(
          height: 6,
          width: 6,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}
