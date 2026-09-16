import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_status_chip.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/vip_trip/models/private_trip_request_model.dart';

class VipStatusChip extends StatelessWidget {
  const VipStatusChip({super.key, required this.status});

  final PrivateTripStatus status;

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
