import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// "تعليمات التقاط الصورة بدقة" box between the scan frame and the capture
/// button.
class CaptureInstructionsCard extends StatelessWidget {
  const CaptureInstructionsCard({super.key});

  /// The three bullets are fixed design content.
  static const List<String> instructionKeys = [
    'capture_instruction_1',
    'capture_instruction_2',
    'capture_instruction_3',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'capture_instructions'.tr(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall,
          ),
          const Gap(8),
          for (final key in instructionKeys) ...[
            _Bullet(text: key.tr()),
            const Gap(6),
          ],
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.end,
            style: theme.textTheme.bodySmall,
          ),
        ),
        const Gap(8),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Container(
            height: 6,
            width: 6,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
