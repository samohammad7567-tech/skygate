import 'package:flutter/material.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/utils/api_parse.dart';

enum LuggageTagStatus {
  active('luggage_status_active'),
  inactive('luggage_status_inactive');

  const LuggageTagStatus(this.labelKey);

  final String labelKey;

  Color get foreground =>
      this == active ? AppColors.success : AppColors.textSecondary;
  Color get background =>
      this == active ? AppColors.successSurface : AppColors.fieldSurface;
  static LuggageTagStatus fromApi(dynamic value) {
    final label = ApiParse.labelOf(value)?.toLowerCase().trim() ?? '';
    if (label.isEmpty) return active;

    const disabled = ['inactive', 'disabled', 'void', 'معطل', 'ملغ'];
    return disabled.any(label.contains) ? inactive : active;
  }
}

class LuggageTagModel {
  int? id;
  int? bookingPilgrimId;
  String? tagNumber;
  String? qrUrl;
  String? fileUrl;

  LuggageTagStatus status = LuggageTagStatus.active;

  LuggageTagModel.fromJson(Map<String, dynamic> json) {
    id = ApiParse.intOf(json['id']);
    bookingPilgrimId = ApiParse.intOf(json['booking_pilgrim_id']);
    tagNumber = ApiParse.stringOf(json['tag_number']);
    qrUrl = ApiParse.stringOf(json['qr_url']);
    fileUrl = ApiParse.stringOf(json['file_url'] ?? json['pdf_url']);
    status = LuggageTagStatus.fromApi(json['status']);
  }
  String? get shortNumber {
    final digits = RegExp(r'\d+').allMatches(tagNumber ?? '');
    return digits.isEmpty ? tagNumber : digits.last[0];
  }
}
