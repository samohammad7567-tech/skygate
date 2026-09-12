import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_glyph_button.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/sos_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';

class ChatComposer extends StatelessWidget {
  const ChatComposer({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onUnavailable,
  });

  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onUnavailable;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(12.s, 10.s, 12.s, 10.s),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(top: BorderSide(color: theme.colorScheme.outline)),
        ),
        child: Row(
          children: [
            _SendButton(controller: controller, onSend: onSend),
            Gap(10.s),
            Expanded(
              child: Container(
                padding: EdgeInsetsDirectional.only(start: 6.s, end: 12.s),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(24.s),
                  border: Border.all(color: theme.colorScheme.outline),
                ),
                child: Row(
                  children: [
                    AppGlyphButton(
                      asset: SosAssets.attach,
                      tooltip: 'sos_chat_attach'.tr(),
                      onTap: onUnavailable,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        textAlign: TextAlign.end,
                        minLines: 1,
                        maxLines: 4,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => onSend(),
                        style: theme.textTheme.bodyMedium,
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintText: 'sos_chat_hint'.tr(),
                          hintStyle: theme.textTheme.bodySmall,
                        ),
                      ),
                    ),
                    AppGlyphButton(
                      asset: SosAssets.microphone,
                      tooltip: 'sos_chat_voice'.tr(),
                      onTap: onUnavailable,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({required this.controller, required this.onSend});

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final canSend = value.text.trim().isNotEmpty;

        return Material(
          color: canSend
              ? theme.colorScheme.primary
              : theme.colorScheme.primary.withValues(alpha: 0.4),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: canSend ? onSend : null,
            child: SizedBox(
              height: 44.s,
              width: 44.s,
              child: Icon(
                Icons.arrow_back,
                size: 20.s,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
        );
      },
    );
  }
}
