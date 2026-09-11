import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/cached_image.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/constants/home_assets.dart';
import 'package:skygate/features/home/models/offer_model.dart';
import 'package:skygate/features/home/widgets/offer_date_chip.dart';
import 'package:skygate/features/home/widgets/offer_price.dart';
import 'package:skygate/features/home/widgets/offer_title_row.dart';
import 'package:skygate/features/home/widgets/vip_ribbon.dart';

class OfferCard extends StatelessWidget {
  const OfferCard({
    super.key,
    required this.offer,
    required this.width,
    this.onViewDetails,
  });

  final OfferModel offer;
  final double width;
  final VoidCallback? onViewDetails;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: width,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        // The carousel gives every card the same height, so any slack left
        // over by shorter copy is shared out between the rows.
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 6,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedImage(
                  url: offer.image,
                  fallbackAsset: HomeAssets.kaaba,
                  height: 110,
                  width: double.infinity,
                ),
              ),
              // A row of `vip_trips` rather than of `trips.items`.
              if (offer.isVip)
                const PositionedDirectional(
                  top: 0,
                  start: 12,
                  child: VipRibbon(),
                ),
            ],
          ),
          OfferTitleRow(offer: offer),
          Text(
            offer.code ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
          OfferDatesRow(offer: offer),
          OfferPrice(offer: offer),
          CustomButton(
            label: offer.isBookingOpen
                ? 'view_details'.tr()
                : 'booking_closed'.tr(),
            onPressed: onViewDetails,
          ),
        ],
      ),
    );
  }
}
