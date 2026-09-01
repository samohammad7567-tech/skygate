import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/custom_button.dart';

/// Skip and Next buttons below the copy card.
///
/// Order is semantic — skip first, next last — so RTL puts Next on the left
/// and Skip on the right as designed, while LTR gets the usual arrangement.
class OnBoardingActions extends StatelessWidget {
  const OnBoardingActions({super.key, this.onSkip, this.onNext});

  final VoidCallback? onSkip;
  final VoidCallback? onNext;

  static const double _buttonWidth = 88;
  static const double _buttonHeight = 45;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OutlinedButton(
          onPressed: onSkip,
          style: OutlinedButton.styleFrom(
            foregroundColor: theme.colorScheme.primary,
            fixedSize: const Size(_buttonWidth, _buttonHeight),
            side: BorderSide(color: theme.colorScheme.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9),
            ),
          ),
          child: Text(
            'skip'.tr(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        CustomButton(
          label: 'next'.tr(),
          onPressed: onNext,
          width: _buttonWidth,
          height: _buttonHeight,
          radius: 9,
        ),
      ],
    );
  }
}
