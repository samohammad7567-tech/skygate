import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/utils/app_scale.dart';

class VehicleSpecTile extends StatelessWidget {
  const VehicleSpecTile({
    super.key,
    required this.asset,
    required this.labelKey,
    required this.value,
  });

  final String asset;
  final String labelKey;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.s, vertical: 12.s),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10.s),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppImage(
            asset,
            height: 24.s,
            width: 24.s,
            color: theme.colorScheme.primary,
          ),
          SizedBox(height: 8.s),
          Text(
            labelKey.tr(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
          SizedBox(height: 2.s),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}
