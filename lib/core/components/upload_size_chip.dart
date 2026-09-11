import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class UploadSizeChip extends StatelessWidget {
  const UploadSizeChip({super.key, this.labelKey = 'max_upload_size'});

  final String labelKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        labelKey.tr(),
        textAlign: TextAlign.center,
        style: theme.textTheme.bodySmall,
      ),
    );
  }
}
