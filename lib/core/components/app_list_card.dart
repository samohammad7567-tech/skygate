import 'package:flutter/material.dart';
import 'package:skygate/core/utils/app_scale.dart';

/// A bordered panel that stacks rows behind one rounded outline, hairlined
/// between each pair.
///
/// It is the shape every grouped list in the app draws — the profile's
/// information block, each of the settings screen's sections — so the rows
/// stay dumb and only this decides where the dividers fall.
class AppListCard extends StatelessWidget {
  const AppListCard({super.key, required this.children, this.radius});

  final List<Widget> children;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.circular((radius ?? 16.s));

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: borderRadius,
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          border: Border.all(color: theme.colorScheme.outline),
        ),
        child: Column(
          children: [
            for (var index = 0; index < children.length; index++) ...[
              if (index > 0)
                Divider(
                  height: 1.s,
                  thickness: 1.s,
                  indent: 14.s,
                  endIndent: 14.s,
                  color: theme.colorScheme.outline,
                ),
              children[index],
            ],
          ],
        ),
      ),
    );
  }
}
