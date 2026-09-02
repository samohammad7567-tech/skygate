import 'package:flutter/services.dart';

/// Turns whatever was typed into a phone field into the one shape the API
/// takes, without ever guessing which country a number belongs to.
///
/// `auth/login` and `auth/register` both document `mobile` as `+966512398765`
/// — E.164, dial code and all — so that is what goes on the wire. The fields
/// open pre-filled with [defaultDialCode] so the common case is no extra
/// typing, and anyone outside Syria edits the prefix.
///
/// Guessing was deliberately left out. A Saudi pilgrim typing their local
/// `0512398765` would have been rewritten to a perfectly well-formed *Syrian*
/// number that no validator could flag, and the sign-in would fail with
/// nothing on screen explaining why. Requiring the `+` makes that impossible.
class AppPhone {
  AppPhone._();

  /// What a fresh phone field starts with. Sky Gate sells out of Syria, so the
  /// Syrian dial code is the one that saves the most typing.
  static const String defaultDialCode = '+963';

  /// Digits after the `+`, ignoring the dial code. Eight is the shortest
  /// national number in use; fifteen is the E.164 ceiling.
  static const int minDigits = 8;
  static const int maxDigits = 15;

  static final RegExp _e164 = RegExp('^\\+\\d{$minDigits,$maxDigits}\$');

  /// Everything a phone field accepts: digits, a `+`, and the separators
  /// people paste in. [normalize] strips the separators again on the way out.
  static final List<TextInputFormatter> formatters = [
    FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-() ٠-٩]')),
    LengthLimitingTextInputFormatter(maxDigits + 6),
  ];

  /// The E.164 form of [value], or the closest thing to it the input allows.
  ///
  /// Cleans only — it never adds a dial code that was not typed:
  ///
  /// * Arabic-Indic digits (`٠٩١٢…`) become ASCII, so an Arabic keyboard works
  /// * spaces, dashes and brackets are dropped
  /// * a leading `00` becomes `+`, the same number written the other way
  /// * a `+` already there is left alone
  ///
  /// A bare national number (`0912345678`) comes back cleaned but still
  /// without a `+`, which is what makes [isValid] reject it.
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

  /// Whether [value] normalizes to a number the API will accept.
  static bool isValid(String? value) => _e164.hasMatch(normalize(value));

  /// `true` while the field holds nothing but its dial code, so a screen can
  /// tell "untouched" from "half typed".
  static bool isBlank(String? value) {
    final digits = normalize(value);
    return digits.isEmpty || digits == defaultDialCode;
  }
}
