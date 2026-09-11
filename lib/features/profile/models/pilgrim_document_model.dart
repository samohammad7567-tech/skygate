import 'package:skygate/core/constants/api_endpoints.dart';
import 'package:skygate/core/utils/api_parse.dart';

enum DocumentReviewStatus {
  approved,
  pending,
  rejected;

  static DocumentReviewStatus of(String? value) =>
      switch (value?.toLowerCase().trim()) {
        'approved' ||
        'accepted' ||
        'verified' ||
        'valid' => DocumentReviewStatus.approved,
        'rejected' ||
        'refused' ||
        'invalid' ||
        'needs_update' ||
        'needs_edit' => DocumentReviewStatus.rejected,
        _ => DocumentReviewStatus.pending,
      };
  String get labelKey => switch (this) {
    DocumentReviewStatus.approved => 'doc_status_approved',
    DocumentReviewStatus.pending => 'doc_status_pending',
    DocumentReviewStatus.rejected => 'doc_status_rejected',
  };
}

class PilgrimDocumentModel {
  int? id;
  int? pilgrimId;
  int? documentTypeId;
  String? file;

  String? rejectionReason;
  DateTime? createdAt;
  String? status;

  PilgrimDocumentModel.fromJson(Map<String, dynamic> json) {
    id = ApiParse.intOf(json['id']);
    pilgrimId = ApiParse.intOf(json['pilgrim_id']);
    documentTypeId = ApiParse.intOf(json['document_type_id']);
    file = ApiParse.stringOf(json['file_url'] ?? json['file']);
    rejectionReason = ApiParse.stringOf(json['rejection_reason']);
    createdAt = ApiParse.dateOf(json['created_at']);
    status = ApiParse.labelOf(json['status']);
  }
  DocumentReviewStatus get review => DocumentReviewStatus.of(status);
  String? get fileUrl => ApiEndpoints.mediaUrl(file);
  bool get hasFile => fileUrl != null;
}
