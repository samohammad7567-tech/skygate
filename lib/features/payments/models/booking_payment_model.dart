import 'package:skygate/core/utils/api_parse.dart';
import 'package:skygate/features/payments/models/payment_installment_model.dart';

/// "ملخص المدفوعات" — what a booking costs, what has been settled against it,
/// and the schedule the rest falls due on.
///
/// Only [total] comes down the wire: `BookingResource` publishes `id`,
/// `status`, `total_amount` and `draft_expires_at` and nothing else, so
/// [paid] and [installments] stay at their empty defaults until the resource
/// grows a `paid_amount` and an `installments` array. The screen is written to
/// read correctly in that state — the ring sits at 0%, "المدفوع" reads `0` and
/// the schedule card hides itself rather than inventing rows.
class BookingPaymentModel {
  const BookingPaymentModel({
    required this.bookingId,
    this.total,
    this.paid,
    this.currency,
    this.installments = const [],
  });

  final int bookingId;

  /// "إجمالي المبلغ".
  final num? total;

  /// "المدفوع" — the confirmed transfers added up.
  final num? paid;

  final String? currency;

  /// Rows of "جدول المدفوعات", in the order they fall due.
  final List<PaymentInstallmentModel> installments;

  /// "المتبقي". Never negative — an overpayment reads as nothing left to pay.
  num get remaining {
    final outstanding = (total ?? 0) - (paid ?? 0);
    return outstanding < 0 ? 0 : outstanding;
  }

  /// Share of the total already settled, as the ring fills it. Clamped so a
  /// missing or zero total cannot divide by zero or overshoot the circle.
  double get paidRatio {
    final amount = total ?? 0;
    if (amount <= 0) return 0;
    return ((paid ?? 0) / amount).clamp(0, 1).toDouble();
  }

  /// The whole percent printed inside the ring.
  int get paidPercent => (paidRatio * 100).round();

  /// The instalment "ادفع الآن" settles — the first one still outstanding.
  PaymentInstallmentModel? get nextInstallment {
    for (final installment in installments) {
      if (!installment.status.isSettled) return installment;
    }
    return null;
  }

  bool get isSettled => remaining <= 0;

  String amountLabel(num? amount) =>
      amount == null ? '—' : '$amount${currency ?? ''}';

  /// Reads what `GET app/bookings/{id}` does publish, leaving the rest at its
  /// defaults. [installments] is parsed opportunistically so the schedule
  /// lights up on its own the day the backend starts sending one.
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
