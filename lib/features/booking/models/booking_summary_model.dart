import 'package:skygate/core/models/booking_type.dart';

/// "ملخص الحجز" — the priced review shown on the wizard's last step.
///
/// Nothing is fetched to build it: the OpenAPI document publishes no priced
/// summary for the `trip_id` + `rooms[]` contract, so every figure comes from
/// choices the wizard already holds — the trip, the route, the room type its
/// package prices, and the hotel picked in each city.
class BookingSummaryModel {
  BookingSummaryModel({
    this.tripTitle,
    this.routeName,
    this.bookingType = BookingType.individual,
    this.roomType,
    this.madinahHotel,
    this.makkahHotel,
    this.total,
    this.currency,
    this.paymentWindowHours = 24,
    this.expiresAt,
    this.installments = const [],
  });

  final String? tripTitle;
  final String? routeName;
  final BookingType bookingType;
  final String? roomType;
  final String? madinahHotel;
  final String? makkahHotel;
  final num? total;

  /// Currency as the API prints it, e.g. `SAR`.
  final String? currency;

  /// Hours the first instalment may be left unpaid before the booking is
  /// dropped; printed in the countdown header and its note.
  final int paymentWindowHours;

  /// When the hold expires. The countdown ticks down to this instant.
  final DateTime? expiresAt;

  /// Rows of "جدول دفعات الرحلة".
  ///
  /// The backend publishes no instalment plan — `BookingResource` carries only
  /// a status, a total and `draft_expires_at` — so the schedule card stays
  /// hidden rather than inventing a split the finance side never agreed to.
  final List<BookingInstallmentModel> installments;
}

/// One row of "جدول دفعات الرحلة".
class BookingInstallmentModel {
  BookingInstallmentModel({
    this.number,
    this.amount,
    this.percentage,
    this.currency,
    this.dueAt,
    this.dueWithinHours,
  });

  /// 1-based place in the schedule, printed as "دفعة #1".
  final int? number;

  final num? amount;

  /// Share of the total this instalment settles; fills the round badge.
  final int? percentage;

  final String? currency;

  /// Absolute due date, e.g. "30 أغسطس 2026".
  final DateTime? dueAt;

  /// Relative deadline in hours, e.g. "خلال 24 ساعة". When present the design
  /// prints it instead of [dueAt].
  final int? dueWithinHours;
}
