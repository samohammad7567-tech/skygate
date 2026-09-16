import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_glyph_plate.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/constants/sos_assets.dart';
import 'package:skygate/core/utils/app_format.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/sos/models/chat_message_model.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message});

  final ChatMessageModel message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMine = message.isMine;

    final background = isMine
        ? theme.colorScheme.primary
        : theme.colorScheme.surface;
    final foreground = isMine
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.onSurface;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.s, vertical: 6.s),
      child: Row(
        mainAxisAlignment: isMine
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isMine) ...[
            AppGlyphPlate(
              asset: SosAssets.chat,
              size: 36.s,
              glyphSize: 18.s,
              color: theme.colorScheme.onPrimary,
              background: theme.colorScheme.primary,
            ),
            Gap(8.s),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.fromLTRB(14.s, 10.s, 14.s, 8.s),
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(14.s),
                border: isMine
                    ? null
                    : Border.all(color: theme.colorScheme.outline),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (message.senderName != null) ...[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            message.senderName!,
                            textAlign: TextAlign.end,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: isMine
                                  ? foreground
                                  : theme.colorScheme.primary,
                            ),
                          ),
                        ),
                        // `sender_user_id` without a pilgrim id means staff.
                        if (message.isStaff) ...[
                          Gap(6.s),
                          _StaffBadge(isMine: isMine),
                        ],
                      ],
                    ),
                    Gap(4.s),
                  ],
                  Text(
                    message.body ?? '',
                    textAlign: TextAlign.end,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: foreground,
                      height: 1.6.s,
                    ),
                  ),
                  Gap(6.s),
                  _MetaRow(message: message, foreground: foreground),
                ],
              ),
            ),
          ),
          if (!isMine) ...[
            Gap(8.s),
            AppGlyphPlate(
              asset: SosAssets.supervisors,
              size: 36.s,
              glyphSize: 18.s,
              color: theme.colorScheme.primary,
            ),
          ],
        ],
      ),
    );
  }
}

class _StaffBadge extends StatelessWidget {
  const _StaffBadge({required this.isMine});

  final bool isMine;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tint = isMine ? theme.colorScheme.onPrimary : AppColors.accent;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.s, vertical: 2.s),
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(6.s),
      ),
      child: Text(
        'sos_chat_staff'.tr(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodySmall?.copyWith(color: tint, fontSize: 9.fs),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.message, required this.foreground});

  final ChatMessageModel message;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (message.isMine) ...[
          message.isPending
              ? SizedBox(
                  height: 10.s,
                  width: 10.s,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.4.s,
                    color: foreground.withValues(alpha: 0.7),
                  ),
                )
              : AppImage(
                  SosAssets.read,
                  height: 13.s,
                  width: 13.s,
                  color: foreground.withValues(alpha: 0.8),
                ),
          Gap(6.s),
        ],
        Text(
          AppFormat.time(message.sentAt, context.locale.languageCode),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            color: foreground.withValues(alpha: 0.7),
            fontSize: 10.fs,
          ),
        ),
      ],
    );
  }
}
