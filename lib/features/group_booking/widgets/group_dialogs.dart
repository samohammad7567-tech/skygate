import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/constants/journey_assets.dart';
import 'package:skygate/features/group_booking/widgets/group_dialog_buttons.dart';

/// "هل أنت متأكد من أنك تريد حذف هذه الغرفة؟" — answers `true` for "نعم".
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

/// "يلزم دفع رسوم الأسرة المتبقية غير المحجوزة لإتمام حجز الغرفة." — answers
/// `true` once the spare beds are paid for.
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

/// "لقد وصلت سعة الغرفة الى الحد الأقصى" — a notice, with nothing to decide.
Future<void> showGroupRoomFullDialog(BuildContext context) => _show(
  context,
  icon: Icons.info_outline,
  message: 'room_capacity_reached'.tr(),
  confirmKey: 'ok',
);

/// The card every dialog in the flow shares: the tinted glyph, the message,
/// then its actions — the confirming one on the start side.
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: asset != null
                  ? AppImage(asset, height: 24, color: accent)
                  : Icon(icon, size: 26, color: accent),
            ),
          ),
          const Gap(18),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleSmall,
          ),
          const Gap(22),
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
                const Gap(12),
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
