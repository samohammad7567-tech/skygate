import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/home/models/travel_category_model.dart';

class TravelCategoriesBar extends StatelessWidget {
  const TravelCategoriesBar({
    super.key,
    required this.categories,
    required this.selectedId,
    required this.onSelected,
  });

  final List<TravelCategoryModel> categories;
  final String selectedId;
  final ValueChanged<String> onSelected;

  static const double _pillHeight = 68;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // Room for the pill plus the shadow it casts.
      height: _pillHeight + 12,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.s, vertical: 4.s),
        itemCount: categories.length,
        separatorBuilder: (_, _) => SizedBox(width: 14.s),
        itemBuilder: (_, index) {
          final category = categories[index];
          return _CategoryPill(
            category: category,
            isSelected: category.id == selectedId,
            onTap: () => onSelected(category.id),
          );
        },
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  final TravelCategoryModel category;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foreground = isSelected
        ? theme.colorScheme.secondary
        : theme.colorScheme.primary;
    final radius = BorderRadius.circular(10.s);

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: radius,
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.10),
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: SizedBox(
          width: 68.s,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppImage(
                      category.icon,
                      width: 24.s,
                      height: 24.s,
                      color: foreground,
                    ),
                    SizedBox(height: 8.s),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.s),
                      child: Text(
                        category.titleKey.tr(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: foreground,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Orange underline marks the active category.
              Container(
                height: 5.s,
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.secondary
                      : Colors.transparent,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(10.s),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
