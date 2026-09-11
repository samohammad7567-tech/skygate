import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/profile_assets.dart';
import 'package:skygate/core/models/umrah_document_model.dart';
import 'package:skygate/features/profile/models/pilgrim_document_model.dart';
import 'package:skygate/features/profile/widgets/document_status_chip.dart';

class PilgrimFileRow extends StatelessWidget {
  const PilgrimFileRow({
    super.key,
    required this.document,
    required this.upload,
    required this.onPreview,
  });

  final UmrahDocumentModel document;
  final PilgrimDocumentModel? upload;
  final VoidCallback onPreview;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canPreview = upload?.hasFile ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: AppImage(
                document.icon,
                height: 20,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.titleKey.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const Gap(6),
                DocumentStatusChip(status: upload?.review),
              ],
            ),
          ),
          const Gap(10),
          _PreviewButton(onTap: canPreview ? onPreview : null),
        ],
      ),
    );
  }
}

class _PreviewButton extends StatelessWidget {
  const _PreviewButton({required this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final enabled = onTap != null;
    final accent = enabled
        ? theme.colorScheme.primary
        : theme.colorScheme.outlineVariant;

    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 32),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        side: BorderSide(color: accent),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'preview'.tr(),
            style: theme.textTheme.bodySmall?.copyWith(color: accent),
          ),
          const Gap(6),
          AppImage(ProfileAssets.visibility, height: 14, color: accent),
        ],
      ),
    );
  }
}
