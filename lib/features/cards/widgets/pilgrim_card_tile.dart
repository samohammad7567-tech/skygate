import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_card.dart';
import 'package:skygate/core/components/app_detail_row.dart';
import 'package:skygate/core/components/app_document_actions.dart';
import 'package:skygate/core/components/empty_state.dart';
import 'package:skygate/core/constants/card_assets.dart';
import 'package:skygate/core/utils/app_format.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/cards/models/pilgrim_card_model.dart';
import 'package:skygate/features/cards/models/trip_pilgrim_model.dart';

/// What unfolds under a name on "بطاقات المعتمرين": the card's fields, then
/// the pair of actions that print or preview it.
class PilgrimCardTile extends StatelessWidget {
  const PilgrimCardTile({
    super.key,
    required this.pilgrim,
    required this.card,
    required this.isLoading,
    required this.error,
    required this.isDownloading,
    required this.onDownload,
    required this.onPreview,
    required this.onRetry,
  });

  final TripPilgrimModel pilgrim;
  final PilgrimCardModel? card;

  final bool isLoading;
  final String? error;
  final bool isDownloading;

  final VoidCallback onDownload;
  final VoidCallback onPreview;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 28.s),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2.s)),
      );
    }

    if (error case final message?) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.s),
        child: EmptyState(message: message.tr(), onRetry: onRetry),
      );
    }

    return AppCard(
      padding: EdgeInsets.fromLTRB(12.s, 2.s, 12.s, 12.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppDetailRow(
            asset: CardAssets.passport,
            labelKey: 'passport_number',
            value: pilgrim.passportNumber ?? card?.passportNumber,
          ),
          AppDetailRow(
            asset: CardAssets.tripNumber,
            labelKey: 'trip_number',
            value: card?.tripNumber,
          ),
          AppDetailRow(
            asset: CardAssets.calendar,
            labelKey: 'trip_start_date',
            value: AppFormat.numericDate(card?.departureDate),
          ),
          AppDetailRow(
            asset: CardAssets.calendar,
            labelKey: 'trip_return_date',
            value: AppFormat.numericDate(card?.returnDate),
          ),
          AppDetailRow(
            asset: CardAssets.hotel,
            labelKey: 'makkah_hotel',
            value: card?.makkah?.name,
          ),
          AppDetailRow(
            asset: CardAssets.hotel,
            labelKey: 'madinah_hotel',
            value: card?.madinah?.name,
            showDivider: false,
          ),
          SizedBox(height: 10.s),
          AppDocumentActions(
            isDownloading: isDownloading,
            onDownload: onDownload,
            onPreview: onPreview,
          ),
        ],
      ),
    );
  }
}
