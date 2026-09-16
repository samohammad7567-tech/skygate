import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/app_stepper_button.dart';
import 'package:skygate/core/utils/app_scale.dart';

class VipStepperRow extends StatelessWidget {
  const VipStepperRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.icon,
    this.min = 0,
    this.max = 99,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;
  final String? icon;

  final int min;
  final int max;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.s, vertical: 10.s),
      child: Row(
        children: [
          _Stepper(value: value, min: min, max: max, onChanged: onChanged),
          Gap(12.s),
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          if (icon != null) ...[
            Gap(10.s),
            AppImage(icon!, height: 20.s, color: theme.colorScheme.primary),
          ],
        ],
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.s, vertical: 5.s),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20.s),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppStepperButton(
            icon: Icons.remove,
            onTap: value > min ? () => onChanged(value - 1) : null,
          ),
          SizedBox(
            width: 36.s,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              maxLines: 1,
              style: theme.textTheme.titleMedium,
            ),
          ),
          AppStepperButton(
            icon: Icons.add,
            onTap: value < max ? () => onChanged(value + 1) : null,
          ),
        ],
      ),
    );
  }
}
