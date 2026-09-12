import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/constants/my_trips_assets.dart';
import 'package:skygate/core/models/activity_model.dart';

/// The single button at the foot of an activity card.
///
/// A live action — check in, or rate — is filled and tappable; once done it
/// becomes the outline that states what happened and no longer responds.
class ActivityActionButton extends StatelessWidget {
  const ActivityActionButton({
    super.key,
    required this.action,
    required this.onPressed,
    this.isBusy = false,
  });

  final ActivityAction action;
  final VoidCallback onPressed;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (action.isDone) {
      return SizedBox(
        height: 40,
        width: double.infinity,
        child: OutlinedButton.icon(
          // A settled card states its standing; tapping it does nothing.
          onPressed: null,
          icon: action == ActivityAction.rated
              ? AppImage(
                  MyTripsAssets.thumbUp,
                  height: 18,
                  width: 18,
                  color: theme.colorScheme.primary,
                )
              : Icon(
                  Icons.check_circle_outline,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
          label: Text(
            action.labelKey.tr(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          style: OutlinedButton.styleFrom(
            backgroundColor: theme.colorScheme.surface,
            disabledForegroundColor: theme.colorScheme.primary,
            side: BorderSide(color: theme.colorScheme.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );
    }

    return CustomButton(
      label: action.labelKey.tr(),
      height: 40,
      width: double.infinity,
      isLoading: isBusy,
      onPressed: onPressed,
      icon: action == ActivityAction.rate
          ? const AppImage(
              MyTripsAssets.thumbUp,
              height: 18,
              width: 18,
              color: AppColors.surface,
            )
          : const Icon(Icons.check_circle_outline, size: 18),
    );
  }
}
