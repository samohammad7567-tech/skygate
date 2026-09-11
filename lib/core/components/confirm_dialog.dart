import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';

Future<bool> showConfirmDialog(
  BuildContext context, {
  required String message,
  required String confirmKey,
  String cancelKey = 'cancel',
  IconData? icon,
  String? asset,
  Color? tint,
}) async {
  final theme = Theme.of(context);
  final accent = tint ?? theme.colorScheme.primary;

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: asset != null
                  ? AppImage(asset, height: 24, color: accent)
                  : Icon(icon, size: 26, color: accent),
            ),
          ),
          const Gap(18),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleSmall,
          ),
          const Gap(22),
          Row(
            children: [
              Expanded(
                child: _DialogAction(
                  labelKey: confirmKey,
                  color: accent,
                  isFilled: true,
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                ),
              ),
              const Gap(12),
              Expanded(
                child: _DialogAction(
                  labelKey: cancelKey,
                  color: theme.colorScheme.primary,
                  isFilled: false,
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  return confirmed ?? false;
}

class _DialogAction extends StatelessWidget {
  const _DialogAction({
    required this.labelKey,
    required this.color,
    required this.isFilled,
    required this.onPressed,
  });

  final String labelKey;
  final Color color;
  final bool isFilled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    );
    final label = Text(
      labelKey.tr(),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.labelLarge?.copyWith(
        color: isFilled ? theme.colorScheme.onPrimary : color,
      ),
    );

    return SizedBox(
      height: 44,
      child: isFilled
          ? ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                elevation: 0,
                shape: shape,
              ),
              child: label,
            )
          : OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: color),
                shape: shape,
              ),
              child: label,
            ),
    );
  }
}
