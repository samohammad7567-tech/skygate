import 'package:flutter/material.dart';

/// Grey text placeholder used by the mocked passport page on the scan screen.
class PlaceholderBar extends StatelessWidget {
  const PlaceholderBar({super.key, required this.widthFactor, this.height = 8});

  final double widthFactor;
  final double height;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: AlignmentDirectional.centerStart,
      widthFactor: widthFactor,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outline,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
