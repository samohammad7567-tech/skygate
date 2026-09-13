import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/utils/app_scale.dart';

class CaptureInstructionsCard extends StatelessWidget {
  const CaptureInstructionsCard({super.key});
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
      padding: EdgeInsets.fromLTRB(14.s, 12.s, 14.s, 12.s),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.s),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'capture_instructions'.tr(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall,
          ),
          Gap(8.s),
          for (final key in instructionKeys) ...[
            _Bullet(text: key.tr()),
            Gap(6.s),
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
        Padding(
          padding: EdgeInsets.only(top: 5.s),
          child: Container(
            height: 6.s,
            width: 6.s,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Gap(8.s),

        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.start,
            style: theme.textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
