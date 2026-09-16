import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_id_card.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/pilgrim_avatar.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/constants/card_assets.dart';
import 'package:skygate/core/utils/app_format.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/cards/models/pilgrim_card_model.dart';
import 'package:skygate/features/cards/models/trip_pilgrim_model.dart';
import 'package:skygate/features/cards/widgets/card_field_row.dart';

class PilgrimCardFace extends StatelessWidget {
  const PilgrimCardFace({super.key, required this.pilgrim, required this.card});

  final TripPilgrimModel pilgrim;
  final PilgrimCardModel? card;

  @override
  Widget build(BuildContext context) {
    return AppIdCard(
      header: _Header(pilgrim: pilgrim),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          CardFieldRow(
            asset: CardAssets.tickets,
            startLabelKey: 'trip_number',
            startValue: card?.tripNumber,
          ),
          CardFieldRow(
            asset: CardAssets.calendar,
            startLabelKey: 'departure_date',
            startValue: AppFormat.numericDate(card?.departureDate),
            endLabelKey: 'trip_return_date',
            endValue: AppFormat.numericDate(card?.returnDate),
          ),
          _Stay(labelKey: 'makkah_hotel', stay: card?.makkah),
          _Stay(labelKey: 'madinah_hotel', stay: card?.madinah),
          SizedBox(height: 6.s),
          const AppCardRule(),
          SizedBox(height: 12.s),
          AppImage(CardAssets.brandMark, height: 34.s),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.pilgrim});

  final TripPilgrimModel pilgrim;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        PilgrimAvatar(
          photo: pilgrim.photo,
          size: 62.s,
          ringColor: AppColors.accent,
        ),
        SizedBox(width: 12.s),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (pilgrim.fullNameEn case final latin?) ...[
                Text(
                  latin,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.surface,
                  ),
                ),
                SizedBox(height: 2.s),
              ],
              Text(
                pilgrim.displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.surface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Stay extends StatelessWidget {
  const _Stay({required this.labelKey, required this.stay});

  final String labelKey;
  final PilgrimCardStayModel? stay;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const AppCardRule(),
        CardFieldRow(
          asset: CardAssets.hotel,
          startLabelKey: labelKey,
          startValue: stay?.name,
          startSubtitle: stay?.nameEn,
        ),
        CardFieldRow(
          asset: CardAssets.calendar,
          startLabelKey: 'check_in_date',
          startValue: AppFormat.numericDate(stay?.checkIn),
          endLabelKey: 'check_out_date',
          endValue: AppFormat.numericDate(stay?.checkOut),
        ),
        CardFieldRow(
          asset: CardAssets.phone,
          startLabelKey: 'hotel_phone',
          startValue: stay?.phone,
        ),
      ],
    );
  }
}
