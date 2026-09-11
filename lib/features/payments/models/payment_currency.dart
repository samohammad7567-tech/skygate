import 'package:skygate/core/constants/payment_assets.dart';

enum PaymentCurrency {
  usd('USD', 'currency_usd', PaymentAssets.dollar),
  syp('SYP', 'currency_syp', PaymentAssets.syrianPound);

  const PaymentCurrency(this.code, this.labelKey, this.icon);
  final String code;
  final String labelKey;
  final String icon;

  static PaymentCurrency fromCode(String? code) {
    final value = code?.trim().toUpperCase();
    return values.firstWhere(
      (currency) => currency.code == value,
      orElse: () => PaymentCurrency.usd,
    );
  }
}
