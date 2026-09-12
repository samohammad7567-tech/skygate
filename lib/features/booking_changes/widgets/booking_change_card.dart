import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/booking_changes/models/booking_change_request_model.dart';
import 'package:skygate/features/booking_changes/utils/booking_change_labels.dart';
import 'package:skygate/features/booking_changes/widgets/booking_change_field.dart';
import 'package:skygate/features/booking_changes/widgets/booking_change_status_chip.dart';

/// One row of "طلبات تعديل الحجوزات": the request's number and standing, the
/// booking it changes, what it asks for, and the way into its details.
class BookingChangeCard extends StatelessWidget {
  const BookingChangeCard({
    super.key,
    required this.request,
    required this.index,
    required this.onDetails,
  });

  final BookingChangeRequestModel request;

  /// Position in the list. The design numbers the requests as the reader sees
  /// them rather than by the id the API assigned.
  final int index;

  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(14.s),
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
                  'booking_change_number'.tr(namedArgs: {'index': '$index'}),
                  maxLines: 1,
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
            label: 'booking_change_type'.tr(),
            value: bookingChangeTypeLabel(request),
          ),
          Gap(12.s),
          Divider(height: 1.s),
          Gap(14.s),
          CustomButton(
            label: 'view_details'.tr(),
            height: 42.s,
            width: double.infinity,
            onPressed: onDetails,
          ),
        ],
      ),
    );
  }
}
