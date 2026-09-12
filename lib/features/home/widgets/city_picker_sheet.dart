import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/empty_state.dart';
import 'package:skygate/core/components/sheet_handle.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/home/models/home_model.dart';

class CityPickerSheet extends StatelessWidget {
  const CityPickerSheet({super.key, required this.cities, this.selected});

  final List<HomeCityModel> cities;
  final HomeCityModel? selected;
  static Future<CityPickResult?> show(
    BuildContext context, {
    required List<HomeCityModel> cities,
    HomeCityModel? selected,
  }) => showModalBottomSheet<CityPickResult>(
    context: context,
    isScrollControlled: true,
    builder: (_) => CityPickerSheet(cities: cities, selected: selected),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: ConstrainedBox(
        // The list comes down whole, so the sheet caps itself rather than
        // growing with however many cities the backend publishes.
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.6,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10.s),
            const SheetHandle(),
            SizedBox(height: 12.s),
            Text(
              'select_city'.tr(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleLarge,
            ),
            SizedBox(height: 8.s),
            Flexible(child: _body(context)),
          ],
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    if (cities.isEmpty) {
      return EmptyState(message: 'no_cities'.tr());
    }

    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.only(bottom: 12.s),
      children: [
        _CityTile(
          label: 'all_cities'.tr(),
          isSelected: selected == null,
          onTap: () => Navigator.pop(context, const CityPickResult(city: null)),
        ),
        for (final city in cities)
          _CityTile(
            label: city.city ?? '—',
            isSelected: city.id == selected?.id,
            onTap: () => Navigator.pop(context, CityPickResult(city: city)),
          ),
      ],
    );
  }
}

class CityPickResult {
  const CityPickResult({required this.city});

  final HomeCityModel? city;
}

class _CityTile extends StatelessWidget {
  const _CityTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      onTap: onTap,
      title: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: isSelected ? theme.colorScheme.primary : null,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check, color: theme.colorScheme.primary, size: 20.s)
          : null,
    );
  }
}
