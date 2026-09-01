import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/cached_image.dart';
import 'package:skygate/core/constants/journey_assets.dart';
import 'package:skygate/core/models/journey_transport.dart';
import 'package:skygate/features/journey_details/models/journey_route_model.dart';
import 'package:skygate/features/journey_details/widgets/vehicle_spec_tile.dart';

/// "تفاصيل المركبة :" — the operator line plus the three spec tiles.
class SegmentVehicleSection extends StatelessWidget {
  const SegmentVehicleSection({
    super.key,
    required this.transport,
    required this.vehicle,
  });

  final JourneyTransport transport;
  final JourneyVehicleModel? vehicle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${'vehicle_details'.tr()} :',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'vehicle_company'.tr(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                  Text(
                    vehicle?.companyName ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            CachedImage(
              url: vehicle?.companyLogo,
              fallbackAsset: transport.fallbackLogo,
              height: 34,
              width: 84,
              fit: BoxFit.contain,
            ),
          ],
        ),
        const SizedBox(height: 14),
        // The three values wrap to different line counts, so the tallest tile
        // sets the height and the others stretch to match it.
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: VehicleSpecTile(
                  asset: transport.typeIcon,
                  labelKey: 'vehicle_type',
                  value: transport.labelKey.tr(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: VehicleSpecTile(
                  asset: transport.modelIcon,
                  labelKey: 'vehicle_model',
                  value: vehicle?.model ?? '—',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: VehicleSpecTile(
                  asset: JourneyAssets.seat,
                  labelKey: 'vehicle_capacity',
                  value: vehicle?.capacity == null
                      ? '—'
                      : 'seats_count'.tr(
                          namedArgs: {'count': '${vehicle!.capacity}'},
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
