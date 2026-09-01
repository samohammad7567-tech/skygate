import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';

/// White strip pinned under every wizard step: "متابعة" on the start side,
/// "عودة" after it.
class BookingBottomBar extends StatelessWidget {
  const BookingBottomBar({
    super.key,
    required this.onContinue,
    this.onBack,
    this.isLoading = false,
    this.continueLabel,
  });

  /// `null` disables the primary action — used while a step has nothing
  /// selected yet.
  final VoidCallback? onContinue;

  /// Defaults to popping the route.
  final VoidCallback? onBack;

  final bool isLoading;

  /// Overrides "متابعة" on the last step.
  final String? continueLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(top: BorderSide(color: theme.colorScheme.outline)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          child: Row(
            children: [
              Expanded(
                child: CustomButton(
                  label: continueLabel ?? 'continue_step'.tr(),
                  onPressed: onContinue,
                  isLoading: isLoading,
                  height: 46,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: OutlinedButton(
                    onPressed:
                        onBack ?? () => NaivgatorHelper.popNavigation(context),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: theme.colorScheme.surface,
                      side: BorderSide(color: theme.colorScheme.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'back_step'.tr(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
