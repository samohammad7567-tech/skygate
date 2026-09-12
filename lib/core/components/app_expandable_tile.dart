import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/my_trips_assets.dart';

/// A pilgrim row that folds open to show what belongs to them.
///
/// The cards, visas and tickets tabs are all the same list: a portrait, a
/// name, the traveller's class, and a chevron that reveals that pilgrim's
/// documents underneath. Only the contents differ, so the row itself lives
/// here and each tab passes its own [children].
class AppExpandableTile extends StatelessWidget {
  const AppExpandableTile({
    super.key,
    required this.leading,
    required this.title,
    required this.isExpanded,
    required this.onToggle,
    this.badge,
    this.children = const [],
  });

  final Widget leading;
  final String title;

  /// The class pill under the name — `AudienceChip` at every call site so
  /// far, but kept a plain widget so a tab can print something else.
  final Widget? badge;

  final bool isExpanded;
  final VoidCallback onToggle;

  /// Revealed under the header while [isExpanded]. Laid out stretched, with
  /// the gap between entries already applied.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Header(
            leading: leading,
            title: title,
            badge: badge,
            isExpanded: isExpanded,
            onToggle: onToggle,
          ),
          if (isExpanded && children.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < children.length; i++) ...[
                    if (i > 0) const SizedBox(height: 10),
                    children[i],
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.leading,
    required this.title,
    required this.badge,
    required this.isExpanded,
    required this.onToggle,
  });

  final Widget leading;
  final String title;
  final Widget? badge;
  final bool isExpanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  if (badge != null) ...[
                    const SizedBox(height: 4),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: badge!,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            // The chevron is the only part that moves, so it turns rather
            // than being swapped for a second glyph.
            // The export points up, so a closed row is the one turned over.
            AnimatedRotation(
              turns: isExpanded ? 0 : 0.5,
              duration: const Duration(milliseconds: 180),
              child: AppImage(
                MyTripsAssets.chevronUp,
                height: 10,
                width: 16,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
