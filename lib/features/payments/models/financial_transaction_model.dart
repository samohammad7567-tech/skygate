import 'package:flutter/material.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/utils/api_parse.dart';

/// Where a transfer stands once it has been sent for review.
///
/// The API types `status` as an array of strings and never publishes the set
/// of values, so the slugs below are matched leniently and anything
/// unrecognised is treated as still under review — the state that shows the
/// payer no figure they could act on wrongly.
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

/// `FinancialTransactionResource` — one row of "المعاملات المالية".
class FinancialTransactionModel {
  int? id;
  num? amount;
  String? currency;
  TransactionStatus status = TransactionStatus.pending;

  /// The receipt the payer uploaded, for the row that wants to show it back.
  String? receiptPhotoUrl;

  String? referenceNumber;

  /// When the transfer was submitted — the date and time the card prints.
  DateTime? createdAt;

  /// Who made the transfer, printed in blue above the amount.
  ///
  /// `FinancialTransactionResource` publishes no payer, so this stays null and
  /// the card falls back to the reference number. Fill it in when the resource
  /// gains a `payer` / `pilgrim` field.
  String? payerName;

  /// "سبب الرفض : …" — the red-tinted note under a rejected transfer.
  ///
  /// Not published either; the resource carries a status but no reason, so a
  /// rejected transfer currently shows the chip alone.
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

  /// The amount as the card prints it, e.g. `500$`.
  String get formattedAmount =>
      amount == null ? '—' : '$amount${currency ?? ''}';
}
