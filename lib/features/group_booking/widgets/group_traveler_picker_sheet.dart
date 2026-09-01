import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/features/group_booking/models/group_room_type.dart';
import 'package:skygate/features/group_booking/models/group_traveler_model.dart';
import 'package:skygate/features/group_booking/widgets/group_dialogs.dart';
import 'package:skygate/features/group_booking/widgets/group_picker_header.dart';
import 'package:skygate/features/group_booking/widgets/group_picker_row.dart';
import 'package:skygate/features/group_booking/widgets/group_sheet_handle.dart';

/// "من ترغب بإضافته إلى الغرفة الثنائية ؟" — seats travellers in one room.
///
/// Returns the ids that ended up ticked, in the order they were ticked, which
/// is also the order the infant rates are applied in. `null` means the sheet
/// was dismissed and the room keeps whoever it already had.
Future<List<int>?> showGroupTravelerPickerSheet(
  BuildContext context, {
  required GroupRoomType type,
  required List<GroupTravelerModel> travelers,
  required List<int> selected,
  required int capacity,
  required String? currency,
  required num Function(List<int> selection, int localId) priceOf,
  required bool Function(List<int> selection, int localId) isSecondInfant,
}) {
  return showModalBottomSheet<List<int>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _PickerSheet(
      type: type,
      travelers: travelers,
      selected: selected,
      capacity: capacity,
      currency: currency,
      priceOf: priceOf,
      isSecondInfant: isSecondInfant,
    ),
  );
}

class _PickerSheet extends StatefulWidget {
  const _PickerSheet({
    required this.type,
    required this.travelers,
    required this.selected,
    required this.capacity,
    required this.currency,
    required this.priceOf,
    required this.isSecondInfant,
  });

  final GroupRoomType type;
  final List<GroupTravelerModel> travelers;
  final List<int> selected;
  final int capacity;
  final String? currency;
  final num Function(List<int>, int) priceOf;
  final bool Function(List<int>, int) isSecondInfant;

  @override
  State<_PickerSheet> createState() => _PickerSheetState();
}

class _PickerSheetState extends State<_PickerSheet> {
  late final List<int> _selection = [...widget.selected];

  /// Ticking past the room's last bed is refused with the notice the design
  /// prints rather than by silently dropping someone.
  Future<void> _toggle(int localId, bool isSelected) async {
    if (!isSelected) {
      setState(() => _selection.remove(localId));
      return;
    }
    if (_selection.length >= widget.capacity) {
      await showGroupRoomFullDialog(context);
      return;
    }
    setState(() => _selection.add(localId));
  }

  void _selectAll() {
    setState(() {
      _selection
        ..clear()
        ..addAll(
          widget.travelers
              .take(widget.capacity)
              .map((traveler) => traveler.localId),
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const GroupSheetHandle(),
            const Gap(14),
            GroupPickerHeader(type: widget.type, onSelectAll: _selectAll),
            Flexible(child: _list()),
            const Gap(8),
            CustomButton(
              label: 'confirm_selection'.tr(),
              height: 48,
              onPressed: () => Navigator.of(context).pop(_selection),
            ),
          ],
        ),
      ),
    );
  }

  Widget _list() {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: widget.travelers.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (_, index) {
        final traveler = widget.travelers[index];

        return GroupPickerRow(
          traveler: traveler,
          position: index + 1,
          price: widget.priceOf(_selection, traveler.localId),
          currency: widget.currency,
          isSecondInfant: widget.isSecondInfant(_selection, traveler.localId),
          isSelected: _selection.contains(traveler.localId),
          onChanged: (value) => _toggle(traveler.localId, value),
        );
      },
    );
  }
}
