import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_glyph_plate.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/sos_assets.dart';
import 'package:skygate/core/utils/app_format.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        mainAxisAlignment: isMine
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isMine) ...[
            AppGlyphPlate(
              asset: SosAssets.chat,
              size: 36,
              glyphSize: 18,
              color: theme.colorScheme.onPrimary,
              background: theme.colorScheme.primary,
            ),
            const Gap(8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(14),
                border: isMine
                    ? null
                    : Border.all(color: theme.colorScheme.outline),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (message.senderName != null) ...[
                    Text(
                      message.senderName!,
                      textAlign: TextAlign.end,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: isMine ? foreground : theme.colorScheme.primary,
                      ),
                    ),
                    const Gap(4),
                  ],
                  Text(
                    message.body ?? '',
                    textAlign: TextAlign.end,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: foreground,
                      height: 1.6,
                    ),
                  ),
                  const Gap(6),
                  _MetaRow(message: message, foreground: foreground),
                ],
              ),
            ),
          ),
          if (!isMine) ...[
            const Gap(8),
            AppGlyphPlate(
              asset: SosAssets.supervisors,
              size: 36,
              glyphSize: 18,
              color: theme.colorScheme.primary,
            ),
          ],
        ],
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
                  height: 10,
                  width: 10,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.4,
                    color: foreground.withValues(alpha: 0.7),
                  ),
                )
              : AppImage(
                  SosAssets.read,
                  height: 13,
                  width: 13,
                  color: foreground.withValues(alpha: 0.8),
                ),
          const Gap(6),
        ],
        Text(
          AppFormat.time(message.sentAt, context.locale.languageCode),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            color: foreground.withValues(alpha: 0.7),
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
