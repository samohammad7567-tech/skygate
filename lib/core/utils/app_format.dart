import 'package:easy_localization/easy_localization.dart';

/// Date, time and ordinal formatting shared by the journey and booking flows.
///
/// Everything here is locale-aware: the screens pass
/// `context.locale.languageCode` so Arabic and English render their own
/// month and weekday names.
class AppFormat {
  AppFormat._();

  /// "08:00 ص" — the time printed above a stop.
  static String time(DateTime? value, String locale) =>
      value == null ? '—' : DateFormat.jm(locale).format(value);

  /// "السبت، 12 أكتوبر 2026" — the date line under a stop.
  static String fullDate(DateTime? value, String locale) =>
      value == null ? '' : DateFormat.yMMMMEEEEd(locale).format(value);

  /// "18 أغسطس 2026" — check-in / check-out rows.
  static String shortDate(DateTime? value, String locale) =>
      value == null ? '—' : DateFormat.yMMMMd(locale).format(value);

  /// "5 مارس" — the date under a day tab.
  static String dayMonth(DateTime? value, String locale) =>
      value == null ? '' : DateFormat.MMMd(locale).format(value);

  /// "2س 15د" — the trip length printed in orange.
  static String duration(int? minutes) {
    if (minutes == null) return '—';
    return 'duration_hours_minutes'.tr(
      namedArgs: {
        'hours': '${minutes ~/ 60}',
        'minutes': '${minutes % 60}'.padLeft(2, '0'),
      },
    );
  }

  /// "القسم الأول" / "المسار الثاني" — falls back to a plain number past the
  /// ten ordinals the translations carry.
  static String ordinalTitle(String titleKey, int position) {
    final ordinal = position >= 1 && position <= 10
        ? 'ordinal_$position'.tr()
        : '$position';
    return titleKey.tr(args: [ordinal]);
  }
}
