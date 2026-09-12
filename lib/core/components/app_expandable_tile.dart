import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/my_trips_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';

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
        borderRadius: BorderRadius.circular(14.s),
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
              padding: EdgeInsets.fromLTRB(10.s, 0, 10.s, 10.s),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < children.length; i++) ...[
                    if (i > 0) SizedBox(height: 10.s),
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
      borderRadius: BorderRadius.circular(14.s),
      child: Padding(
        padding: EdgeInsets.all(10.s),
        child: Row(
          children: [
            leading,
            SizedBox(width: 10.s),
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
                    SizedBox(height: 4.s),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: badge!,
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 8.s),
            // The chevron is the only part that moves, so it turns rather
            // than being swapped for a second glyph.
            // The export points up, so a closed row is the one turned over.
            AnimatedRotation(
              turns: isExpanded ? 0 : 0.5,
              duration: const Duration(milliseconds: 180),
              child: AppImage(
                MyTripsAssets.chevronUp,
                height: 10.s,
                width: 16.s,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
