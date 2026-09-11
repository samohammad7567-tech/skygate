import 'package:flutter/services.dart';

class AppPhone {
  AppPhone._();
  static const String defaultDialCode = '+963';
  static const int minDigits = 8;
  static const int maxDigits = 15;

  static final RegExp _e164 = RegExp('^\\+\\d{$minDigits,$maxDigits}\$');
  static final List<TextInputFormatter> formatters = [
    FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-() ٠-٩]')),
    LengthLimitingTextInputFormatter(maxDigits + 6),
  ];
  static String normalize(String? value) {
    if (value == null) return '';

    final buffer = StringBuffer();
    for (final rune in value.trim().runes) {
      // ٠ (U+0660) through ٩ (U+0669) map onto 0-9 in order.
      if (rune >= 0x0660 && rune <= 0x0669) {
        buffer.writeCharCode(rune - 0x0660 + 0x30);
      } else if ((rune >= 0x30 && rune <= 0x39) || rune == 0x2B) {
        buffer.writeCharCode(rune);
      }
    }

    var digits = buffer.toString();
    if (digits.startsWith('00')) digits = '+${digits.substring(2)}';

    // A `+` anywhere but the front is a typo, not a dial code.
    if (digits.startsWith('+')) {
      return '+${digits.substring(1).replaceAll('+', '')}';
    }
    return digits.replaceAll('+', '');
  }

  static bool isValid(String? value) => _e164.hasMatch(normalize(value));
  static bool isBlank(String? value) {
    final digits = normalize(value);
    return digits.isEmpty || digits == defaultDialCode;
  }
}
