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
import 'package:skygate/core/utils/app_scale.dart';

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
      padding: EdgeInsets.all(12.s),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.s),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        children: [
          _Title(document: document),
          Gap(12.s),
          DashedBox(
            onTap: onTap,
            padding: EdgeInsets.symmetric(horizontal: 12.s, vertical: 16.s),
            child: file == null ? const _Empty() : _Attached(file: file!),
          ),
          if (file != null) ...[
            Gap(4.s),
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
          Gap(10.s),
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

    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 40.s,
            width: 40.s,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: AppImage(
                document.icon,
                height: 20.s,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          Gap(10.s),

          Text(
            document.titleKey.tr(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium,
          ),
        ],
      ),
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
          height: 26.s,
          color: theme.colorScheme.primary,
        ),
        Gap(8.s),
        Text(
          'tap_to_upload_file'.tr(),
          textAlign: TextAlign.center,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        Gap(8.s),
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
          borderRadius: BorderRadius.circular(10.s),
          child: Image.file(
            file,
            height: 110.s,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Gap(8.s),
        Text(
          'file_uploaded'.tr(),
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ],
    );
  }
}
