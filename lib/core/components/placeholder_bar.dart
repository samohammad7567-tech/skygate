import 'package:flutter/material.dart';
import 'package:skygate/core/utils/app_scale.dart';

class PlaceholderBar extends StatelessWidget {
  const PlaceholderBar({super.key, required this.widthFactor, this.height});

  final double widthFactor;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: AlignmentDirectional.centerStart,
      widthFactor: widthFactor,
      child: Container(
        height: (height ?? 8.s),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outline,
          borderRadius: BorderRadius.circular(4.s),
        ),
      ),
    );
  }
}
