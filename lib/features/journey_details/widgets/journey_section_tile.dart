import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_card.dart';
import 'package:skygate/core/components/app_glyph_plate.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/journey_details/models/journey_package_model.dart';

class JourneySectionTile extends StatelessWidget {
  const JourneySectionTile({super.key, required this.section, this.onTap});

  final JourneySectionModel section;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.all(14.s),
      child: Row(
        children: [
          AppGlyphPlate(
            asset: section.asset,
            icon: section.icon,
            size: 44.s,
            glyphSize: 22.s,
          ),
          SizedBox(width: 12.s),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  section.titleKey.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium,
                ),
                Text(
                  section.descKey.tr(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          SizedBox(width: 8.s),
          // `arrow_forward_ios` is a directional glyph, so it turns itself
          // around under RTL and keeps pointing "onwards".
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16.s,
            color: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
