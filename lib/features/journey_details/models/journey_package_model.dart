import 'package:flutter/material.dart';
import 'package:skygate/core/constants/journey_assets.dart';
import 'package:skygate/core/constants/card_assets.dart';
import 'package:skygate/core/constants/payment_assets.dart';
import 'package:skygate/core/models/trip_model.dart';

class JourneyPackageModel {
  int? id;
  String? title;
  String? image;

  int? durationDays;
  List<JourneyStaffModel> supervisors = const [];
  List<JourneyStayModel> stays = const [];
  String? programPdfUrl;
  String? tripNumber;
  DateTime? startDate;
  DateTime? endDate;
  String? departureCity;
  String? returnCity;

  int? pilgrimsCount;

  JourneyPackageModel.fromTrip(TripModel trip) {
    id = trip.id;
    title = trip.title;
    durationDays = trip.durationDays;
    programPdfUrl = trip.programPdfUrl;
    tripNumber = trip.tripNumber;
    startDate = trip.startDate;
    endDate = trip.endDate;
    pilgrimsCount = trip.pilgrimsCount;
    departureCity = trip.itinerary.firstOrNull?.originCity;
    returnCity = trip.itinerary.lastOrNull?.originCity;
    supervisors = [
      for (final member in trip.staff)
        JourneyStaffModel(name: member.name, role: member.role),
    ];
    stays = JourneyStayModel.fromTrip(trip);
  }
  int? get daysRemaining {
    final end = endDate;
    if (end == null) return null;
    final left = end.difference(DateTime.now()).inDays;
    return left < 0 ? 0 : left;
  }
}

class JourneyStaffModel {
  JourneyStaffModel({this.name, this.role});

  final String? name;
  final String? role;
}

class JourneyStayModel {
  JourneyStayModel({
    required this.city,
    required this.days,
    this.hotels = const [],
  }) : icon = _iconOf(city);

  final String? city;
  final int? days;
  final List<String> hotels;
  final String icon;
  static List<JourneyStayModel> fromTrip(TripModel trip) {
    if (trip.citiesSummary.isNotEmpty) {
      return [
        for (final summary in trip.citiesSummary)
          JourneyStayModel(
            city: summary.city,
            days: summary.nights,
            hotels: summary.hotels,
          ),
      ];
    }
    return fromHotels(trip.hotels);
  }

  static List<JourneyStayModel> fromHotels(List<TripHotelModel> hotels) {
    final nights = <String, int>{};
    final names = <String, List<String>>{};

    for (final hotel in hotels) {
      final city = hotel.city;
      if (city == null) continue;
      nights[city] = (nights[city] ?? 0) + (hotel.nights ?? 0);
      if (hotel.name != null) {
        names.putIfAbsent(city, () => []).add(hotel.name!);
      }
    }

    return [
      for (final entry in nights.entries)
        JourneyStayModel(
          city: entry.key,
          days: entry.value,
          hotels: names[entry.key] ?? const [],
        ),
    ];
  }

  static String _iconOf(String? city) {
    final value = city?.toLowerCase() ?? '';
    return value.contains('madin') || value.contains('المدين')
        ? JourneyAssets.madinah
        : JourneyAssets.makkah;
  }
}

class JourneySectionModel {
  final JourneySection section;
  final String titleKey;
  final String descKey;
  final String? asset;
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
  static const List<JourneySectionModel> bookedCatalogue = [
    routes,
    hotels,
    activities,
  ];

  static const JourneySectionModel routes = JourneySectionModel(
    section: JourneySection.routes,
    titleKey: 'section_trip_routes',
    descKey: 'section_trip_routes_desc',
    asset: JourneyAssets.routes,
  );

  static const JourneySectionModel hotels = JourneySectionModel(
    section: JourneySection.hotels,
    titleKey: 'hotels',
    descKey: 'section_hotels_desc',
    asset: JourneyAssets.hotel,
  );

  static const JourneySectionModel activities = JourneySectionModel(
    section: JourneySection.activities,
    titleKey: 'section_activities',
    descKey: 'section_activities_desc',
    asset: JourneyAssets.activities,
  );
  static const List<JourneySectionModel> bookingCatalogue = [booking, cards];

  static const JourneySectionModel booking = JourneySectionModel(
    section: JourneySection.booking,
    titleKey: 'booking_details',
    descKey: 'section_booking_desc',
    asset: PaymentAssets.bookingTicket,
  );

  static const JourneySectionModel cards = JourneySectionModel(
    section: JourneySection.cards,
    titleKey: 'cards_details',
    descKey: 'section_cards_desc',
    asset: CardAssets.visas,
  );
}

enum JourneySection { routes, hotels, activities, offers, booking, cards }
