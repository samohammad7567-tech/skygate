import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/constants/journey_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/group_booking/widgets/group_dialog_buttons.dart';

Future<bool> showGroupDeleteRoomDialog(BuildContext context) async {
  final confirmed = await _show(
    context,
    icon: Icons.delete_outline,
    tint: AppColors.error,
    message: 'delete_room_question'.tr(),
    confirmKey: 'yes',
    cancelKey: 'no',
    confirmColor: AppColors.error,
  );
  return confirmed ?? false;
}

Future<bool> showGroupLockBedsDialog(BuildContext context) async {
  final confirmed = await _show(
    context,
    asset: JourneyAssets.bed,
    message: 'lock_beds_note'.tr(),
    confirmKey: 'lock_beds',
    cancelKey: 'cancel',
  );
  return confirmed ?? false;
}

Future<void> showGroupRoomFullDialog(BuildContext context) => _show(
  context,
  icon: Icons.info_outline,
  message: 'room_capacity_reached'.tr(),
  confirmKey: 'ok',
);
Future<bool?> _show(
  BuildContext context, {
  required String message,
  required String confirmKey,
  IconData? icon,
  String? asset,
  String? cancelKey,
  Color? tint,
  Color? confirmColor,
}) {
  final theme = Theme.of(context);
  final accent = tint ?? theme.colorScheme.primary;

  return showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.s)),
      contentPadding: EdgeInsets.fromLTRB(24.s, 28.s, 24.s, 20.s),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 52.s,
            width: 52.s,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: asset != null
                  ? AppImage(asset, height: 24.s, color: accent)
                  : Icon(icon, size: 26.s, color: accent),
            ),
          ),
          Gap(18.s),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleSmall,
          ),
          Gap(22.s),
          Row(
            children: [
              Expanded(
                child: GroupDialogConfirm(
                  labelKey: confirmKey,
                  color: confirmColor ?? theme.colorScheme.primary,
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                ),
              ),
              if (cancelKey != null) ...[
                Gap(12.s),
                Expanded(
                  child: GroupDialogCancel(
                    labelKey: cancelKey,
                    onPressed: () => Navigator.of(dialogContext).pop(false),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    ),
  );
}
