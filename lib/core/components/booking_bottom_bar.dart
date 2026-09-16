import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';

class BookingBottomBar extends StatelessWidget {
  const BookingBottomBar({
    super.key,
    required this.onContinue,
    this.onBack,
    this.isLoading = false,
    this.continueLabel,
  });
  final VoidCallback? onContinue;
  final VoidCallback? onBack;

  final bool isLoading;
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
          padding: EdgeInsets.fromLTRB(20.s, 14.s, 20.s, 14.s),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 46.s,
                  child: OutlinedButton(
                    onPressed:
                        onBack ?? () => NaivgatorHelper.popNavigation(context),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: theme.colorScheme.surface,
                      side: BorderSide(color: theme.colorScheme.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.s),
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
              SizedBox(width: 12.s),

              Expanded(
                child: CustomButton(
                  label: continueLabel ?? 'continue_step'.tr(),
                  onPressed: onContinue,
                  isLoading: isLoading,
                  height: 46.s,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
