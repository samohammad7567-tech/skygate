import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/models/booking_city.dart';

/// "مكة المكرمة" on the start side with "4 أيام" pushed to the end, printed
/// under the hotel step's heading.
class BookingStayRow extends StatelessWidget {
  const BookingStayRow({super.key, required this.city, this.days});

  final BookingCity city;

  /// Nights the package stays in [city]; the row hides when it is unknown.
  final int? days;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            city.labelKey.tr(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleLarge,
          ),
        ),
        if (days != null)
          Text(
            'days_count'.tr(namedArgs: {'count': '$days'}),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
      ],
    );
  }
}
