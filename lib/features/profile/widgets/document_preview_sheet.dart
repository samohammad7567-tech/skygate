import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/components/empty_state.dart';
import 'package:skygate/core/components/sheet_handle.dart';
import 'package:skygate/core/models/umrah_document_model.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/profile/models/pilgrim_document_model.dart';
import 'package:skygate/features/profile/widgets/document_status_chip.dart';

class DocumentPreviewSheet extends StatelessWidget {
  const DocumentPreviewSheet({
    super.key,
    required this.document,
    required this.upload,
  });

  final UmrahDocumentModel document;
  final PilgrimDocumentModel upload;

  static Future<void> show(
    BuildContext context, {
    required UmrahDocumentModel document,
    required PilgrimDocumentModel upload,
  }) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22.s)),
    ),
    builder: (_) => DocumentPreviewSheet(document: document, upload: upload),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final url = upload.fileUrl;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.s, 12.s, 20.s, 20.s),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SheetHandle(),
            Gap(16.s),
            _Title(document: document, upload: upload),
            Gap(18.s),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * 0.5,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14.s),
                child: url == null
                    ? EmptyState(message: 'no_file_uploaded'.tr())
                    : CachedNetworkImage(
                        imageUrl: url,
                        fit: BoxFit.contain,
                        width: double.infinity,
                        placeholder: (_, _) => const _Loading(),
                        errorWidget: (_, _, _) =>
                            EmptyState(message: 'file_preview_failed'.tr()),
                      ),
              ),
            ),
            if (upload.review == DocumentReviewStatus.rejected &&
                upload.rejectionReason != null) ...[
              Gap(12.s),
              Text(
                upload.rejectionReason!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
            Gap(20.s),
            CustomButton(
              label: 'back'.tr(),
              width: double.infinity,
              height: 46.s,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({required this.document, required this.upload});

  final UmrahDocumentModel document;
  final PilgrimDocumentModel upload;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
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
        Gap(12.s),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'pilgrim_file'.tr(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall,
              ),
              Gap(2.s),
              Text(
                document.titleKey.tr(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        Gap(10.s),
        DocumentStatusChip(status: upload.review),
      ],
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 180.vs,
    child: Center(child: CircularProgressIndicator(strokeWidth: 2.s)),
  );
}
