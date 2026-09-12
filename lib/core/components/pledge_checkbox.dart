import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/utils/app_scale.dart';

class PledgeCheckbox extends StatelessWidget {
  const PledgeCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(8.s),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.s),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                'passport_pledge'.tr(),
                textAlign: TextAlign.end,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Gap(10.s),
            SizedBox(
              height: 24.s,
              width: 24.s,
              child: Checkbox(value: value, onChanged: onChanged),
            ),
          ],
        ),
      ),
    );
  }
}
