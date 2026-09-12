import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_card.dart';
import 'package:skygate/core/components/cached_image.dart';
import 'package:skygate/core/constants/journey_assets.dart';
import 'package:skygate/core/models/journey_transport.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/carriers/models/carrier_model.dart';
import 'package:skygate/core/components/vehicle_spec_tile.dart';

class CarrierCard extends StatelessWidget {
  const CarrierCard({
    super.key,
    required this.carrier,
    required this.transport,
  });

  final CarrierModel carrier;
  final JourneyTransport transport;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.fromLTRB(14.s, 14.s, 14.s, 16.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CompanyRow(carrier: carrier, transport: transport),
          SizedBox(height: 12.s),
          Divider(height: 1.s),
          SizedBox(height: 14.s),
          // The three values wrap to different line counts, so the tallest
          // tile sets the height and the others stretch to match it.
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
                SizedBox(width: 10.s),
                Expanded(
                  child: VehicleSpecTile(
                    asset: transport.modelIcon,
                    labelKey: 'vehicle_model',
                    value: carrier.model ?? '—',
                  ),
                ),
                SizedBox(width: 10.s),
                Expanded(
                  child: VehicleSpecTile(
                    asset: JourneyAssets.seat,
                    labelKey: 'vehicle_capacity',
                    value: carrier.capacity == null
                        ? '—'
                        : 'seats_count'.tr(
                            namedArgs: {'count': '${carrier.capacity}'},
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CompanyRow extends StatelessWidget {
  const _CompanyRow({required this.carrier, required this.transport});

  final CarrierModel carrier;
  final JourneyTransport transport;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // The lockup sits on the start side with the two text lines pushed up
    // against it, so the empty half of the row falls on the end side.
    return Row(
      children: [
        CachedImage(
          url: carrier.logo,
          fallbackAsset: transport.fallbackLogo,
          height: 34.s,
          width: 84.s,
          fit: BoxFit.contain,
        ),
        SizedBox(width: 12.s),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'vehicle_company'.tr(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall,
              ),
              Text(
                carrier.name ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
