import 'package:flutter/material.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/utils/api_parse.dart';

enum BookingChangeStatus {
  pending('booking_change_status_pending'),
  approved('booking_change_status_approved'),
  done('booking_change_status_done'),
  rejected('booking_change_status_rejected');

  const BookingChangeStatus(this.labelKey);

  final String labelKey;

  Color get foreground => switch (this) {
    BookingChangeStatus.pending => AppColors.ritualText,
    BookingChangeStatus.approved => AppColors.primary,
    BookingChangeStatus.done => AppColors.success,
    BookingChangeStatus.rejected => AppColors.error,
  };

  Color get background => switch (this) {
    BookingChangeStatus.pending => AppColors.ritualSurface,
    BookingChangeStatus.approved => AppColors.surfaceTint,
    BookingChangeStatus.done => AppColors.successSurface,
    BookingChangeStatus.rejected => AppColors.errorSurface,
  };

  static BookingChangeStatus of(dynamic value) {
    final label = ApiParse.labelOf(value)?.toLowerCase().trim() ?? '';
    if (label.isEmpty) return pending;

    bool has(List<String> words) => words.any(label.contains);

    if (has(['reject', 'refus', 'declin', 'cancel', 'مرفوض', 'ملغ'])) {
      return rejected;
    }
    if (has(['done', 'complet', 'applied', 'executed', 'منفذ', 'تم تنفيذ'])) {
      return done;
    }
    if (has(['approv', 'accept', 'confirm', 'موافق', 'مقبول'])) return approved;
    return pending;
  }
}

enum BookingChangeType {
  modifyDate('modify_date', 'booking_change_type_modify_date'),
  addPilgrims('add_pilgrims', 'booking_change_type_add_pilgrims'),
  changeRoom('change_room', 'booking_change_type_change_room'),
  partialCancel('partial_cancel', 'booking_change_type_partial_cancel'),
  fullCancel('full_cancel', 'booking_change_type_full_cancel'),
  other('', 'booking_change_type_other');

  const BookingChangeType(this.code, this.labelKey);

  final String code;
  final String labelKey;

  static BookingChangeType of(dynamic value) {
    final code = ApiParse.labelOf(value)?.toLowerCase().trim() ?? '';
    if (code.isEmpty) return other;

    for (final type in values) {
      if (type.code.isNotEmpty && code == type.code) return type;
    }
    return other;
  }
}

class BookingChangeRequestModel {
  int? id;
  int? bookingId;

  BookingChangeType type = BookingChangeType.other;
  String? typeLabel;

  BookingChangeStatus status = BookingChangeStatus.pending;
  List<String> details = const [];
  List<String> adminNotes = const [];

  DateTime? reviewedAt;
  DateTime? createdAt;
  String? tripTitle;
  String? bookingReference;

  BookingChangeRequestModel.fromJson(Map<String, dynamic> json) {
    id = ApiParse.intOf(json['id']);
    bookingId = ApiParse.intOf(json['booking_id']);
    type = BookingChangeType.of(json['request_type']);
    typeLabel = ApiParse.labelOf(json['request_type']);
    status = BookingChangeStatus.of(json['status']);
    details = ApiParse.linesOf(json['details']);
    adminNotes = ApiParse.linesOf(json['admin_notes']);
    reviewedAt = ApiParse.dateOf(json['reviewed_at']);
    createdAt = ApiParse.dateOf(json['created_at']);

    final booking = json['booking'];
    final bookingJson = booking is Map ? booking : const {};
    final trip = bookingJson['trip'];
    final tripJson = trip is Map ? trip : const {};

    tripTitle = ApiParse.stringOf(
      tripJson['campaign_name'] ??
          bookingJson['campaign_name'] ??
          json['trip_name'],
    );
    bookingReference = ApiParse.stringOf(
      bookingJson['booking_number'] ??
          tripJson['trip_number'] ??
          json['booking_number'],
    );
  }
  String get reference => bookingReference ?? '${bookingId ?? id ?? '—'}';

  bool get isKnownType => type != BookingChangeType.other;

  String? get detailsText => details.isEmpty ? null : details.join('\n');
  String? get adminNotesText =>
      adminNotes.isEmpty ? null : adminNotes.join('\n');
}
