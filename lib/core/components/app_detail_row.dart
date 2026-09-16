import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/utils/app_scale.dart';

class AppDetailRow extends StatelessWidget {
  const AppDetailRow({
    super.key,
    required this.labelKey,
    this.value,
    this.asset,
    this.icon,
    this.showDivider = true,
  }) : assert(asset != null || icon != null, 'a row needs a glyph');

  final String labelKey;
  final String? value;

  final String? asset;
  final IconData? icon;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.s),
          child: Row(
            children: [
              _Glyph(asset: asset, icon: icon),
              SizedBox(width: 10.s),
              Expanded(
                child: Text(
                  '${labelKey.tr()} : ${value ?? '—'}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
        if (showDivider) Divider(height: 1.s),
      ],
    );
  }
}

class _Glyph extends StatelessWidget {
  const _Glyph({this.asset, this.icon});

  final String? asset;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    if (asset case final path?) {
      return AppImage(path, height: 18.s, width: 18.s, color: color);
    }
    return Icon(icon, size: 18.s, color: color);
  }
}
