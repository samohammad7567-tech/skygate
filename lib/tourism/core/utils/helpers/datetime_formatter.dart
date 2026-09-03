class DateTimeFormatter {

  DateTimeFormatter();

  // Like: 2 hours ago.
  static String formatHumanReadable(String isoDate) {
    final dateTime = DateTime.parse(isoDate);
    final now = DateTime.now();
    final difference = now.difference(dateTime);

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
    } else {
      return 'الآن';
    }
  }
}