import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:skygate/core/constants/payment_assets.dart';
import 'package:skygate/features/payments/models/financial_transaction_model.dart';
import 'package:skygate/features/payments/models/payment_currency.dart';
import 'package:skygate/features/payments/models/payment_method_model.dart';
import 'package:skygate/features/trips/models/booking_trip_model.dart';

void main() {
  test('every PaymentAssets path exists on disk', () {
    final missing = PaymentAssets.all
        .where((path) => !File(path).existsSync())
        .toList();
    expect(missing, isEmpty, reason: 'Missing asset files: $missing');
  });

  test('PaymentAssets.all has no duplicates', () {
    expect(PaymentAssets.all.toSet().length, PaymentAssets.all.length);
  });

  test('every currency and tab resolves its glyph', () {
    for (final path in [
      for (final currency in PaymentCurrency.values) currency.icon,
      for (final tab in TripsTab.values) tab.icon,
    ]) {
      expect(File(path).existsSync(), isTrue, reason: 'missing $path');
    }
  });

  test('a payment method falls back to a bundled logo', () {
    for (final name in ['شام كاش', 'Al Haram', 'شركة الهرم', 'anything else']) {
      final method = PaymentMethodModel.fromJson({'name': name});
      expect(File(method.logoFallback).existsSync(), isTrue);
    }
  });

  test('unknown values fall back instead of throwing', () {
    expect(PaymentCurrency.fromCode('EUR'), PaymentCurrency.usd);
    expect(PaymentCurrency.fromCode(null), PaymentCurrency.usd);
    expect(PaymentCurrency.fromCode('syp'), PaymentCurrency.syp);

    // The API types both status fields as arrays of undocumented strings, so
    // the readers have to cope with a bare string, a list and a blank.
    expect(TransactionStatus.fromApi(null), TransactionStatus.pending);
    expect(TransactionStatus.fromApi(['rejected']), TransactionStatus.rejected);
    expect(TransactionStatus.fromApi('مؤكدة'), TransactionStatus.confirmed);
    expect(BookingStatus.fromApi([]), BookingStatus.awaitingPayment);
    expect(BookingStatus.fromApi('completed'), BookingStatus.completed);
  });
}
