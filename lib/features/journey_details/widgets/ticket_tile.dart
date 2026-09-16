import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_card.dart';
import 'package:skygate/core/components/app_detail_row.dart';
import 'package:skygate/core/components/app_document_actions.dart';
import 'package:skygate/core/constants/card_assets.dart';
import 'package:skygate/core/constants/my_trips_assets.dart';
import 'package:skygate/core/utils/app_format.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/journey_details/models/travel_document_model.dart';

class TicketTile extends StatelessWidget {
  const TicketTile({
    super.key,
    required this.ticket,
    required this.position,
    required this.isDownloading,
    required this.onDownload,
    required this.onPreview,
  });

  final PilgrimTicketModel ticket;
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
          Text(
            'ticket_number_title'.tr(args: ['$position']),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 2.s),
          AppDetailRow(
            asset: MyTripsAssets.link,
            labelKey: 'ticket_file_link',
            value: ticket.route,
          ),
          AppDetailRow(
            asset: MyTripsAssets.ticketType,
            labelKey: 'ticket_type',
            value: ticket.type,
          ),
          AppDetailRow(
            asset: CardAssets.calendar,
            labelKey: 'ticket_issued_date',
            value: AppFormat.numericDate(ticket.issuedAt),
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
