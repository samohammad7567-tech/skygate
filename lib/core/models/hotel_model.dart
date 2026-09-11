import 'package:easy_localization/easy_localization.dart';
import 'package:skygate/core/models/group_room_type.dart';
import 'package:skygate/core/models/trip_model.dart';

class HotelModel {
  int? id;
  String? name;
  String? city;
  String? image;

  num? rating;
  int? nights;
  String? address;
  String? phone;
  List<GroupRoomType> rooms;
  String? get roomTypes => rooms.isEmpty
      ? _roomTypes
      : rooms.map((room) => room.labelKey.tr()).join(' ، ');

  set roomTypes(String? value) => _roomTypes = value;

  String? _roomTypes;

  DateTime? checkIn;
  DateTime? checkOut;

  num? latitude;
  num? longitude;
  bool isDefault = false;
  String? mapImage;
  HotelModel.local({
    this.id,
    this.name,
    this.city,
    this.image,
    this.rating,
    this.nights,
    this.address,
    this.checkIn,
    this.checkOut,
    this.latitude,
    this.longitude,
    this.rooms = const [],
  });

  HotelModel.fromTripHotel(TripHotelModel hotel) : rooms = const [] {
    id = hotel.id;
    name = hotel.name;
    city = hotel.city;
    rating = hotel.rating;
    nights = hotel.nights;
    address = hotel.address;
    phone = hotel.contactPhone;
    checkIn = hotel.checkInDate;
    checkOut = hotel.checkOutDate;
    latitude = hotel.latitude;
    longitude = hotel.longitude;
    isDefault = hotel.isDefault;
  }
  String? get mapNote {
    final lat = latitude;
    final lng = longitude;
    if (lat == null || lng == null) return null;
    return '$lat, $lng';
  }

  bool matches(String query) {
    if (query.isEmpty) return true;
    final needle = query.toLowerCase();
    return [
      name,
      city,
      address,
    ].any((field) => field?.toLowerCase().contains(needle) ?? false);
  }
}

enum HotelSort {
  rating('rating', 'sort_by_rating'),
  nearest('nearest', 'sort_by_nearest'),
  name('name', 'sort_by_name');

  const HotelSort(this.slug, this.labelKey);

  final String slug;
  final String labelKey;
  int compare(HotelModel a, HotelModel b) => switch (this) {
    HotelSort.rating => (b.rating ?? 0).compareTo(a.rating ?? 0),
    HotelSort.name => (a.name ?? '').compareTo(b.name ?? ''),
    HotelSort.nearest => 0,
  };
}
