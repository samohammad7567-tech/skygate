import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';

class ChatHeader extends StatelessWidget {
  const ChatHeader({super.key, required this.isOnline});

  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _BackChip(onTap: () => NaivgatorHelper.popNavigation(context)),
          Expanded(
            child: Column(
              children: [
                Text(
                  'sos_chat_title'.tr(),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                const Gap(4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 7,
                      width: 7,
                      decoration: BoxDecoration(
                        color: isOnline
                            ? AppColors.success
                            : theme.colorScheme.onPrimary.withValues(
                                alpha: 0.5,
                              ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const Gap(6),
                    Text(
                      (isOnline ? 'sos_online_now' : 'sos_offline').tr(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Balances the back chip so the title stays optically centred.
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}

class _BackChip extends StatelessWidget {
  const _BackChip({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          height: 40,
          width: 40,
          child: Icon(
            // Direction-aware, so it points the way back in both languages.
            Icons.arrow_back_ios_new,
            size: 16,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
