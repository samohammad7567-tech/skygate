// `easy_localization` re-exports `intl`, whose own `TextDirection` would
// shadow the one `Directionality` answers with.
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_glyph_button.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/map_assets.dart';
import 'package:skygate/core/utils/app_format.dart';

class MapDateBar extends StatelessWidget {
  const MapDateBar({
    super.key,
    required this.date,
    required this.onPrevious,
    required this.onNext,
    required this.onPickDate,
  });

  final DateTime date;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onPickDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
      child: Row(
        children: [
          AppGlyphButton(
            mirrorInRtl: true,
            asset: MapAssets.chevronPrevious,
            tooltip: 'map_previous_day'.tr(),
            onTap: onPrevious,
          ),
          Expanded(
            child: Center(
              child: Material(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: onPickDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: theme.colorScheme.primary),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppImage(
                          MapAssets.calendar,
                          height: 16,
                          width: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppFormat.isoDate(date),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          AppGlyphButton(
            mirrorInRtl: true,
            asset: MapAssets.chevronNext,
            tooltip: 'map_next_day'.tr(),
            onTap: onNext,
          ),
        ],
      ),
    );
  }
}
