import 'package:flutter/material.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/utils/api_parse.dart';

enum TransactionStatus {
  pending('pending', 'transaction_pending'),
  confirmed('confirmed', 'transaction_confirmed'),
  rejected('rejected', 'transaction_rejected');

  const TransactionStatus(this.slug, this.labelKey);

  final String slug;
  final String labelKey;

  Color get foreground => switch (this) {
    TransactionStatus.pending => AppColors.primary,
    TransactionStatus.confirmed => AppColors.success,
    TransactionStatus.rejected => AppColors.error,
  };

  Color get background => switch (this) {
    TransactionStatus.pending => AppColors.surfaceTint,
    TransactionStatus.confirmed => AppColors.successSurface,
    TransactionStatus.rejected => AppColors.error.withValues(alpha: 0.10),
  };

  static TransactionStatus fromApi(dynamic value) {
    final label = ApiParse.labelOf(value)?.toLowerCase().trim() ?? '';
    if (label.isEmpty) return pending;

    bool has(List<String> words) => words.any(label.contains);

    if (has(['reject', 'refus', 'declin', 'cancel', 'مرفوض', 'ملغ'])) {
      return rejected;
    }
    if (has([
      'confirm',
      'approv',
      'accept',
      'paid',
      'مؤكد',
      'مقبول',
      'مدفوع',
    ])) {
      return confirmed;
    }
    return pending;
  }
}

class FinancialTransactionModel {
  int? id;
  num? amount;
  String? currency;
  TransactionStatus status = TransactionStatus.pending;
  String? receiptPhotoUrl;

  String? referenceNumber;
  DateTime? createdAt;
  String? payerName;
  String? rejectionReason;

  FinancialTransactionModel.fromJson(Map<String, dynamic> json) {
    id = ApiParse.intOf(json['id']);
    amount = ApiParse.numOf(json['amount']);
    currency = ApiParse.stringOf(json['currency']);
    status = TransactionStatus.fromApi(json['status']);
    receiptPhotoUrl = ApiParse.stringOf(json['receipt_photo_url']);
    referenceNumber = ApiParse.stringOf(json['reference_number']);
    createdAt = ApiParse.dateOf(json['created_at']);
    payerName = ApiParse.stringOf(json['payer_name'] ?? json['payer']);
    rejectionReason = ApiParse.stringOf(
      json['rejection_reason'] ?? json['rejection_note'],
    );
  }
  String get formattedAmount =>
      amount == null ? '—' : '$amount${currency ?? ''}';
}
