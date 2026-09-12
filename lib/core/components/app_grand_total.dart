import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/utils/app_scale.dart';

/// "المجموع النهائي لجميع الغرف" and the figure under it, centred — the block
/// that closes a booking summary and a booking's details card.
class AppGrandTotal extends StatelessWidget {
  const AppGrandTotal({
    super.key,
    required this.amount,
    this.labelKey = 'grand_total_all_rooms',
    this.padding = EdgeInsets.zero,
    this.labelAlpha = 0.6,
    this.amountStyle,
  });

  /// Already-formatted figure, currency included — the flows word it their
  /// own way, so the block only prints what it is handed.
  final String amount;

  final String labelKey;
  final EdgeInsetsGeometry padding;

  /// Opacity of the caption over the surface colour.
  final double labelAlpha;

  /// Defaults to `headlineSmall` at 24, which is what the summary draws.
  final TextStyle? amountStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: padding,
      child: Column(
        children: [
          Text(
            labelKey.tr(),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: labelAlpha),
            ),
          ),
          Gap(6.s),
          Text(
            amount,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style:
                (amountStyle ??
                        theme.textTheme.headlineSmall?.copyWith(
                          fontSize: 24.fs,
                        ))
                    ?.copyWith(color: theme.colorScheme.secondary),
          ),
        ],
      ),
    );
  }
}
