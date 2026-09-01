import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_back_button.dart';

/// Page title centred between the status bar and the body, with the round back
/// chip pinned to the end side.
///
/// The chip sits on the end side because the Arabic mockups place it on the
/// left; a directional alignment keeps it sensible under LTR too.
class AppPageHeader extends StatelessWidget {
  const AppPageHeader({super.key, required this.title, this.onBack});

  final String title;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppBackButton.size + 8,
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleLarge,
            ),
          ),
          PositionedDirectional(end: 0, child: AppBackButton(onTap: onBack)),
        ],
      ),
    );
  }
}
