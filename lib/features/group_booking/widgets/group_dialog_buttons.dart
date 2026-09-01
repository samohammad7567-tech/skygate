import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// The confirming action of a group dialog — "نعم", "إغلاق الأسرة", "حسناً".
class GroupDialogConfirm extends StatelessWidget {
  const GroupDialogConfirm({
    super.key,
    required this.labelKey,
    required this.color,
    required this.onPressed,
  });

  final String labelKey;

  /// Red on a destructive dialog, the brand blue elsewhere.
  final Color color;

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 44,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          labelKey.tr(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}

/// The way out of a group dialog — "لا", "إلغاء".
class GroupDialogCancel extends StatelessWidget {
  const GroupDialogCancel({
    super.key,
    required this.labelKey,
    required this.onPressed,
  });

  final String labelKey;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 44,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: theme.colorScheme.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          labelKey.tr(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
