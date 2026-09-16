import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/utils/app_scale.dart';

class AppGrandTotal extends StatelessWidget {
  const AppGrandTotal({
    super.key,
    required this.amount,
    this.labelKey = 'grand_total_all_rooms',
    this.padding = EdgeInsets.zero,
    this.labelAlpha = 0.6,
    this.amountStyle,
  });
  final String amount;

  final String labelKey;
  final EdgeInsetsGeometry padding;
  final double labelAlpha;
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
