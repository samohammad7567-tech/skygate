import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';

/// "بالغ : $750" — one traveller class and its price.
class TripOfferPriceRow extends StatelessWidget {
  const TripOfferPriceRow({
    super.key,
    required this.asset,
    required this.labelKey,
    this.price,
    this.currency,
  });

  final String asset;
  final String labelKey;
  final num? price;
  final String? currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          AppImage(
            asset,
            height: 20,
            width: 20,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              '${labelKey.tr()} :',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              price == null ? '—' : '${currency ?? ''}$price',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
