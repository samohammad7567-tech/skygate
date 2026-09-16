import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_sheet.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/components/sheet_handle.dart';
import 'package:skygate/core/models/group_room_type.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/group_booking/models/group_traveler_model.dart';
import 'package:skygate/features/group_booking/widgets/group_dialogs.dart';
import 'package:skygate/features/group_booking/widgets/group_picker_header.dart';
import 'package:skygate/features/group_booking/widgets/group_picker_row.dart';

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
  return showAppSheet<List<int>>(
    context,
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
        padding: EdgeInsets.fromLTRB(20.s, 12.s, 20.s, 16.s),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SheetHandle(),
            Gap(14.s),
            GroupPickerHeader(type: widget.type, onSelectAll: _selectAll),
            Flexible(child: _list()),
            Gap(8.s),
            CustomButton(
              label: 'confirm_selection'.tr(),
              height: 48.s,
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
      separatorBuilder: (_, _) => Divider(height: 1.s),
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
