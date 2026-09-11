import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/constants/home_assets.dart';
import 'package:skygate/features/home/models/home_model.dart';

class HeroSearchCard extends StatelessWidget {
  const HeroSearchCard({
    super.key,
    required this.travelDate,
    this.city,
    this.onPickCity,
    this.onPickDate,
    this.onSearch,
  });

  final DateTime? travelDate;
  final HomeCityModel? city;

  final VoidCallback? onPickCity;
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
              city: city,
              onPickCity: onPickCity,
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
  const _SearchCard({
    required this.travelDate,
    this.city,
    this.onPickCity,
    this.onPickDate,
    this.onSearch,
  });

  final DateTime? travelDate;
  final HomeCityModel? city;
  final VoidCallback? onPickCity;
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // `GET app/home` publishes the cities the search can be narrowed
            // to; the row hides itself on a payload that carries none.
            if (onPickCity != null) ...[
              _Field(
                asset: HomeAssets.hotel,
                label: 'departure_city'.tr(),
                value: city?.city ?? 'all_cities'.tr(),
                onTap: onPickCity,
              ),
              const Divider(height: 14),
            ],
            Row(
              children: [
                Expanded(
                  child: _Field(
                    asset: HomeAssets.calendar,
                    label: 'travel_date'.tr(),
                    value: travelDate == null
                        ? 'choose_umrah_trip_date'.tr()
                        : DateFormat.yMMMMd(
                            context.locale.languageCode,
                          ).format(travelDate!),
                    onTap: onPickDate,
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
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.asset,
    required this.label,
    required this.value,
    this.onTap,
  });

  final String asset;
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        children: [
          AppImage(
            asset,
            width: 26,
            height: 26,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
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
