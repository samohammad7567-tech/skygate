import 'package:flutter/material.dart';
import 'package:skygate/core/utils/app_scale.dart';

class RegisterStepper extends StatelessWidget {
  const RegisterStepper({super.key, required this.currentStep});
  final int currentStep;

  static const int _stepCount = 3;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int step = 1; step <= _stepCount; step++) ...[
          _StepDot(number: step, isDone: step <= currentStep),
          if (step < _stepCount)
            Expanded(child: _Connector(isDone: step < currentStep)),
        ],
      ],
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({required this.number, required this.isDone});

  final int number;
  final bool isDone;

  static const double _size = 40;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: _size,
      width: _size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDone ? theme.colorScheme.primary : theme.colorScheme.surface,
        border: Border.all(color: theme.colorScheme.primary, width: 1.6.s),
      ),
      child: Text(
        '$number',
        style: theme.textTheme.titleMedium?.copyWith(
          color: isDone
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.primary,
        ),
      ),
    );
  }
}

class _Connector extends StatelessWidget {
  const _Connector({required this.isDone});

  final bool isDone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: isDone ? 3 : 1.5,
      color: isDone ? theme.colorScheme.primary : theme.colorScheme.outline,
    );
  }
}
