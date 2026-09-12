import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_card.dart';
import 'package:skygate/core/components/app_document_actions.dart';
import 'package:skygate/core/components/app_status_chip.dart';
import 'package:skygate/features/cards/models/luggage_tag_model.dart';

/// One bag under a name on "بطاقات الحقائب": which bag it is, whether the tag
/// is live, its serial, and the two actions.
class LuggageTagTile extends StatelessWidget {
  const LuggageTagTile({
    super.key,
    required this.tag,
    required this.position,
    required this.isDownloading,
    required this.onDownload,
    required this.onPreview,
  });

  final LuggageTagModel tag;

  /// Its place in this pilgrim's bags — the design numbers them from one.
  final int position;

  final bool isDownloading;
  final VoidCallback onDownload;
  final VoidCallback onPreview;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'luggage_card_number'.tr(args: ['$position']),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              AppStatusChip(
                labelKey: tag.status.labelKey,
                background: tag.status.background,
                foreground: tag.status.foreground,
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 10),
          Text(
            'luggage_serial'.tr(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            tag.tagNumber ?? '—',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          AppDocumentActions(
            isDownloading: isDownloading,
            onDownload: onDownload,
            onPreview: onPreview,
          ),
        ],
      ),
    );
  }
}
