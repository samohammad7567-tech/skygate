import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/utils/app_scale.dart';

/// One `[glyph]  label : value` line with the hairline under it.
///
/// Every travel document the app prints is a stack of these — the pilgrim
/// card's passport and hotel lines, a visa's number and dates, a ticket's file
/// link and issue date, a luggage tag's serial. The glyph comes either as a
/// bundled [asset] or as a Material [icon], because a few of the design's
/// glyphs have no export yet.
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

  /// Printed after the label behind a colon. A row whose value the API has
  /// not filled still draws, with an em dash, so the card keeps its shape.
  final String? value;

  final String? asset;
  final IconData? icon;

  /// Cleared on the last row of a card, where the divider would double up
  /// with the card's own edge.
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
