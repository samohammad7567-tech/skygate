import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/empty_state.dart';
import 'package:skygate/core/components/sheet_handle.dart';
import 'package:skygate/core/utils/app_format.dart';
import 'package:skygate/features/home/models/home_model.dart';

class NotificationsSheet extends StatelessWidget {
  const NotificationsSheet({
    super.key,
    required this.notifications,
    this.onRead,
  });

  final List<HomeNotificationModel> notifications;
  final ValueChanged<HomeNotificationModel>? onRead;

  static Future<void> show(
    BuildContext context, {
    required List<HomeNotificationModel> notifications,
    ValueChanged<HomeNotificationModel>? onRead,
  }) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) =>
        NotificationsSheet(notifications: notifications, onRead: onRead),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            const SheetHandle(),
            const SizedBox(height: 12),
            Text(
              'notifications'.tr(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Flexible(
              child: notifications.isEmpty
                  ? EmptyState(message: 'no-notifications'.tr())
                  : ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                      itemCount: notifications.length,
                      separatorBuilder: (_, _) => const Divider(height: 16),
                      itemBuilder: (_, index) => _NotificationTile(
                        alert: notifications[index],
                        onRead: onRead,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.alert, this.onRead});

  final HomeNotificationModel alert;
  final ValueChanged<HomeNotificationModel>? onRead;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: alert.isRead ? null : () => onRead?.call(alert),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // An unread alert carries the same accent dot the bell counts.
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Container(
              height: 8,
              width: 8,
              decoration: BoxDecoration(
                color: alert.isRead
                    ? theme.colorScheme.outlineVariant
                    : theme.colorScheme.secondary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.title ?? '—',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall,
                ),
                if (alert.body != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    alert.body!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
                if (alert.createdAt != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    AppFormat.shortDate(
                      alert.createdAt,
                      context.locale.languageCode,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
