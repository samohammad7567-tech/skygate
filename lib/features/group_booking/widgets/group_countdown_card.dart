import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/utils/app_format.dart';
import 'package:skygate/core/utils/app_scale.dart';

class GroupCountdownCard extends StatelessWidget {
  const GroupCountdownCard({
    super.key,
    required this.remaining,
    required this.deadline,
  });
  final Duration remaining;
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
        borderRadius: BorderRadius.circular(14.s),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(14.s, 12.s, 14.s, 12.s),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.vertical(top: Radius.circular(13.s)),
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
                Gap(10.s),
                Icon(
                  Icons.schedule,
                  size: 22.s,
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(14.s, 16.s, 14.s, 16.s),
            child: Column(
              children: [
                Text(
                  _clock,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  // The clock always reads left to right, Arabic included.
                  textDirection: ui.TextDirection.ltr,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontSize: 28.fs,
                  ),
                ),
                Gap(8.s),
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
