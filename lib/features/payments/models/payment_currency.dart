import 'package:skygate/core/constants/payment_assets.dart';

/// "نوع المبلغ المحول" — the currency a transfer was actually made in.
///
/// This is the currency the *payer* used, not the one the booking is priced
/// in, which is why the sheet asks for it separately from the amount: a
/// booking quoted in dollars is often settled in Syrian pounds at the office's
/// rate. It travels to `POST app/financial-transactions` as `currency`.
enum PaymentCurrency {
  usd('USD', 'currency_usd', PaymentAssets.dollar),
  syp('SYP', 'currency_syp', PaymentAssets.syrianPound);

  const PaymentCurrency(this.code, this.labelKey, this.icon);

  /// Value sent to the API, and the code printed under the name.
  final String code;

  /// "دولار" / "ليرة سورية".
  final String labelKey;

  /// Glyph on the option's tinted plate.
  final String icon;

  static PaymentCurrency fromCode(String? code) {
    final value = code?.trim().toUpperCase();
    return values.firstWhere(
      (currency) => currency.code == value,
      orElse: () => PaymentCurrency.usd,
    );
  }
}
