import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/utils/app_scale.dart';

class PaymentCountdownCard extends StatelessWidget {
  const PaymentCountdownCard({
    super.key,
    required this.remaining,
    required this.windowHours,
    required this.firstInstallmentNumber,
  });
  final Duration remaining;
  final int windowHours;
  final int firstInstallmentNumber;

  String get _clock {
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes.remainder(60);
    final seconds = remaining.inSeconds.remainder(60);
    return [
      hours,
      minutes,
      seconds,
    ].map((part) => '$part'.padLeft(2, '0')).join(' : ');
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
                    'complete_payment_within'.tr(args: ['$windowHours']),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge,
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
                  'booking_auto_cancel_note'.tr(
                    namedArgs: {
                      'hours': '$windowHours',
                      'number': '$firstInstallmentNumber',
                    },
                  ),
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
