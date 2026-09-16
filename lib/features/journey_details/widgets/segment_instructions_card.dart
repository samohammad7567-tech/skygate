import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_card.dart';
import 'package:skygate/core/utils/app_scale.dart';

class SegmentInstructionsCard extends StatelessWidget {
  const SegmentInstructionsCard({super.key, required this.instructions});

  final List<String> instructions;

  @override
  Widget build(BuildContext context) {
    if (instructions.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);

    return AppCard(
      padding: EdgeInsets.all(14.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'important_instructions'.tr(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 8.s),
          for (final instruction in instructions)
            Padding(
              padding: EdgeInsets.only(bottom: 6.s),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 5.s),
                    child: Container(
                      height: 4.s,
                      width: 4.s,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.s),
                  Expanded(
                    child: Text(
                      instruction,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
