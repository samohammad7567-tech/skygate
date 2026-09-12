import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/utils/app_format.dart';
import 'package:skygate/features/booking_changes/models/booking_change_request_model.dart';
import 'package:skygate/features/booking_changes/utils/booking_change_labels.dart';
import 'package:skygate/features/booking_changes/widgets/booking_change_field.dart';
import 'package:skygate/features/booking_changes/widgets/booking_change_status_chip.dart';

/// The details screen's single panel: the booking, the amendment, the dates
/// either side of the office's answer, and whatever notes came back with it.
class BookingChangeSummaryCard extends StatelessWidget {
  const BookingChangeSummaryCard({super.key, required this.request});

  final BookingChangeRequestModel request;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = context.locale.toString();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              // What the request asks for is the headline here; the list is
              // where the requests are numbered.
              Expanded(
                child: Text(
                  bookingChangeTypeLabel(request),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge,
                ),
              ),
              const Gap(10),
              BookingChangeStatusChip(status: request.status),
            ],
          ),
          const Gap(14),
          BookingChangeField(
            label: request.tripTitle ?? 'trip_number'.tr(),
            value: request.reference,
          ),
          const Gap(12),
          const Divider(height: 1),
          const Gap(12),
          BookingChangeField(
            label: 'booking_change_requested_at'.tr(),
            value: AppFormat.shortDate(request.createdAt, locale),
          ),
          // Only a request the office has looked at carries a review date.
          if (request.reviewedAt != null) ...[
            const Gap(12),
            const Divider(height: 1),
            const Gap(12),
            BookingChangeField(
              label: 'booking_change_reviewed_at'.tr(),
              value: AppFormat.shortDate(request.reviewedAt, locale),
            ),
          ],
          if (request.detailsText case final details?) ...[
            const Gap(12),
            const Divider(height: 1),
            const Gap(12),
            BookingChangeField(
              label: 'booking_change_details'.tr(),
              value: details,
              maxLines: 8,
            ),
          ],
          if (request.adminNotesText case final notes?) ...[
            const Gap(12),
            const Divider(height: 1),
            const Gap(12),
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
