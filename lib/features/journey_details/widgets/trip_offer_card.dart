import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/journey_assets.dart';
import 'package:skygate/core/models/booking_type.dart';
import 'package:skygate/core/utils/app_format.dart';
import 'package:skygate/features/journey_details/models/trip_offer_model.dart';
import 'package:skygate/features/journey_details/widgets/trip_offer_booking_types.dart';
import 'package:skygate/features/journey_details/widgets/trip_offer_price_row.dart';

/// One card on "عروض الرحلة": route strip, booking types, room, prices.
class TripOfferCard extends StatelessWidget {
  const TripOfferCard({
    super.key,
    required this.offer,
    required this.position,
    required this.selectedType,
    required this.onTypeSelected,
  });

  final TripOfferModel offer;

  /// 1-based place in the list, used for the "المسار الأول" title.
  final int position;

  final BookingType? selectedType;
  final ValueChanged<BookingType> onTypeSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _RouteStrip(
            title:
                offer.routeTitle ??
                AppFormat.ordinalTitle('route_title', position),
            name: offer.routeName,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TripOfferBookingTypes(
                  types: offer.bookingTypes,
                  selectedType: selectedType,
                  onSelected: onTypeSelected,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    AppImage(
                      JourneyAssets.roomType,
                      height: 20,
                      width: 20,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        '${'room_type'.tr()} : ${offer.roomType ?? '—'}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(height: 1),
                const SizedBox(height: 8),
                TripOfferPriceRow(
                  asset: JourneyAssets.adult,
                  labelKey: 'price_adult',
                  price: offer.adultPrice,
                  currency: offer.currency,
                ),
                TripOfferPriceRow(
                  asset: JourneyAssets.child,
                  labelKey: 'price_child',
                  price: offer.childPrice,
                  currency: offer.currency,
                ),
                TripOfferPriceRow(
                  asset: JourneyAssets.infant,
                  labelKey: 'price_infant',
                  price: offer.infantPrice,
                  currency: offer.currency,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Tinted header naming the route the offer belongs to.
class _RouteStrip extends StatelessWidget {
  const _RouteStrip({required this.title, this.name});

  final String title;
  final String? name;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
      ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: name == null ? title : '$title: '),
            if (name != null)
              TextSpan(
                text: name,
                style: TextStyle(color: theme.colorScheme.secondary),
              ),
          ],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.titleLarge,
      ),
    );
  }
}
