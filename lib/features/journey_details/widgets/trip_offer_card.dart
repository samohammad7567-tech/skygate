import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/journey_assets.dart';
import 'package:skygate/core/models/booking_type.dart';
import 'package:skygate/core/utils/app_format.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/journey_details/models/trip_offer_model.dart';
import 'package:skygate/features/journey_details/widgets/trip_offer_booking_types.dart';
import 'package:skygate/features/journey_details/widgets/trip_offer_price_row.dart';

class TripOfferCard extends StatelessWidget {
  const TripOfferCard({
    super.key,
    required this.offer,
    required this.position,
    required this.selectedType,
    required this.onTypeSelected,
  });

  final TripOfferModel offer;
  final int position;

  final BookingType? selectedType;
  final ValueChanged<BookingType> onTypeSelected;

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
          _RouteStrip(
            title:
                offer.routeTitle ??
                AppFormat.ordinalTitle('route_title', position),
            name: offer.routeName,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(14.s, 12.s, 14.s, 12.s),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TripOfferBookingTypes(
                  types: offer.bookingTypes,
                  selectedType: selectedType,
                  onSelected: onTypeSelected,
                  labels: offer.typeLabels,
                ),
                SizedBox(height: 10.s),
                Row(
                  children: [
                    AppImage(
                      JourneyAssets.roomType,
                      height: 20.s,
                      width: 20.s,
                      color: theme.colorScheme.primary,
                    ),
                    SizedBox(width: 10.s),
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
                    if (offer.availableRooms != null) ...[
                      SizedBox(width: 8.s),
                      _RoomsLeft(count: offer.availableRooms!),
                    ],
                  ],
                ),
                SizedBox(height: 10.s),
                Divider(height: 1.s),
                SizedBox(height: 8.s),
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
                // An infant given a seat of their own is priced apart. Not
                // every package sets the rate, so the row only appears where
                // the package does.
                if (offer.infantWithSeatPrice != null)
                  TripOfferPriceRow(
                    asset: JourneyAssets.infant,
                    labelKey: 'price_second_infant',
                    price: offer.infantWithSeatPrice,
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

class _RoomsLeft extends StatelessWidget {
  const _RoomsLeft({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // A sold-out package is the one the traveller has to be warned about, so
    // it takes the accent while a package with rooms left stays calm.
    final color = count > 0
        ? theme.colorScheme.primary
        : theme.colorScheme.error;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.s, vertical: 3.s),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.s),
      ),
      child: Text(
        count > 0
            ? 'rooms_left'.tr(namedArgs: {'count': '$count'})
            : 'rooms_sold_out'.tr(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodySmall?.copyWith(
          color: color,
          fontSize: 11.fs,
        ),
      ),
    );
  }
}

class _RouteStrip extends StatelessWidget {
  const _RouteStrip({required this.title, this.name});

  final String title;
  final String? name;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.s, vertical: 12.s),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.vertical(top: Radius.circular(13.s)),
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
