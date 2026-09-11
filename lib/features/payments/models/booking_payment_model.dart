import 'package:skygate/core/utils/api_parse.dart';
import 'package:skygate/features/payments/models/payment_installment_model.dart';

class BookingPaymentModel {
  const BookingPaymentModel({
    required this.bookingId,
    this.total,
    this.paid,
    this.currency,
    this.installments = const [],
  });

  final int bookingId;
  final num? total;
  final num? paid;

  final String? currency;
  final List<PaymentInstallmentModel> installments;
  num get remaining {
    final outstanding = (total ?? 0) - (paid ?? 0);
    return outstanding < 0 ? 0 : outstanding;
  }

  double get paidRatio {
    final amount = total ?? 0;
    if (amount <= 0) return 0;
    return ((paid ?? 0) / amount).clamp(0, 1).toDouble();
  }

  int get paidPercent => (paidRatio * 100).round();
  PaymentInstallmentModel? get nextInstallment {
    for (final installment in installments) {
      if (!installment.status.isSettled) return installment;
    }
    return null;
  }

  bool get isSettled => remaining <= 0;

  String amountLabel(num? amount) =>
      amount == null ? '—' : '$amount${currency ?? ''}';
  factory BookingPaymentModel.fromJson(Map<String, dynamic> json) {
    return BookingPaymentModel(
      bookingId: ApiParse.intOf(json['id']) ?? 0,
      total: ApiParse.numOf(json['total_amount']),
      paid: ApiParse.numOf(json['paid_amount']),
      currency: ApiParse.stringOf(json['currency']),
      installments: [
        if (json['installments'] is List)
          for (final row in json['installments'] as List)
            if (row is Map<String, dynamic>)
              PaymentInstallmentModel.fromJson(row),
      ],
    );
  }
}
