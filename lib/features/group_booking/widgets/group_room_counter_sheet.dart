import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/constants/journey_assets.dart';
import 'package:skygate/features/group_booking/models/group_room_type.dart';
import 'package:skygate/features/group_booking/widgets/group_room_counter_row.dart';
import 'package:skygate/features/group_booking/widgets/group_sheet_handle.dart';

/// "حدد عدد الغرف و أنواعها :" — the stepper sheet shared by the rooms step
/// and the per-hotel allocation on the hotels step.
///
/// Returns the counts the user settled on, or `null` when the sheet is
/// dismissed without confirming.
Future<Map<GroupRoomType, int>?> showGroupRoomCounterSheet(
  BuildContext context, {
  required List<GroupRoomType> types,
  required Map<GroupRoomType, int> initial,
  Map<GroupRoomType, int>? maxCounts,
}) {
  return showModalBottomSheet<Map<GroupRoomType, int>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
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

  /// A size with no ceiling is only bounded by what the group can sensibly
  /// book, which the rooms step leaves open.
  int _maxOf(GroupRoomType type) => widget.maxCounts[type] ?? 99;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const GroupSheetHandle(),
            const Gap(14),
            Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: AppImage(
                      JourneyAssets.bed,
                      height: 20,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                const Gap(12),
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
            const Gap(8),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: widget.types.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
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
            const Gap(14),
            CustomButton(
              label: 'confirm_selection'.tr(),
              height: 48,
              onPressed: () => Navigator.of(context).pop(_counts),
            ),
          ],
        ),
      ),
    );
  }
}
