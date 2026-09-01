import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/constants/home_assets.dart';

/// Haram photo with the travel-date search card floating over its lower edge.
class HeroSearchCard extends StatelessWidget {
  const HeroSearchCard({
    super.key,
    required this.travelDate,
    this.onPickDate,
    this.onSearch,
  });

  final DateTime? travelDate;
  final VoidCallback? onPickDate;
  final VoidCallback? onSearch;

  static const double _imageHeight = 184;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: AppImage(
              HomeAssets.heroBackground,
              height: _imageHeight,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          PositionedDirectional(
            bottom: 12,
            start: 8,
            end: 8,
            child: _SearchCard(
              travelDate: travelDate,
              onPickDate: onPickDate,
              onSearch: onSearch,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchCard extends StatelessWidget {
  const _SearchCard({required this.travelDate, this.onPickDate, this.onSearch});

  final DateTime? travelDate;
  final VoidCallback? onPickDate;
  final VoidCallback? onSearch;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      elevation: 6,
      shadowColor: Colors.black.withValues(alpha: 0.12),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            AppImage(
              HomeAssets.calendar,
              width: 26,
              height: 26,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: InkWell(
                onTap: onPickDate,
                borderRadius: BorderRadius.circular(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'travel_date'.tr(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      travelDate == null
                          ? 'choose_umrah_trip_date'.tr()
                          : DateFormat.yMMMMd(
                              context.locale.languageCode,
                            ).format(travelDate!),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.75,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            CustomButton(
              label: 'search'.tr(),
              onPressed: onSearch,
              height: 42,
              icon: AppImage(
                HomeAssets.search,
                width: 18,
                height: 18,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
