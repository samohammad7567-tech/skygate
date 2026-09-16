import 'package:flutter/material.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/models/journey_transport.dart';
import 'package:skygate/core/utils/api_parse.dart';

enum BookingStatus {
  active('trip_status_active'),
  awaitingPayment('trip_status_awaiting_payment'),
  completed('trip_status_completed');

  const BookingStatus(this.labelKey);

  final String labelKey;

  Color get foreground => switch (this) {
    BookingStatus.active => AppColors.primary,
    BookingStatus.awaitingPayment => AppColors.accent,
    BookingStatus.completed => AppColors.success,
  };

  Color get background => switch (this) {
    BookingStatus.active => AppColors.surfaceTint,
    BookingStatus.awaitingPayment => AppColors.accentSurface,
    BookingStatus.completed => AppColors.successSurface,
  };

  static BookingStatus fromApi(dynamic value) {
    final label = ApiParse.labelOf(value)?.toLowerCase().trim() ?? '';
    if (label.isEmpty) return awaitingPayment;

    bool has(List<String> words) => words.any(label.contains);

    if (has(['complet', 'finish', 'done', 'closed', 'منته', 'مكتمل'])) {
      return completed;
    }
    if (has(['confirm', 'active', 'paid', 'مؤكد', 'حالي', 'مدفوع'])) {
      return active;
    }
    return awaitingPayment;
  }
}

class BookingTripModel {
  int? id;
  int? tripId;

  String? tripTitle;
  String? tripNumber;
  String? image;

  DateTime? startDate;
  DateTime? endDate;

  num? total;
  num? paid;
  String? currency;

  BookingStatus status = BookingStatus.awaitingPayment;
  List<JourneyTransport> legs = const [];
  int? currentLeg;

  BookingTripModel.fromJson(Map<String, dynamic> json) {
    id = ApiParse.intOf(json['id']);
    status = BookingStatus.fromApi(json['status']);
    total = ApiParse.numOf(json['total_amount']);
    paid = ApiParse.numOf(json['paid_amount']);
    currency = ApiParse.stringOf(json['currency']);

    final trip = json['trip'];
    final tripJson = trip is Map<String, dynamic> ? trip : const {};
    tripId = ApiParse.intOf(tripJson['id'] ?? json['trip_id']);
    tripTitle = ApiParse.stringOf(
      tripJson['campaign_name'] ?? json['campaign_name'],
    );
    tripNumber = ApiParse.stringOf(
      tripJson['trip_number'] ?? json['trip_number'],
    );
    image = ApiParse.stringOf(tripJson['image'] ?? json['image']);
    startDate = ApiParse.dateOf(
      tripJson['start_date_g'] ?? json['start_date_g'],
    );
    endDate = ApiParse.dateOf(tripJson['end_date_g'] ?? json['end_date_g']);
    legs = [
      if (tripJson['itinerary'] is List)
        for (final leg in tripJson['itinerary'] as List)
          if (leg is Map<String, dynamic>)
            JourneyTransport.fromApi(ApiParse.stringOf(leg['segment_type'])),
    ];
    currentLeg = ApiParse.intOf(json['current_leg']);
  }
  String? get title => tripTitle ?? tripNumber;
  int? get durationDays => ApiParse.daysBetween(startDate, endDate);
  num get remaining {
    final outstanding = (total ?? 0) - (paid ?? 0);
    return outstanding < 0 ? 0 : outstanding;
  }

  String get formattedRemaining => '$remaining${currency ?? ''}';
}
