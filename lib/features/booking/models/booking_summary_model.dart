import 'package:skygate/core/models/booking_type.dart';
import 'package:skygate/core/models/trip_model.dart';

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
  final String? currency;
  final int paymentWindowHours;
  final DateTime? expiresAt;
  final List<BookingInstallmentModel> installments;
}

class BookingInstallmentModel {
  BookingInstallmentModel({
    this.number,
    this.name,
    this.amount,
    this.percentage,
    this.currency,
    this.dueAt,
    this.dueWithinHours,
  });
  final int? number;
  final String? name;

  final num? amount;
  final int? percentage;

  final String? currency;
  final DateTime? dueAt;
  final int? dueWithinHours;
  static List<BookingInstallmentModel> scheduleOf(
    List<TripPaymentScheduleModel> schedules, {
    num? total,
    String? currency,
  }) {
    var settled = 0;

    return [
      for (var i = 0; i < schedules.length; i++)
        () {
          final schedule = schedules[i];
          final reached = schedule.minAmountPercent ?? 100;
          final share = (reached - settled).clamp(0, 100);
          settled = reached;

          return BookingInstallmentModel(
            number: i + 1,
            name: schedule.installmentName,
            amount: total == null ? null : _round(total * share / 100),
            percentage: share,
            currency: currency,
            dueAt: schedule.dueDate,
            dueWithinHours: schedule.isDuration
                ? schedule.durationInHours
                : null,
          );
        }(),
    ];
  }

  static int? windowHoursOf(List<TripPaymentScheduleModel> schedules) {
    for (final schedule in schedules) {
      final hours = schedule.durationInHours;
      if (hours != null && hours > 0) return hours;
    }
    return null;
  }

  static num _round(num value) {
    final fixed = num.parse(value.toStringAsFixed(2));
    return fixed == fixed.roundToDouble() ? fixed.round() : fixed;
  }
}
