import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/home_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';

class CustomTripNotice extends StatelessWidget {
  const CustomTripNotice({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.s, vertical: 8.s),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8.s),
      ),
      child: Row(
        children: [
          AppImage(
            HomeAssets.clock,
            width: 16.s,
            height: 16.s,
            color: theme.colorScheme.primary,
          ),
          SizedBox(width: 8.s),
          Expanded(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
