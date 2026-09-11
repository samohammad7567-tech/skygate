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

  static bool boolOf(dynamic value, {bool orElse = true}) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    final text = stringOf(value)?.toLowerCase();
    if (text == null) return orElse;
    if (text == 'true' || text == '1') return true;
    if (text == 'false' || text == '0') return false;
    return orElse;
  }

  static String? stringOf(dynamic value) {
    if (value == null) return null;
    final text = '$value'.trim();
    return text.isEmpty ? null : text;
  }

  static DateTime? dateOf(dynamic value) {
    final text = stringOf(value);
    if (text == null) return null;
    return DateTime.tryParse(text.replaceFirst(' ', 'T'));
  }

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

  static String? labelOf(dynamic value) {
    if (value is List) {
      return value.isEmpty ? null : labelOf(value.first);
    }
    if (value is Map) {
      return stringOf(value['label'] ?? value['name'] ?? value['value']);
    }
    return stringOf(value);
  }

  static List<String> stringsOf(dynamic value) {
    if (value is List) {
      return [for (final item in value) ?stringOf(item)];
    }
    final single = stringOf(value);
    return single == null ? const [] : [single];
  }

  static List<String> linesOf(dynamic value) {
    if (value is List) {
      return [for (final item in value) ...linesOf(item)];
    }
    final text = stringOf(value);
    if (text == null) return const [];
    return [for (final line in text.split(RegExp(r'\r?\n'))) ?stringOf(line)];
  }

  static List<T> listOf<T>(
    dynamic value,
    T Function(Map<String, dynamic>) fromJson,
  ) => [
    if (value is List)
      for (final item in value)
        if (item is Map<String, dynamic>) fromJson(item),
  ];
  static List<T> rowsOf<T>(
    dynamic value,
    T Function(Map<String, dynamic>) fromJson,
  ) => listOf(value is Map ? value['items'] : value, fromJson);
  static int? daysBetween(DateTime? from, DateTime? to) {
    if (from == null || to == null) return null;
    final days = to.difference(from).inDays + 1;
    return days < 1 ? null : days;
  }

  static int? nightsBetween(DateTime? from, DateTime? to) {
    if (from == null || to == null) return null;
    final nights = to.difference(from).inDays;
    return nights < 0 ? null : nights;
  }

  static String _two(int value) => '$value'.padLeft(2, '0');
}
