import 'package:skygate/core/models/group_room_type.dart';
import 'package:skygate/core/models/hotel_model.dart';

class HotelFilter {
  const HotelFilter({this.roomType, this.from, this.to, this.minRating = 0});

  final GroupRoomType? roomType;
  final DateTime? from;
  final DateTime? to;
  final double minRating;
  static const double maxRating = 5;

  HotelFilter copyWith({
    GroupRoomType? roomType,
    DateTime? from,
    DateTime? to,
    double? minRating,
  }) => HotelFilter(
    roomType: roomType ?? this.roomType,
    from: from ?? this.from,
    to: to ?? this.to,
    minRating: minRating ?? this.minRating,
  );

  bool matches(HotelModel hotel) {
    if (minRating > 0 && (hotel.rating ?? 0) < minRating) return false;

    // A hotel from the trip endpoint publishes no room sizes, so it is never
    // filtered out by one.
    if (roomType != null &&
        hotel.rooms.isNotEmpty &&
        !hotel.rooms.contains(roomType)) {
      return false;
    }

    final checkOut = hotel.checkOut;
    if (from != null && checkOut != null && checkOut.isBefore(from!)) {
      return false;
    }

    final checkIn = hotel.checkIn;
    if (to != null && checkIn != null && checkIn.isAfter(to!)) return false;

    return true;
  }
}
