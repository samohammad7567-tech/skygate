import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/features/home/models/offer_model.dart';

/// "تبدأ من" over the starting price, on the end side of the offer card.
class OfferPrice extends StatelessWidget {
  const OfferPrice({super.key, required this.offer});

  final OfferModel offer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (offer.priceFrom == null) return const SizedBox.shrink();

    // Sits on the end (left) side of the card, both lines flush to the same
    // edge — the price is the wider of the two.
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'starts_from'.tr(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          Text(
            '${offer.priceFrom} ${'currency'.tr()}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.secondary,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
