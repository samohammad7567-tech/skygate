import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/payment_detail_row.dart';
import 'package:skygate/core/models/booking_city.dart';
import 'package:skygate/core/models/group_room_type.dart';
import 'package:skygate/core/utils/app_format.dart';
import 'package:skygate/features/vip_trip/models/private_trip_request_model.dart';
import 'package:skygate/features/vip_trip/widgets/vip_status_chip.dart';

class VipSummaryCard extends StatelessWidget {
  const VipSummaryCard({
    super.key,
    required this.travelers,
    required this.startDate,
    required this.endDate,
    required this.roomCounts,
    this.makkahNights,
    this.madinahNights,
    this.makkahHotel,
    this.madinahHotel,
    this.notes,
    this.status,
  });
  final String travelers;

  final DateTime? startDate;
  final DateTime? endDate;
  final int? makkahNights;
  final int? madinahNights;
  final Map<GroupRoomType, int> roomCounts;

  final String? makkahHotel;
  final String? madinahHotel;
  final String? notes;
  final PrivateTripStatus? status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Header(status: status),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PaymentDetailRow(labelKey: 'travelers', value: travelers),
                const Divider(height: 1),
                PaymentDetailRow(
                  labelKey: 'start_date',
                  value: AppFormat.numericDate(startDate),
                ),
                const Divider(height: 1),
                PaymentDetailRow(
                  labelKey: 'end_date',
                  value: AppFormat.numericDate(endDate),
                ),
                const Divider(height: 1),
                PaymentDetailRow(
                  labelKey: 'makkah_nights',
                  value: _days(makkahNights),
                ),
                const Divider(height: 1),
                PaymentDetailRow(
                  labelKey: 'madinah_nights',
                  value: _days(madinahNights),
                ),
                const Divider(height: 1),
                PaymentDetailRow(
                  labelKey: 'room_types',
                  child: _Rooms(counts: roomCounts),
                ),
                const Divider(height: 1),
                PaymentDetailRow(
                  labelKey: BookingCity.madinah.hotelLabelKey,
                  value: madinahHotel,
                ),
                const Divider(height: 1),
                PaymentDetailRow(
                  labelKey: BookingCity.makkah.hotelLabelKey,
                  value: makkahHotel,
                ),
                const Divider(height: 1),
                PaymentDetailRow(labelKey: 'notes', value: notes),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String? _days(int? count) =>
      count == null ? null : 'days_count'.tr(namedArgs: {'count': '$count'});
}

class _Header extends StatelessWidget {
  const _Header({required this.status});

  final PrivateTripStatus? status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          if (status != null) VipStatusChip(status: status!),
          const Spacer(),
          Flexible(
            child: Text(
              'private_trip_request'.tr(),
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleLarge,
            ),
          ),
        ],
      ),
    );
  }
}

class _Rooms extends StatelessWidget {
  const _Rooms({required this.counts});

  final Map<GroupRoomType, int> counts;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.titleMedium;

    if (counts.isEmpty) return Text('—', style: style);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final type in GroupRoomType.values)
          if ((counts[type] ?? 0) > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Text(
                    type.labelKey.tr(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: style,
                  ),
                  const SizedBox(width: 14),
                  Text(
                    'room_count_of'.tr(namedArgs: {'count': '${counts[type]}'}),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: style,
                  ),
                ],
              ),
            ),
      ],
    );
  }
}
