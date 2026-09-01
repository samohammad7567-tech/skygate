import 'package:flutter/material.dart';

/// The grey grab bar every bottom sheet in the group flow opens with.
class GroupSheetHandle extends StatelessWidget {
  const GroupSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 4,
        width: 44,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outlineVariant,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
