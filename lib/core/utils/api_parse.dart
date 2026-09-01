/// Lenient readers for the loosely typed JSON the API answers with.
///
/// The OpenAPI document types most numbers as strings (`"price_adult": "1500.00"`,
/// `"rating": "5"`) and every enum-like field as an array, so parsing them with
/// a plain cast throws on perfectly valid payloads. Every model reads its
/// fields through here instead, so the leniency is written once.
class ApiParse {
  ApiParse._();

  static int? intOf(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse('$value');
  }

  static num? numOf(dynamic value) {
    if (value is num) return value;
    if (value == null) return null;
    return num.tryParse('$value');
  }

  /// Trimmed text, or `null` when the field is missing or blank — which is
  /// what the UI's `?? '—'` fallbacks expect.
  static String? stringOf(dynamic value) {
    if (value == null) return null;
    final text = '$value'.trim();
    return text.isEmpty ? null : text;
  }

  /// Accepts both `2026-03-05T08:00:00Z` and Laravel's `2026-03-05 08:00:00`.
  /// Time-only values (`08:00`) carry no date and come back `null`.
  static DateTime? dateOf(dynamic value) {
    final text = stringOf(value);
    if (text == null) return null;
    return DateTime.tryParse(text.replaceFirst(' ', 'T'));
  }

  /// `08:00` — the clock part of a time or date-time field, as the activity
  /// and itinerary cards print it.
  static String? timeOf(dynamic value) {
    final text = stringOf(value);
    if (text == null) return null;

    final parsed = dateOf(text);
    if (parsed != null) {
      return '${_two(parsed.hour)}:${_two(parsed.minute)}';
    }

    final parts = text.split(':');
    if (parts.length < 2) return text;
    return '${_two(int.tryParse(parts[0]) ?? 0)}:${parts[1].padLeft(2, '0')}';
  }

  /// Reads a status-style field, which the document types as an array of
  /// strings but which really arrives as a plain string, a one-item list or an
  /// enum object.
  static String? labelOf(dynamic value) {
    if (value is List) {
      return value.isEmpty ? null : labelOf(value.first);
    }
    if (value is Map) {
      return stringOf(value['label'] ?? value['name'] ?? value['value']);
    }
    return stringOf(value);
  }

  /// Every line of a field the document types as an array of strings, with the
  /// blanks dropped.
  static List<String> stringsOf(dynamic value) {
    if (value is List) {
      return [for (final item in value) ?stringOf(item)];
    }
    final single = stringOf(value);
    return single == null ? const [] : [single];
  }

  /// Whole days between two dates, inclusive of both ends — "٧ أيام" on a trip
  /// that starts on the 1st and ends on the 7th.
  static int? daysBetween(DateTime? from, DateTime? to) {
    if (from == null || to == null) return null;
    final days = to.difference(from).inDays + 1;
    return days < 1 ? null : days;
  }

  /// Nights between a check-in and a check-out.
  static int? nightsBetween(DateTime? from, DateTime? to) {
    if (from == null || to == null) return null;
    final nights = to.difference(from).inDays;
    return nights < 0 ? null : nights;
  }

  static String _two(int value) => '$value'.padLeft(2, '0');
}
