import 'package:skygate/core/models/booking_type.dart';
import 'package:skygate/core/models/traveler_audience.dart';

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
  final Map<TravelerAudience, int> counts;

  final List<BookingRoomDetailsModel> rooms;
  final num? grandTotal;

  final String? currency;

  bool get isGroup => type == BookingType.group;
  BookingRoomDetailsModel? get singleRoom => rooms.isEmpty ? null : rooms.first;

  num get total =>
      grandTotal ?? rooms.fold<num>(0, (sum, r) => sum + (r.total ?? 0));
}

class BookingRoomDetailsModel {
  const BookingRoomDetailsModel({
    this.roomType,
    this.madinahHotel,
    this.makkahHotel,
    this.travelers = const [],
    this.total,
    this.currency,
  });
  final String? roomType;

  final String? madinahHotel;
  final String? makkahHotel;
  final List<BookingTravelerModel> travelers;

  final num? total;
  final String? currency;
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
