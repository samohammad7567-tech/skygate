import 'package:flutter/material.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/utils/api_parse.dart';

enum VisaStatus {
  processing('visa_status_processing'),
  issued('visa_status_issued'),
  rejected('visa_status_rejected'),
  awaitingAmendment('visa_status_awaiting_amendment');

  const VisaStatus(this.labelKey);

  final String labelKey;

  Color get foreground => switch (this) {
    VisaStatus.processing => AppColors.primary,
    VisaStatus.issued => AppColors.success,
    VisaStatus.rejected => AppColors.error,
    VisaStatus.awaitingAmendment => AppColors.ritualText,
  };

  Color get background => switch (this) {
    VisaStatus.processing => AppColors.surfaceTint,
    VisaStatus.issued => AppColors.successSurface,
    VisaStatus.rejected => AppColors.errorSurface,
    VisaStatus.awaitingAmendment => AppColors.ritualSurface,
  };

  static VisaStatus fromApi(dynamic value) {
    final label = ApiParse.labelOf(value)?.toLowerCase().trim() ?? '';
    if (label.isEmpty) return processing;

    bool has(List<String> words) => words.any(label.contains);

    if (has(['reject', 'refus', 'declin', 'مرفوض'])) return rejected;
    if (has(['amend', 'needs_edit', 'correction', 'تعديل'])) {
      return awaitingAmendment;
    }
    if (has(['issued', 'approved', 'granted', 'صدر', 'مصدر'])) return issued;
    return processing;
  }
}

class VisaModel {
  int? id;
  int? bookingPilgrimId;

  String? number;
  String? type;
  DateTime? submittedAt;
  DateTime? expiresAt;
  String? fileUrl;

  VisaStatus status = VisaStatus.processing;

  VisaModel.fromJson(Map<String, dynamic> json) {
    id = ApiParse.intOf(json['id']);
    bookingPilgrimId = ApiParse.intOf(
      json['booking_pilgrim_id'] ?? json['pilgrim_id'],
    );
    number = ApiParse.stringOf(json['visa_number'] ?? json['number']);
    type = ApiParse.labelOf(json['visa_type'] ?? json['type']);
    submittedAt = ApiParse.dateOf(
      json['submitted_at'] ?? json['applied_at'] ?? json['created_at'],
    );
    expiresAt = ApiParse.dateOf(json['expires_at'] ?? json['expiry_date']);
    fileUrl = ApiParse.stringOf(json['file_url'] ?? json['pdf_url']);
    status = VisaStatus.fromApi(json['status']);
  }
}

class PilgrimTicketModel {
  int? id;
  int? bookingPilgrimId;
  int? segmentId;

  String? type;
  String? route;
  String? fileUrl;
  DateTime? issuedAt;

  PilgrimTicketModel.fromJson(Map<String, dynamic> json) {
    id = ApiParse.intOf(json['id']);
    bookingPilgrimId = ApiParse.intOf(
      json['booking_pilgrim_id'] ?? json['pilgrim_id'],
    );
    segmentId = ApiParse.intOf(json['trip_segment_id'] ?? json['segment_id']);
    type = ApiParse.labelOf(json['ticket_type'] ?? json['type']);
    route = ApiParse.stringOf(json['route'] ?? json['file_name']);
    fileUrl = ApiParse.stringOf(json['file_url'] ?? json['pdf_url']);
    issuedAt = ApiParse.dateOf(json['issued_at'] ?? json['created_at']);
  }
}
