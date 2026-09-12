import 'package:flutter/material.dart';
import 'package:skygate/core/utils/app_scale.dart';

class SheetHandle extends StatelessWidget {
  const SheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 4.s,
        width: 44.s,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outlineVariant,
          borderRadius: BorderRadius.circular(4.s),
        ),
      ),
    );
  }
}
