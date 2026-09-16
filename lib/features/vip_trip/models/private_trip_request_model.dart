import 'package:flutter/material.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/models/group_room_type.dart';
import 'package:skygate/core/utils/api_parse.dart';

enum PrivateTripStatus {
  pending('vip_status_pending'),
  quoted('vip_status_quoted'),
  approved('vip_status_approved'),
  cancelled('vip_status_cancelled');

  const PrivateTripStatus(this.labelKey);

  final String labelKey;

  Color get foreground => switch (this) {
    PrivateTripStatus.pending => _pendingText,
    PrivateTripStatus.quoted => _quotedText,
    PrivateTripStatus.approved => AppColors.success,
    PrivateTripStatus.cancelled => AppColors.error,
  };

  Color get background => switch (this) {
    PrivateTripStatus.pending => _pendingSurface,
    PrivateTripStatus.quoted => _quotedSurface,
    PrivateTripStatus.approved => _approvedSurface,
    PrivateTripStatus.cancelled => _cancelledSurface,
  };
  bool get canCancel =>
      this == PrivateTripStatus.pending || this == PrivateTripStatus.quoted;

  static PrivateTripStatus of(dynamic value) {
    final label = ApiParse.labelOf(value)?.toLowerCase().trim() ?? '';
    if (label.isEmpty) return pending;

    bool has(List<String> words) => words.any(label.contains);

    if (has(['cancel', 'reject', 'refus', 'ملغ', 'مرفوض'])) return cancelled;
    if (has(['approv', 'accept', 'confirm', 'موافق', 'مقبول'])) return approved;
    if (has(['quot', 'priced', 'pricing', 'تسعير', 'مسعر'])) return quoted;
    return pending;
  }
}

class PrivateTripRequestModel {
  int? id;
  int? userId;

  int? peopleCount;
  int? adultCount;
  int? childCount;
  int? infantCount;

  DateTime? startDate;
  DateTime? endDate;

  List<int> hotelIds = const [];
  List<int> roomTypeIds = const [];
  List<String> requirements = const [];
  List<String> quoteDetails = const [];

  PrivateTripStatus status = PrivateTripStatus.pending;
  int? convertedTripId;

  DateTime? createdAt;
  int? makkahNights;
  int? madinahNights;
  Map<GroupRoomType, int> roomCounts = const {};
  String? makkahHotel;
  String? madinahHotel;

  PrivateTripRequestModel.fromJson(Map<String, dynamic> json) {
    id = ApiParse.intOf(json['id']);
    userId = ApiParse.intOf(json['user_id']);
    peopleCount = ApiParse.intOf(json['people_count']);
    adultCount = ApiParse.intOf(json['adult_count']);
    childCount = ApiParse.intOf(json['child_count']);
    infantCount = ApiParse.intOf(json['infant_count']);
    startDate = ApiParse.dateOf(json['preferred_start_date']);
    endDate = ApiParse.dateOf(json['preferred_end_date']);
    hotelIds = _ids(json['hotel_ids']);
    roomTypeIds = _ids(json['room_type_ids']);
    requirements = ApiParse.linesOf(json['requirements']);
    quoteDetails = ApiParse.linesOf(json['quote_details']);
    status = PrivateTripStatus.of(json['status']);
    convertedTripId = ApiParse.intOf(json['converted_trip_id']);
    createdAt = ApiParse.dateOf(json['created_at']);

    makkahNights = ApiParse.intOf(json['makkah_nights']);
    madinahNights = ApiParse.intOf(json['madinah_nights']);
    roomCounts = _rooms(json['rooms']);
    makkahHotel = ApiParse.stringOf(json['makkah_hotel']);
    madinahHotel = ApiParse.stringOf(json['madinah_hotel']);
  }
  String get reference => '${id ?? '—'}';
  int get travelers =>
      peopleCount ?? (adultCount ?? 0) + (childCount ?? 0) + (infantCount ?? 0);
  String? get requirementsText =>
      requirements.isEmpty ? null : requirements.join('\n');
  int? get days => ApiParse.daysBetween(startDate, endDate);

  static List<int> _ids(dynamic value) => [
    for (final item in ApiParse.stringsOf(value)) ?ApiParse.intOf(item),
  ];
  static Map<GroupRoomType, int> _rooms(dynamic value) {
    if (value is! List) return const {};

    final counts = <GroupRoomType, int>{};
    for (final item in value) {
      if (item is! Map) continue;
      final type = GroupRoomType.fromApi(
        ApiParse.stringOf(item['room_type'] ?? item['type']),
      );
      final count = ApiParse.intOf(item['count'] ?? item['quantity']) ?? 0;
      if (count > 0) counts[type] = count;
    }
    return counts;
  }
}

const Color _pendingSurface = Color(0xFFEDE0FE);
const Color _pendingText = Color(0xFF6D28D9);
const Color _quotedSurface = Color(0xFFE7EAF0);
const Color _quotedText = Color(0xFF475569);
const Color _approvedSurface = Color(0xFFD8F0E3);
const Color _cancelledSurface = Color(0xFFFBD9D9);
