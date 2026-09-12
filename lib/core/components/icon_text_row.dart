import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/utils/app_scale.dart';

class IconTextRow extends StatelessWidget {
  const IconTextRow({
    super.key,
    required this.asset,
    required this.text,
    this.iconColor,
    this.textStyle,
    this.iconSize,
  });

  final String asset;
  final String text;
  final Color? iconColor;
  final TextStyle? textStyle;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        AppImage(
          asset,
          height: (iconSize ?? 16.s),
          width: (iconSize ?? 16.s),
          color: iconColor ?? theme.colorScheme.primary,
        ),
        SizedBox(width: 6.s),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textStyle ?? theme.textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
