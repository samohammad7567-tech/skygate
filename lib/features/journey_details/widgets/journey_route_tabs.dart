import 'package:flutter/material.dart';
import 'package:skygate/core/utils/app_format.dart';
import 'package:skygate/features/journey_details/models/journey_route_model.dart';

/// "المسار الأول / الثاني / الثالث" tabs above the itinerary timeline.
///
/// The row scrolls horizontally so a package with many routes never squeezes
/// its labels.
class JourneyRouteTabs extends StatelessWidget {
  const JourneyRouteTabs({
    super.key,
    required this.routes,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<JourneyRouteModel> routes;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    if (routes.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: routes.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) => _RouteTab(
          label:
              routes[index].name ??
              AppFormat.ordinalTitle('route_title', index + 1),
          isSelected: index == selectedIndex,
          onTap: () => onSelected(index),
        ),
      ),
    );
  }
}

class _RouteTab extends StatelessWidget {
  const _RouteTab({
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
    final radius = BorderRadius.circular(10);

    return Material(
      color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surface,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: theme.colorScheme.primary),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              color: isSelected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
