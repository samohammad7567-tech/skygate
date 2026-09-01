import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/utils/app_format.dart';

/// "أكمل الدفع خلال (24/2/2026)" card on the group summary: the ticking clock
/// over the note saying what happens when it runs out.
class GroupCountdownCard extends StatelessWidget {
  const GroupCountdownCard({
    super.key,
    required this.remaining,
    required this.deadline,
  });

  /// Time left on the hold, refreshed once a second by the cubit.
  final Duration remaining;

  /// When the hold expires, printed in the header.
  final DateTime? deadline;

  String get _clock {
    final parts = [
      remaining.inHours,
      remaining.inMinutes.remainder(60),
      remaining.inSeconds.remainder(60),
    ];
    return parts.map((part) => '$part'.padLeft(2, '0')).join(' : ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(13),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'complete_payment_by'.tr(
                      args: [
                        AppFormat.shortDate(
                          deadline,
                          context.locale.languageCode,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                const Gap(10),
                Icon(
                  Icons.schedule,
                  size: 22,
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
            child: Column(
              children: [
                Text(
                  _clock,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  // The clock always reads left to right, Arabic included.
                  textDirection: ui.TextDirection.ltr,
                  style: theme.textTheme.headlineSmall?.copyWith(fontSize: 28),
                ),
                const Gap(8),
                Text(
                  'booking_expiry_note'.tr(),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
