import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// The tinted pill every flow prints to carry a standing — a transaction's,
/// a booking's, a private-trip request's, a lost item's, a traveller's class.
///
/// Each flow owns the palette and the wording, so this only draws the shape:
/// the caller passes the two colours its own enum resolves and the key to
/// translate. The feature-level chips ([TransactionStatusChip],
/// [VipStatusChip], [TripStatusChip], [AudienceChip]) are thin wrappers that
/// bind their enum to this, which keeps `core` free of any one flow's model.
class AppStatusChip extends StatelessWidget {
  const AppStatusChip({
    super.key,
    required this.labelKey,
    required this.background,
    required this.foreground,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    this.radius = 20,
    this.borderAlpha,
  });

  /// Translation key of the label — translated here so no call site has to.
  final String labelKey;

  final Color background;

  /// Colour of the label, and of the hairline when [borderAlpha] is set.
  final Color foreground;

  final EdgeInsetsGeometry padding;
  final double radius;

  /// Opacity of the outline drawn in [foreground]. Null leaves the pill flat,
  /// which is what most of the flows draw.
  final double? borderAlpha;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
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
