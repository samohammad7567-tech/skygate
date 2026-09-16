import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/components/sheet_handle.dart';
import 'package:skygate/core/constants/journey_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/hotels/models/hotel_filter.dart';
import 'package:skygate/features/hotels/widgets/hotel_filter_dates.dart';
import 'package:skygate/features/hotels/widgets/hotel_filter_row.dart';
import 'package:skygate/features/hotels/widgets/hotel_rating_slider.dart';
import 'package:skygate/features/hotels/widgets/hotel_room_type_options.dart';

class HotelFilterSheet extends StatefulWidget {
  const HotelFilterSheet({super.key, required this.filter});

  final HotelFilter filter;

  static Future<HotelFilter?> show(
    BuildContext context, {
    required HotelFilter filter,
  }) => showModalBottomSheet<HotelFilter>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.s)),
    ),
    builder: (_) => HotelFilterSheet(filter: filter),
  );

  @override
  State<HotelFilterSheet> createState() => _HotelFilterSheetState();
}

class _HotelFilterSheetState extends State<HotelFilterSheet> {
  late HotelFilter _filter = widget.filter;
  bool _pickingRoom = false;

  Future<void> _pickDate({required bool isFrom}) async {
    final now = DateTime.now();
    final initial = (isFrom ? _filter.from : _filter.to) ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
      helpText: 'select_date'.tr(),
    );
    if (picked == null) return;
    setState(() {
      _filter = isFrom
          ? _filter.copyWith(from: picked)
          : _filter.copyWith(to: picked);
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
            SizedBox(height: 12.s),
            HotelFilterRow(
              asset: JourneyAssets.bed,
              child: HotelFilterValue(
                label: 'room_type'.tr(),
                value: _filter.roomType?.labelKey.tr() ?? 'any_room_type'.tr(),
                onTap: () => setState(() => _pickingRoom = !_pickingRoom),
              ),
            ),
            if (_pickingRoom)
              HotelRoomTypeOptions(
                selected: _filter.roomType,
                onSelected: (type) => setState(() {
                  _filter = _filter.copyWith(roomType: type);
                  _pickingRoom = false;
                }),
              )
            else
              ..._collapsed(),
          ],
        ),
      ),
    );
  }

  List<Widget> _collapsed() => [
    Divider(height: 1.s),
    HotelFilterRow(
      asset: JourneyAssets.calendar,
      child: HotelFilterDates(
        from: _filter.from,
        to: _filter.to,
        onPickFrom: () => _pickDate(isFrom: true),
        onPickTo: () => _pickDate(isFrom: false),
      ),
    ),
    SizedBox(height: 4.s),
    HotelRatingSlider(
      value: _filter.minRating,
      onChanged: (value) =>
          setState(() => _filter = _filter.copyWith(minRating: value)),
    ),
    SizedBox(height: 16.s),
    CustomButton(
      label: 'search'.tr(),
      onPressed: () => Navigator.of(context).pop(_filter),
    ),
  ];
}
