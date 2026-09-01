import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_card.dart';
import 'package:skygate/core/components/app_glyph_plate.dart';
import 'package:skygate/features/journey_details/models/journey_package_model.dart';

/// The pair of "مكة المكرمة · 4 أيام" chips under the supervisors card.
class JourneyStaysRow extends StatelessWidget {
  const JourneyStaysRow({super.key, required this.stays});

  final List<JourneyStayModel> stays;

  @override
  Widget build(BuildContext context) {
    if (stays.isEmpty) return const SizedBox.shrink();

    // The chips carry different amounts of copy, so the taller one sets the
    // height and the other stretches to match it.
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < stays.length; i++) ...[
            Expanded(child: _StayChip(stay: stays[i])),
            if (i < stays.length - 1) const SizedBox(width: 12),
          ],
        ],
      ),
    );
  }
}

class _StayChip extends StatelessWidget {
  const _StayChip({required this.stay});

  final JourneyStayModel stay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          AppGlyphPlate(asset: stay.icon, size: 36, glyphSize: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  stay.city ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall,
                ),
                Text(
                  'days_count'.tr(namedArgs: {'count': '${stay.days ?? 0}'}),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
