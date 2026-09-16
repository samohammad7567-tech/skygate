import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/journey_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';

class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    super.key,
    required this.controller,
    required this.hintKey,
    required this.onSubmitted,
    this.actionAsset,
    this.onActionTap,
    this.actionTooltip,
  }) : assert(
         actionAsset == null || onActionTap != null,
         'an action chip needs something to do',
       );

  final TextEditingController controller;
  final String hintKey;

  final ValueChanged<String> onSubmitted;
  final String? actionAsset;

  final VoidCallback? onActionTap;
  final String? actionTooltip;

  static const double _height = 46;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(child: _field(context, theme)),
        if (actionAsset != null) ...[
          SizedBox(width: 12.s),
          _action(context, theme),
        ],
      ],
    );
  }

  Widget _field(BuildContext context, ThemeData theme) {
    return Container(
      height: _height,
      padding: EdgeInsets.symmetric(horizontal: 14.s),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24.s),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Row(
        children: [
          AppImage(
            JourneyAssets.search,
            height: 18.s,
            width: 18.s,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          SizedBox(width: 8.s),
          Expanded(
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.search,
              onSubmitted: onSubmitted,
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: hintKey.tr(),
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _action(BuildContext context, ThemeData theme) {
    return Material(
      color: theme.colorScheme.surface,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onActionTap,
        child: Container(
          height: _height,
          width: _height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: theme.colorScheme.outline),
          ),
          child: Tooltip(
            message: actionTooltip ?? '',
            child: AppImage(
              actionAsset!,
              height: 20.s,
              width: 20.s,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
