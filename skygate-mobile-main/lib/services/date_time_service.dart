/// Date and time formatting shared across screens.
///
/// The relative labels are Arabic, matching the app primary language.
class DateTimeService {
  DateTimeService._();

  static final DateTimeService instance = DateTimeService._();

  /// Arabic "time ago" label, e.g. `منذ 2 ساعة`.
  ///
  /// Returns an empty string when [isoDate] cannot be parsed.
  String humanReadable(String isoDate) {
    final dateTime = DateTime.tryParse(isoDate);
    if (dateTime == null) return '';
    return humanReadableFrom(dateTime);
  }

  /// Arabic "time ago" label for an already parsed [dateTime].
  String humanReadableFrom(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inDays > 365) {
      return ' منذ ${(difference.inDays / 365).floor()} سنة ';
    } else if (difference.inDays > 30) {
      return ' منذ ${(difference.inDays / 30).floor()} شهر ';
    } else if (difference.inDays > 0) {
      return ' منذ ${difference.inDays} يوم ';
    } else if (difference.inHours > 0) {
      return ' منذ ${difference.inHours} ساعة ';
    } else if (difference.inMinutes > 0) {
      return ' منذ ${difference.inMinutes} دقيقة ';
    }
    return 'الآن';
  }

  /// `yyyy-MM-dd`, the format the backend expects for date fields.
  String toApiDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  /// `HH:mm` in 24 hour form.
  String toApiTime(DateTime time) =>
      '${time.hour.toString().padLeft(2, '0')}:'
      '${time.minute.toString().padLeft(2, '0')}';

  /// `yyyy-MM-dd HH:mm`.
  String toApiDateTime(DateTime value) =>
      '${toApiDate(value)} ${toApiTime(value)}';

  /// Parses a backend date, returning `null` instead of throwing.
  DateTime? parse(String? value) =>
      value == null || value.isEmpty ? null : DateTime.tryParse(value);

  /// True when [date] falls within the next [months] months, the rule used to
  /// warn about a passport that is about to expire.
  bool isExpiringWithin(DateTime date, {int months = 6}) {
    final threshold = DateTime.now().add(Duration(days: 30 * months));
    return date.isBefore(threshold);
  }

  /// Whole days between today and [date]; negative once [date] has passed.
  int daysUntil(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    return target.difference(today).inDays;
  }

  bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
