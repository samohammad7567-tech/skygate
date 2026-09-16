import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/utils/app_format.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/booking_changes/models/booking_change_request_model.dart';
import 'package:skygate/features/booking_changes/utils/booking_change_labels.dart';
import 'package:skygate/features/booking_changes/widgets/booking_change_field.dart';
import 'package:skygate/features/booking_changes/widgets/booking_change_status_chip.dart';

class BookingChangeSummaryCard extends StatelessWidget {
  const BookingChangeSummaryCard({super.key, required this.request});

  final BookingChangeRequestModel request;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = context.locale.toString();

    return Container(
      padding: EdgeInsets.all(16.s),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.s),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  bookingChangeTypeLabel(request),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge,
                ),
              ),
              Gap(10.s),
              BookingChangeStatusChip(status: request.status),
            ],
          ),
          Gap(14.s),
          BookingChangeField(
            label: request.tripTitle ?? 'trip_number'.tr(),
            value: request.reference,
          ),
          Gap(12.s),
          Divider(height: 1.s),
          Gap(12.s),
          BookingChangeField(
            label: 'booking_change_requested_at'.tr(),
            value: AppFormat.shortDate(request.createdAt, locale),
          ),
          if (request.reviewedAt != null) ...[
            Gap(12.s),
            Divider(height: 1.s),
            Gap(12.s),
            BookingChangeField(
              label: 'booking_change_reviewed_at'.tr(),
              value: AppFormat.shortDate(request.reviewedAt, locale),
            ),
          ],
          if (request.detailsText case final details?) ...[
            Gap(12.s),
            Divider(height: 1.s),
            Gap(12.s),
            BookingChangeField(
              label: 'booking_change_details'.tr(),
              value: details,
              maxLines: 8,
            ),
          ],
          if (request.adminNotesText case final notes?) ...[
            Gap(12.s),
            Divider(height: 1.s),
            Gap(12.s),
            BookingChangeField(
              label: 'booking_change_admin_notes'.tr(),
              value: notes,
              maxLines: 8,
            ),
          ],
        ],
      ),
    );
  }
}
