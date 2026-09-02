import 'package:flutter/material.dart';
import 'package:skygate/core/constants/journey_assets.dart';
import 'package:skygate/core/constants/payment_assets.dart';
import 'package:skygate/core/models/trip_model.dart';

/// "رحلة مكة" — the trip overview behind the hero photo.
///
/// Built from `GET app/trips/{id}`: the title is the campaign, the duration is
/// the span between the trip's two dates, the supervisors are its staff and
/// the stay chips are its hotels folded together per city.
class JourneyPackageModel {
  int? id;
  String? title;

  /// The trip endpoint publishes no cover photo, so the hero falls back to the
  /// bundled artwork while this stays null.
  String? image;

  int? durationDays;

  /// Names printed under "بإشراف", two per row in the design.
  List<String> supervisors = const [];

  /// City stays shown as the pair of chips under the supervisors card.
  List<JourneyStayModel> stays = const [];

  JourneyPackageModel.fromTrip(TripModel trip) {
    id = trip.id;
    title = trip.title;
    durationDays = trip.durationDays;
    supervisors = [for (final member in trip.staff) ?member.name];
    stays = JourneyStayModel.fromHotels(trip.hotels);
  }
}

/// One "مكة المكرمة · 4 أيام" chip.
class JourneyStayModel {
  JourneyStayModel({required this.city, required this.days})
    : icon = _iconOf(city);

  final String? city;

  /// Nights the trip sleeps in the city, added up over its hotels there.
  final int? days;

  /// Bundled glyph resolved from the city's name.
  final String icon;

  /// Folds the trip's hotels into one chip per city, in the order the trip
  /// lists them — which is the order the itinerary visits them in.
  static List<JourneyStayModel> fromHotels(List<TripHotelModel> hotels) {
    final nights = <String, int>{};

    for (final hotel in hotels) {
      final city = hotel.city;
      if (city == null) continue;
      nights[city] = (nights[city] ?? 0) + (hotel.nights ?? 0);
    }

    return [
      for (final entry in nights.entries)
        JourneyStayModel(city: entry.key, days: entry.value),
    ];
  }

  static String _iconOf(String? city) {
    final value = city?.toLowerCase() ?? '';
    return value.contains('madin') || value.contains('المدين')
        ? JourneyAssets.madinah
        : JourneyAssets.makkah;
  }
}

/// One row of the "تفاصيل الرحلة" list.
///
/// The four rows are fixed design content — label, description and glyph are
/// all known up front — so they ship as a local [catalogue] rather than coming
/// down from the API, the same way `TravelCategoryModel.catalogue` does.
class JourneySectionModel {
  final JourneySection section;
  final String titleKey;
  final String descKey;

  /// Bundled glyph. Null for the sections whose icon is a Material one.
  final String? asset;

  /// Used when [asset] is null.
  final IconData? icon;

  const JourneySectionModel({
    required this.section,
    required this.titleKey,
    required this.descKey,
    this.asset,
    this.icon,
  });

  static const List<JourneySectionModel> catalogue = [
    JourneySectionModel(
      section: JourneySection.routes,
      titleKey: 'section_trip_routes',
      descKey: 'section_trip_routes_desc',
      asset: JourneyAssets.routes,
    ),
    JourneySectionModel(
      section: JourneySection.hotels,
      titleKey: 'hotels',
      descKey: 'section_hotels_desc',
      asset: JourneyAssets.hotel,
    ),
    JourneySectionModel(
      section: JourneySection.activities,
      titleKey: 'section_activities',
      descKey: 'section_activities_desc',
      asset: JourneyAssets.activities,
    ),
    JourneySectionModel(
      section: JourneySection.offers,
      titleKey: 'trip_offers',
      descKey: 'section_offers_desc',
      asset: PaymentAssets.offers,
    ),
  ];

  /// The single row of "حجوزاتي و المدفوعات".
  ///
  /// Shown only on a trip the pilgrim has already booked — it opens that
  /// booking's payments — so it is kept out of [catalogue] rather than being
  /// filtered back out of it.
  static const JourneySectionModel booking = JourneySectionModel(
    section: JourneySection.booking,
    titleKey: 'booking_details',
    descKey: 'section_booking_desc',
    asset: PaymentAssets.bookingTicket,
  );
}

/// Destination a "تفاصيل الرحلة" row opens.
enum JourneySection { routes, hotels, activities, offers, booking }
