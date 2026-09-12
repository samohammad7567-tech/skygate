import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_card.dart';
import 'package:skygate/core/components/app_glyph_plate.dart';
import 'package:skygate/core/constants/journey_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/journey_details/models/journey_package_model.dart';

class JourneySupervisorsCard extends StatelessWidget {
  const JourneySupervisorsCard({super.key, required this.supervisors});

  final List<JourneyStaffModel> supervisors;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      padding: EdgeInsets.all(14.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const AppGlyphPlate(asset: JourneyAssets.supervisors),
              SizedBox(width: 10.s),
              Expanded(
                child: Text(
                  'supervised_by'.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ],
          ),
          if (supervisors.isNotEmpty) ...[
            SizedBox(height: 10.s),
            Wrap(
              spacing: 16.s,
              runSpacing: 8.s,
              children: [
                for (final member in supervisors)
                  SizedBox(
                    width: 140.s,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          member.name ?? '—',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall,
                        ),
                        if (member.role != null)
                          Text(
                            member.role!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.secondary,
                              fontSize: 11.fs,
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
