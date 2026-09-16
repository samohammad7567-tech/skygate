import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/app_sheet.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/components/sheet_handle.dart';
import 'package:skygate/core/constants/journey_assets.dart';
import 'package:skygate/core/models/group_room_type.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/group_booking/widgets/group_room_counter_row.dart';

Future<Map<GroupRoomType, int>?> showGroupRoomCounterSheet(
  BuildContext context, {
  required List<GroupRoomType> types,
  required Map<GroupRoomType, int> initial,
  Map<GroupRoomType, int>? maxCounts,
}) {
  return showAppSheet<Map<GroupRoomType, int>>(
    context,
    builder: (_) => _CounterSheet(
      types: types,
      initial: initial,
      maxCounts: maxCounts ?? const {},
    ),
  );
}

class _CounterSheet extends StatefulWidget {
  const _CounterSheet({
    required this.types,
    required this.initial,
    required this.maxCounts,
  });

  final List<GroupRoomType> types;
  final Map<GroupRoomType, int> initial;
  final Map<GroupRoomType, int> maxCounts;

  @override
  State<_CounterSheet> createState() => _CounterSheetState();
}

class _CounterSheetState extends State<_CounterSheet> {
  late final Map<GroupRoomType, int> _counts = {
    for (final type in widget.types) type: widget.initial[type] ?? 0,
  };
  int _maxOf(GroupRoomType type) => widget.maxCounts[type] ?? 99;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.s, 12.s, 20.s, 16.s),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SheetHandle(),
            Gap(14.s),
            Row(
              children: [
                Container(
                  height: 40.s,
                  width: 40.s,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: AppImage(
                      JourneyAssets.bed,
                      height: 20.s,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                Gap(12.s),
                Expanded(
                  child: Text(
                    'rooms_counter_title'.tr(),
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            Gap(8.s),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: widget.types.length,
                separatorBuilder: (_, _) => Divider(height: 1.s),
                itemBuilder: (_, index) {
                  final type = widget.types[index];
                  return GroupRoomCounterRow(
                    type: type,
                    count: _counts[type] ?? 0,
                    max: _maxOf(type),
                    onChanged: (value) => setState(() => _counts[type] = value),
                  );
                },
              ),
            ),
            Gap(14.s),
            CustomButton(
              label: 'confirm_selection'.tr(),
              height: 48.s,
              onPressed: () => Navigator.of(context).pop(_counts),
            ),
          ],
        ),
      ),
    );
  }
}
