import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_card.dart';
import 'package:skygate/core/components/app_detail_row.dart';
import 'package:skygate/core/components/app_document_actions.dart';
import 'package:skygate/core/components/app_status_chip.dart';
import 'package:skygate/core/constants/card_assets.dart';
import 'package:skygate/core/constants/my_trips_assets.dart';
import 'package:skygate/core/utils/app_format.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/journey_details/models/travel_document_model.dart';

/// One visa under a pilgrim's name: which application it is, where it has got
/// to, its numbers and dates, then the pair of actions.
class VisaTile extends StatelessWidget {
  const VisaTile({
    super.key,
    required this.visa,
    required this.position,
    required this.isDownloading,
    required this.onDownload,
    required this.onPreview,
  });

  final VisaModel visa;

  /// Its place among this pilgrim's visas — the design numbers them from one.
  final int position;

  final bool isDownloading;
  final VoidCallback onDownload;
  final VoidCallback onPreview;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      padding: EdgeInsets.fromLTRB(12.s, 12.s, 12.s, 12.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'visa_number_title'.tr(args: ['$position']),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              SizedBox(width: 8.s),
              AppStatusChip(
                labelKey: visa.status.labelKey,
                background: visa.status.background,
                foreground: visa.status.foreground,
                radius: 6.s,
              ),
            ],
          ),
          SizedBox(height: 2.s),
          AppDetailRow(
            asset: MyTripsAssets.serialNumber,
            labelKey: 'visa_number',
            value: visa.number,
          ),
          AppDetailRow(
            asset: MyTripsAssets.visaType,
            labelKey: 'visa_type',
            value: visa.type,
          ),
          AppDetailRow(
            asset: CardAssets.calendar,
            labelKey: 'visa_expiry_date',
            value: AppFormat.numericDate(visa.expiresAt),
          ),
          AppDetailRow(
            asset: CardAssets.calendar,
            labelKey: 'visa_submitted_date',
            value: AppFormat.numericDate(visa.submittedAt),
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
