import 'package:easy_localization/easy_localization.dart';

class AppFormat {
  AppFormat._();
  static String time(DateTime? value, String locale) =>
      value == null ? '—' : DateFormat.jm(locale).format(value);
  static String fullDate(DateTime? value, String locale) =>
      value == null ? '' : DateFormat.yMMMMEEEEd(locale).format(value);
  static String shortDate(DateTime? value, String locale) =>
      value == null ? '—' : DateFormat.yMMMMd(locale).format(value);
  static String numericDate(DateTime? value) =>
      value == null ? '—' : _numeric.format(value);

  static final DateFormat _numeric = DateFormat('dd/MM/yyyy');
  static String isoDate(DateTime? value) =>
      value == null ? '—' : _iso.format(value);

  static final DateFormat _iso = DateFormat('yyyy/MM/dd');
  static String dayMonth(DateTime? value, String locale) =>
      value == null ? '' : DateFormat.MMMd(locale).format(value);
  static String duration(int? minutes) {
    if (minutes == null) return '—';
    return 'duration_hours_minutes'.tr(
      namedArgs: {
        'hours': '${minutes ~/ 60}',
        'minutes': '${minutes % 60}'.padLeft(2, '0'),
      },
    );
  }

  static String ordinalTitle(String titleKey, int position) {
    final ordinal = position >= 1 && position <= 10
        ? 'ordinal_$position'.tr()
        : '$position';
    return titleKey.tr(args: [ordinal]);
  }
}
