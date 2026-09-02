import 'package:flutter/material.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/constants/payment_assets.dart';
import 'package:skygate/core/models/journey_transport.dart';
import 'package:skygate/core/utils/api_parse.dart';

/// Where a booking stands, as the badge on its card names it.
enum BookingStatus {
  /// "حالية" — paid up and under way.
  active('trip_status_active'),

  /// "بانتظار الدفع" — an instalment is outstanding.
  awaitingPayment('trip_status_awaiting_payment'),

  /// "منتهية" — the trip is over.
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

/// The three tabs of "رحلاتي", in the order the bar prints them.
enum TripsTab {
  current('trips_tab_current', PaymentAssets.calendar),
  needsPayment('trips_tab_needs_payment', PaymentAssets.duePayment),
  completed('trips_tab_completed', PaymentAssets.done);

  const TripsTab(this.labelKey, this.icon);

  final String labelKey;
  final String icon;

  /// Whether a booking belongs under this tab.
  bool accepts(BookingTripModel booking) => switch (this) {
    TripsTab.current => booking.status == BookingStatus.active,
    TripsTab.needsPayment => booking.status == BookingStatus.awaitingPayment,
    TripsTab.completed => booking.status == BookingStatus.completed,
  };
}

/// One card of "رحلاتي" — a booking, and enough of its trip to print it.
///
/// `GET app/bookings` answers with `BookingResource`, which is an id, a status,
/// a total and `draft_expires_at` and nothing more: no trip, no dates, no
/// itinerary. Every field below past [status] and [total] is therefore read
/// opportunistically under the names the rest of the API uses, and the card is
/// written to degrade — a booking with no trip still prints its status, its
/// figures and its actions.
class BookingTripModel {
  int? id;

  /// The trip behind the booking, for the screens the card opens.
  int? tripId;

  String? tripTitle;
  String? tripNumber;

  /// Cover photo. The card falls back to the bundled Kaaba artwork.
  String? image;

  DateTime? startDate;
  DateTime? endDate;

  num? total;
  num? paid;
  String? currency;

  BookingStatus status = BookingStatus.awaitingPayment;

  /// The trip's legs, for the rail across a current booking's card.
  List<JourneyTransport> legs = const [];

  /// Which leg the group is on, 0-based. Null leaves the rail unlit.
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

  /// The name the card prints — the campaign, or the trip number.
  String? get title => tripTitle ?? tripNumber;

  /// Length of the trip in days, printed between the two date chips.
  int? get durationDays => ApiParse.daysBetween(startDate, endDate);

  /// "المبلغ المتبقي" on a booking still awaiting payment.
  num get remaining {
    final outstanding = (total ?? 0) - (paid ?? 0);
    return outstanding < 0 ? 0 : outstanding;
  }

  String get formattedRemaining => '$remaining${currency ?? ''}';
}
