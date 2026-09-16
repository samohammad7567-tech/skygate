import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';

class ChatHeader extends StatelessWidget {
  const ChatHeader({super.key, required this.isOnline});

  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.fromLTRB(16.s, 12.s, 16.s, 8.s),
      padding: EdgeInsets.symmetric(horizontal: 12.s, vertical: 12.s),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(16.s),
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
                Gap(4.s),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 7.s,
                      width: 7.s,
                      decoration: BoxDecoration(
                        color: isOnline
                            ? AppColors.success
                            : theme.colorScheme.onPrimary.withValues(
                                alpha: 0.5,
                              ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Gap(6.s),
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
          SizedBox(width: 40.s),
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
          height: 40.s,
          width: 40.s,
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 16.s,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
