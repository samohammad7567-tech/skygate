import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/empty_state.dart';
import 'package:skygate/core/components/sheet_handle.dart';
import 'package:skygate/core/utils/app_format.dart';
import 'package:skygate/core/utils/app_scale.dart';
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
            SizedBox(height: 10.s),
            const SheetHandle(),
            SizedBox(height: 12.s),
            Text(
              'notifications'.tr(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleLarge,
            ),
            SizedBox(height: 8.s),
            Flexible(
              child: notifications.isEmpty
                  ? EmptyState(message: 'no-notifications'.tr())
                  : ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.fromLTRB(16.s, 4.s, 16.s, 16.s),
                      itemCount: notifications.length,
                      separatorBuilder: (_, _) => Divider(height: 16.s),
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
            padding: EdgeInsets.only(top: 6.s),
            child: Container(
              height: 8.s,
              width: 8.s,
              decoration: BoxDecoration(
                color: alert.isRead
                    ? theme.colorScheme.outlineVariant
                    : theme.colorScheme.secondary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(width: 10.s),
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
                  SizedBox(height: 2.s),
                  Text(
                    alert.body!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
                if (alert.createdAt != null) ...[
                  SizedBox(height: 4.s),
                  Text(
                    AppFormat.shortDate(
                      alert.createdAt,
                      context.locale.languageCode,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      fontSize: 11.fs,
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
