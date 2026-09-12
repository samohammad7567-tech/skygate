import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/models/umrah_document_model.dart';
import 'package:skygate/core/utils/app_scale.dart';

class DocumentCriteriaList extends StatelessWidget {
  const DocumentCriteriaList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.s, vertical: 10.s),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12.s),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'accepted_criteria'.tr(),
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          Gap(6.s),
          for (final key in UmrahDocumentModel.criteriaKeys) ...[
            Text(
              '• ${key.tr()}',
              textAlign: TextAlign.end,
              style: theme.textTheme.bodySmall,
            ),
            Gap(4.s),
          ],
        ],
      ),
    );
  }
}
