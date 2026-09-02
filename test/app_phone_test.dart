import 'package:flutter_test/flutter_test.dart';
import 'package:skygate/core/utils/app_phone.dart';

/// The shapes a pilgrim actually types into a phone field, and what reaches
/// `auth/login` for each one.
void main() {
  test('an international number survives untouched', () {
    // The OpenAPI examples for auth/login and auth/register are both E.164.
    expect(AppPhone.normalize('+966512398765'), '+966512398765');
    expect(AppPhone.normalize('+963912345678'), '+963912345678');
    expect(AppPhone.isValid('+966512398765'), isTrue);
  });

  test('separators are stripped so the same number is never two strings', () {
    for (final typed in [
      '+963 912 345 678',
      '+963-912-345-678',
      '  +963 (912) 345-678  ',
    ]) {
      expect(AppPhone.normalize(typed), '+963912345678', reason: typed);
    }
  });

  test('a leading 00 is the same number written the other way', () {
    expect(AppPhone.normalize('00963912345678'), '+963912345678');
    expect(AppPhone.normalize('00966512398765'), '+966512398765');
  });

  test('Arabic-Indic digits are accepted', () {
    expect(AppPhone.normalize('+٩٦٣٩١٢٣٤٥٦٧٨'), '+963912345678');
    expect(AppPhone.isValid('+٩٦٣٩١٢٣٤٥٦٧٨'), isTrue);
  });

  test('a national number is rejected rather than given a country', () {
    // The whole point of the pre-filled dial code: a Saudi pilgrim typing
    // their local 0512398765 must not be silently sent as a Syrian number.
    expect(AppPhone.normalize('0512398765'), '0512398765');
    expect(AppPhone.isValid('0512398765'), isFalse);
    expect(AppPhone.isValid('0912345678'), isFalse);
    expect(
      AppPhone.normalize('0512398765').startsWith(AppPhone.defaultDialCode),
      isFalse,
    );
  });

  test('a stray + inside the number does not make it valid', () {
    expect(AppPhone.normalize('+963+912345678'), '+963912345678');
    expect(AppPhone.normalize('963+912345678'), '963912345678');
    expect(AppPhone.isValid('963+912345678'), isFalse);
  });

  test('too short and too long are both rejected', () {
    expect(AppPhone.isValid('+9639'), isFalse);
    expect(AppPhone.isValid('+${'9' * AppPhone.maxDigits}'), isTrue);
    expect(AppPhone.isValid('+${'9' * (AppPhone.maxDigits + 1)}'), isFalse);
  });

  test('the untouched dial code counts as empty, not as invalid', () {
    expect(AppPhone.isBlank(AppPhone.defaultDialCode), isTrue);
    expect(AppPhone.isBlank(''), isTrue);
    expect(AppPhone.isBlank(null), isTrue);
    expect(AppPhone.isBlank('+963912345678'), isFalse);
  });

  test('normalizing is idempotent', () {
    for (final typed in ['+963 912 345 678', '00963912345678', '0912345678']) {
      final once = AppPhone.normalize(typed);
      expect(AppPhone.normalize(once), once, reason: typed);
    }
  });
}
