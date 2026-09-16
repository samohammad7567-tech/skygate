import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/utils/app_scale.dart';

class AppStatusChip extends StatelessWidget {
  const AppStatusChip({
    super.key,
    required this.labelKey,
    required this.background,
    required this.foreground,
    this.padding,
    this.radius,
    this.borderAlpha,
  });
  final String labelKey;

  final Color background;
  final Color foreground;
  final EdgeInsetsGeometry? padding;
  final double? radius;
  final double? borderAlpha;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 10.s, vertical: 4.s),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular((radius ?? 20.s)),
        border: borderAlpha == null
            ? null
            : Border.all(color: foreground.withValues(alpha: borderAlpha!)),
      ),
      child: Text(
        labelKey.tr(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: foreground),
      ),
    );
  }
}
