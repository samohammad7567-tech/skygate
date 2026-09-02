import 'package:skygate/core/models/booking_type.dart';
import 'package:skygate/core/models/traveler_audience.dart';

/// "تفاصيل الحجز" — the read-only review reached from "عرض تفاصيل الحجز".
///
/// It carries both shapes the design draws: an individual booking prints one
/// [rooms] entry and no head counts, a group booking prints the counts line
/// and one card per room with its travellers behind the "التفاصيل" chip.
///
/// Nothing is fetched to build it. `GET app/bookings/{id}` answers with
/// `BookingResource` — an id, a status, a total and an expiry — so the route,
/// the room types, the hotels and the travellers all have to be handed in by
/// whoever opens the screen. The booking wizards already hold every one of
/// them at the point they create the booking.
class BookingDetailsModel {
  const BookingDetailsModel({
    required this.bookingId,
    this.tripTitle,
    this.routeName,
    this.type = BookingType.individual,
    this.counts = const {},
    this.rooms = const [],
    this.grandTotal,
    this.currency,
  });

  final int bookingId;
  final String? tripTitle;
  final String? routeName;
  final BookingType type;

  /// Travellers per class across the whole booking, printed as
  /// "2 بالغ - 4 أطفال - 2 رضع". Empty on an individual booking.
  final Map<TravelerAudience, int> counts;

  final List<BookingRoomDetailsModel> rooms;

  /// "المجموع النهائي لكل أنواع الغرف". Falls back to adding the rooms up.
  final num? grandTotal;

  final String? currency;

  bool get isGroup => type == BookingType.group;

  /// The single room of an individual booking, whose fields are printed inline
  /// in the main table instead of in a card of their own.
  BookingRoomDetailsModel? get singleRoom => rooms.isEmpty ? null : rooms.first;

  num get total =>
      grandTotal ?? rooms.fold<num>(0, (sum, r) => sum + (r.total ?? 0));
}

/// One room of a booking: its size, the hotel it takes in either city, who
/// sleeps in it and what it costs.
class BookingRoomDetailsModel {
  const BookingRoomDetailsModel({
    this.roomType,
    this.madinahHotel,
    this.makkahHotel,
    this.travelers = const [],
    this.total,
    this.currency,
  });

  /// Already-translated label, e.g. "غرفة رباعية".
  final String? roomType;

  final String? madinahHotel;
  final String? makkahHotel;

  /// Filled only on a group booking, where the "التفاصيل" chip opens them.
  final List<BookingTravelerModel> travelers;

  final num? total;
  final String? currency;

  /// Travellers per class in this room, for the card's header line.
  Map<TravelerAudience, int> get counts {
    final counts = {
      for (final audience in TravelerAudience.values) audience: 0,
    };
    for (final traveler in travelers) {
      counts[traveler.audience] = (counts[traveler.audience] ?? 0) + 1;
    }
    return counts;
  }
}

/// One line of "تفاصيل المسافرين": who they are, how they are priced, and what
/// their seat in the room costs.
class BookingTravelerModel {
  const BookingTravelerModel({
    required this.name,
    this.audience = TravelerAudience.adult,
    this.price,
    this.currency,
  });

  final String name;
  final TravelerAudience audience;
  final num? price;
  final String? currency;

  String get formattedPrice => price == null ? '—' : '$price${currency ?? ''}';
}
