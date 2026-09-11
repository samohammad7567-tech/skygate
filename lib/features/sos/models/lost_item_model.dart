import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/constants/api_endpoints.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/constants/sos_assets.dart';
import 'package:skygate/core/utils/api_parse.dart';

enum LostItemStatus {
  reported('lost_status_reported', AppColors.accent, AppColors.accentSurface),
  found('lost_status_found', AppColors.success, AppColors.successSurface),
  returned('lost_status_returned', AppColors.primary, AppColors.surfaceTint),
  closed('lost_status_closed', AppColors.textSecondary, AppColors.fieldSurface);

  const LostItemStatus(this.labelKey, this.foreground, this.background);

  final String labelKey;
  final Color foreground;
  final Color background;
  static LostItemStatus fromApi(dynamic value) {
    final label = ApiParse.labelOf(value)?.toLowerCase().trim() ?? '';
    if (label.isEmpty) return reported;

    bool has(List<String> words) => words.any(label.contains);

    if (has(['deliver', 'return', 'handed', 'سلم', 'تسليم'])) return returned;
    if (has(['found', 'recover', 'وجد', 'إيجاد', 'ايجاد'])) return found;
    if (has(['closed', 'cancel', 'أغلق', 'اغلق', 'ملغ'])) return closed;
    return reported;
  }
}

class LostItemModel {
  int? id;
  int? tripId;
  int? reportedByPilgrimId;
  String? handledBy;
  String? description;
  String? photoUrl;
  String? locationHint;

  DateTime? createdAt;

  LostItemStatus status = LostItemStatus.reported;

  LostItemModel.fromJson(Map<String, dynamic> json) {
    id = ApiParse.intOf(json['id']);
    tripId = ApiParse.intOf(json['trip_id']);
    reportedByPilgrimId = ApiParse.intOf(json['reported_by_pilgrim_id']);
    handledBy = ApiParse.stringOf(json['handled_by']);
    // `LostItemResource` names it `item_description`; the request example the
    // document publishes calls the same thing `item_name` with a longer
    // `description` beside it. Both are read so either backend spelling works.
    description = ApiParse.stringOf(
      json['item_description'] ?? json['item_name'] ?? json['description'],
    );
    photoUrl = ApiParse.stringOf(json['photo_url'] ?? json['photo']);
    locationHint = ApiParse.stringOf(json['location_hint'] ?? json['location']);
    createdAt = ApiParse.dateOf(json['created_at'] ?? json['lost_at']);
    status = LostItemStatus.fromApi(json['status']);
  }
  String? get photo => ApiEndpoints.mediaUrl(photoUrl);

  String get fallbackPhoto =>
      SosAssets.itemPhotoFallbacks[(id ?? 0).abs() %
          SosAssets.itemPhotoFallbacks.length];
  bool isMine(int? pilgrimId) =>
      pilgrimId != null && reportedByPilgrimId == pilgrimId;
  static Future<FormData> body({
    required String description,
    String? locationHint,
    DateTime? lostAt,
    String? notes,
    File? photo,
  }) async {
    final fields = <String, dynamic>{
      'item_name': description,
      'item_description': description,
      'description': notes ?? description,
      'location': locationHint,
      'location_hint': locationHint,
      'lost_at': lostAt?.toIso8601String(),
      'notes': notes,
    }..removeWhere((_, value) => value == null || value == '');

    if (photo != null) {
      fields['photo'] = await MultipartFile.fromFile(photo.path);
    }

    return FormData.fromMap(fields);
  }
}
