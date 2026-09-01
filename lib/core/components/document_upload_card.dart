import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/dashed_box.dart';
import 'package:skygate/core/components/document_criteria_list.dart';
import 'package:skygate/core/components/upload_size_chip.dart';
import 'package:skygate/core/constants/auth_assets.dart';
import 'package:skygate/core/models/umrah_document_model.dart';

/// One card on "ملفات المعتمر": title, drop zone, and the accepted criteria.
class DocumentUploadCard extends StatelessWidget {
  const DocumentUploadCard({
    super.key,
    required this.document,
    required this.file,
    required this.onTap,
    required this.onRemove,
  });

  final UmrahDocumentModel document;
  final File? file;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        children: [
          _Title(document: document),
          const Gap(12),
          DashedBox(
            onTap: onTap,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: file == null ? const _Empty() : _Attached(file: file!),
          ),
          if (file != null) ...[
            const Gap(4),
            TextButton(
              onPressed: onRemove,
              child: Text(
                'remove_file'.tr(),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
          const Gap(10),
          const DocumentCriteriaList(),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({required this.document});

  final UmrahDocumentModel document;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            document.titleKey.tr(),
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium,
          ),
        ),
        const Gap(10),
        Container(
          height: 36,
          width: 36,
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
      ],
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        AppImage(
          AuthAssets.upload,
          height: 26,
          color: theme.colorScheme.primary,
        ),
        const Gap(8),
        Text(
          'tap_to_upload_file'.tr(),
          textAlign: TextAlign.center,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        const Gap(8),
        const UploadSizeChip(),
      ],
    );
  }
}

class _Attached extends StatelessWidget {
  const _Attached({required this.file});

  final File file;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(
            file,
            height: 110,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        const Gap(8),
        Text(
          'file_uploaded'.tr(),
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ],
    );
  }
}
