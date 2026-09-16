import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_glyph_plate.dart';
import 'package:skygate/core/utils/app_format.dart';
import 'package:skygate/core/models/activity_model.dart';
import 'package:skygate/core/utils/app_scale.dart';

class MapActivityRow extends StatelessWidget {
  const MapActivityRow({super.key, required this.activity, this.onTap});

  final ActivityModel activity;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: activity.hasCoordinates ? onTap : null,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.s, vertical: 12.s),
        child: Row(
          children: [
            AppGlyphPlate(
              asset: activity.kind.icon,
              size: 38.s,
              glyphSize: 18.s,
              color: activity.accentColor,
              background: activity.surfaceColor,
            ),
            SizedBox(width: 12.s),
            Expanded(
              child: Text(
                _hour(context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium,
              ),
            ),
            SizedBox(width: 12.s),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  activity.title ?? activity.typeName ?? '—',
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: activity.accentColor,
                  ),
                ),
                SizedBox(height: 2.s),
                Text(
                  activity.place ?? '',
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _hour(BuildContext context) {
    final from = activity.fromTime;
    if (from == null) return '—';

    final parts = from.split(':');
    final hour = int.tryParse(parts.first);
    final minute = parts.length > 1 ? int.tryParse(parts[1]) : 0;
    if (hour == null) return from;

    return AppFormat.time(
      DateTime(2000, 1, 1, hour, minute ?? 0),
      context.locale.languageCode,
    );
  }
}
