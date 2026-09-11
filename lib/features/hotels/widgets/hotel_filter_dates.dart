import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/utils/app_format.dart';
import 'package:skygate/features/hotels/widgets/hotel_filter_row.dart';

class HotelFilterDates extends StatelessWidget {
  const HotelFilterDates({
    super.key,
    required this.from,
    required this.to,
    required this.onPickFrom,
    required this.onPickTo,
  });

  final DateTime? from;
  final DateTime? to;
  final VoidCallback onPickFrom;
  final VoidCallback onPickTo;

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: HotelFilterValue(
              label: 'date_from'.tr(),
              value: AppFormat.shortDate(from, locale),
              onTap: onPickFrom,
            ),
          ),
          const VerticalDivider(width: 24, thickness: 1),
          Expanded(
            child: HotelFilterValue(
              label: 'date_to'.tr(),
              value: AppFormat.shortDate(to, locale),
              onTap: onPickTo,
            ),
          ),
        ],
      ),
    );
  }
}
