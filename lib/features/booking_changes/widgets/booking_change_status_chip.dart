import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_status_chip.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/booking_changes/models/booking_change_request_model.dart';

class BookingChangeStatusChip extends StatelessWidget {
  const BookingChangeStatusChip({super.key, required this.status});

  final BookingChangeStatus status;

  @override
  Widget build(BuildContext context) {
    return AppStatusChip(
      labelKey: status.labelKey,
      background: status.background,
      foreground: status.foreground,
      radius: 8.s,
    );
  }
}
