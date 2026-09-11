import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/constants/vip_trip_assets.dart';
import 'package:skygate/core/utils/app_format.dart';
import 'package:skygate/features/vip_trip/models/private_trip_request_model.dart';
import 'package:skygate/features/vip_trip/widgets/vip_status_chip.dart';

class VipRequestCard extends StatelessWidget {
  const VipRequestCard({
    super.key,
    required this.request,
    required this.index,
    required this.onDetails,
  });

  final PrivateTripRequestModel request;
  final int index;

  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VipStatusChip(status: request.status),
              const Spacer(),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'vip_request_number'.tr(namedArgs: {'index': '$index'}),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const Gap(2),
                    Text(
                      request.reference,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(10),
          const Divider(height: 1),
          const Gap(10),
          Row(
            children: [
              Text(
                'travelers_count'.tr(
                  namedArgs: {'count': '${request.travelers}'},
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.secondary,
                ),
              ),
              const Spacer(),
              Text(
                'travelers_number'.tr(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const Gap(10),
          const Divider(height: 1),
          const Gap(10),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _DateBlock(
                    labelKey: 'start_date',
                    date: request.startDate,
                  ),
                ),
                const VerticalDivider(width: 20),
                Expanded(
                  child: _DateBlock(
                    labelKey: 'end_date',
                    date: request.endDate,
                  ),
                ),
              ],
            ),
          ),
          const Gap(12),
          CustomButton(
            label: 'view_details'.tr(),
            height: 42,
            width: double.infinity,
            onPressed: onDetails,
          ),
        ],
      ),
    );
  }
}

class _DateBlock extends StatelessWidget {
  const _DateBlock({required this.labelKey, required this.date});

  final String labelKey;
  final DateTime? date;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppImage(
          VipTripAssets.calendar,
          height: 18,
          color: theme.colorScheme.primary,
        ),
        const Gap(8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                labelKey.tr(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              const Gap(2),
              Text(
                AppFormat.numericDate(date),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
