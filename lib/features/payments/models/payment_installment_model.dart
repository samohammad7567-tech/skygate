import 'package:flutter/material.dart';
import 'package:skygate/core/utils/api_parse.dart';

/// Where one row of "جدول المدفوعات" stands.
///
/// The rail on the left of the card is drawn from this: [paid] fills its dot
/// blue with a tick, [due] turns it orange, [upcoming] leaves it grey.
enum InstallmentStatus {
  paid('installment_paid'),
  due('installment_due'),
  upcoming('installment_due');

  const InstallmentStatus(this.labelKey);

  /// "تم الدفع" / "مستحقة". [upcoming] shares its copy with [due] — the design
  /// separates the two by colour alone.
  final String labelKey;

  bool get isSettled => this == paid;

  /// Tint of the rail dot and, on the one instalment actually due, of its date
  /// and standing.
  Color accent(ThemeData theme) => switch (this) {
    InstallmentStatus.paid => theme.colorScheme.primary,
    InstallmentStatus.due => theme.colorScheme.secondary,
    InstallmentStatus.upcoming => theme.colorScheme.outlineVariant,
  };
}

/// One instalment of a booking: what it costs, what share of the total it
/// settles, when it falls due and whether it has been paid.
class PaymentInstallmentModel {
  const PaymentInstallmentModel({
    this.number,
    this.amount,
    this.percentage,
    this.currency,
    this.dueAt,
    this.status = InstallmentStatus.upcoming,
  });

  /// 1-based place in the schedule, printed as "دفعة #1".
  final int? number;

  final num? amount;

  /// Share of the booking total this instalment settles.
  final int? percentage;

  final String? currency;

  final DateTime? dueAt;

  final InstallmentStatus status;

  /// The amount as the row prints it, e.g. `400$`.
  String get formattedAmount =>
      amount == null ? '—' : '$amount${currency ?? ''}';

  /// Reads a row of an instalment plan.
  ///
  /// No endpoint publishes one yet — `BookingResource` carries only a status,
  /// a total and `draft_expires_at` — so nothing calls this today. It is
  /// written against the field names the rest of the API uses so the schedule
  /// can be wired the moment the booking resource grows an `installments`
  /// array.
  factory PaymentInstallmentModel.fromJson(Map<String, dynamic> json) {
    return PaymentInstallmentModel(
      number: ApiParse.intOf(json['number'] ?? json['sequence_order']),
      amount: ApiParse.numOf(json['amount']),
      percentage: ApiParse.intOf(json['percentage']),
      currency: ApiParse.stringOf(json['currency']),
      dueAt: ApiParse.dateOf(json['due_at'] ?? json['due_date']),
      status: _statusOf(json),
    );
  }

  static InstallmentStatus _statusOf(Map<String, dynamic> json) {
    final label = ApiParse.labelOf(json['status'])?.toLowerCase() ?? '';
    if (json['paid_at'] != null ||
        label.contains('paid') ||
        label.contains('مدفوع')) {
      return InstallmentStatus.paid;
    }

    final dueAt = ApiParse.dateOf(json['due_at'] ?? json['due_date']);
    if (dueAt != null && dueAt.isAfter(DateTime.now())) {
      return InstallmentStatus.upcoming;
    }
    return InstallmentStatus.due;
  }
}
