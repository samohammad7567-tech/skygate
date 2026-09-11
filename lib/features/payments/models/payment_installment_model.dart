import 'package:flutter/material.dart';
import 'package:skygate/core/utils/api_parse.dart';

enum InstallmentStatus {
  paid('installment_paid'),
  due('installment_due'),
  upcoming('installment_due');

  const InstallmentStatus(this.labelKey);
  final String labelKey;

  bool get isSettled => this == paid;
  Color accent(ThemeData theme) => switch (this) {
    InstallmentStatus.paid => theme.colorScheme.primary,
    InstallmentStatus.due => theme.colorScheme.secondary,
    InstallmentStatus.upcoming => theme.colorScheme.outlineVariant,
  };
}

class PaymentInstallmentModel {
  const PaymentInstallmentModel({
    this.number,
    this.amount,
    this.percentage,
    this.currency,
    this.dueAt,
    this.status = InstallmentStatus.upcoming,
  });
  final int? number;

  final num? amount;
  final int? percentage;

  final String? currency;

  final DateTime? dueAt;

  final InstallmentStatus status;
  String get formattedAmount =>
      amount == null ? '—' : '$amount${currency ?? ''}';
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
