import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/app_colors.dart';

/// One line on a printed card face: a round glyph, then one or two
/// label-over-value pairs spread across the row.
///
/// The pilgrim card and the luggage tag are both built from these, which is
/// why the pairs are parameters rather than three near-identical widgets.
class CardFieldRow extends StatelessWidget {
  const CardFieldRow({
    super.key,
    required this.asset,
    required this.startLabelKey,
    required this.startValue,
    this.endLabelKey,
    this.endValue,
    this.startSubtitle,
    this.endSubtitle,
  });

  final String asset;

  final String startLabelKey;
  final String? startValue;

  /// Printed under the value in the Latin face — hotel names carry both
  /// scripts on the design, everything else leaves this null.
  final String? startSubtitle;

  final String? endLabelKey;
  final String? endValue;
  final String? endSubtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _Glyph(asset: asset),
          const SizedBox(width: 10),
          Expanded(
            child: _Pair(
              labelKey: startLabelKey,
              value: startValue,
              subtitle: startSubtitle,
            ),
          ),
          if (endLabelKey != null) ...[
            const SizedBox(width: 10),
            Expanded(
              child: _Pair(
                labelKey: endLabelKey!,
                value: endValue,
                subtitle: endSubtitle,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Glyph extends StatelessWidget {
  const _Glyph({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      width: 34,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: AppImage(asset, height: 17, width: 17, color: AppColors.surface),
    );
  }
}

class _Pair extends StatelessWidget {
  const _Pair({required this.labelKey, this.value, this.subtitle});

  final String labelKey;
  final String? value;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          labelKey.tr(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: 2),
        Text(
          value ?? '—',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleSmall?.copyWith(color: AppColors.primary),
        ),
        if (subtitle != null)
          Text(
            subtitle!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.primarySoft,
            ),
          ),
      ],
    );
  }
}
