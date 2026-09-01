import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/utils/app_format.dart';
import 'package:skygate/features/journey_details/models/activity_model.dart';

/// "اليوم ٣ · ٥ مارس" tabs above the activities timeline.
///
/// Three looks: the selected day is filled, the day the trip is on today is
/// outlined and carries a dot, and the rest are plain.
class ActivityDayTabs extends StatelessWidget {
  const ActivityDayTabs({
    super.key,
    required this.days,
    required this.selectedIndex,
    required this.todayIndex,
    required this.onSelected,
  });

  final List<ActivityDayModel> days;
  final int selectedIndex;
  final int todayIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 86,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: days.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) => _DayTab(
          day: days[index],
          isSelected: index == selectedIndex,
          isToday: index == todayIndex,
          onTap: () => onSelected(index),
        ),
      ),
    );
  }
}

class _DayTab extends StatelessWidget {
  const _DayTab({
    required this.day,
    required this.isSelected,
    required this.isToday,
    required this.onTap,
  });

  final ActivityDayModel day;
  final bool isSelected;
  final bool isToday;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = context.locale.languageCode;
    final radius = BorderRadius.circular(12);
    final onTint = isSelected
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.primary;

    return Material(
      color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surface,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          width: 74,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(
              color: isToday && !isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'day'.tr(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isSelected ? theme.colorScheme.onPrimary : null,
                ),
              ),
              Text(
                '${day.number}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.headlineSmall?.copyWith(color: onTint),
              ),
              Text(
                AppFormat.dayMonth(day.date, locale),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isSelected ? theme.colorScheme.onPrimary : null,
                ),
              ),
              if (isToday && !isSelected)
                Container(
                  margin: const EdgeInsets.only(top: 3),
                  height: 5,
                  width: 5,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
