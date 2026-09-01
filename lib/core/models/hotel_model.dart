import 'package:skygate/core/models/trip_model.dart';

/// A hotel card in "الفنادق", and the whole of "تفاصيل الحجز".
///
/// Built from the `hotels[]` block of `GET app/trips/{id}` — the API has no
/// hotel endpoint of its own, so the trip carries everything both screens
/// print.
class HotelModel {
  int? id;
  String? name;
  String? city;

  /// The API publishes no hotel photography yet; the cards fall back to the
  /// bundled cover while this stays null.
  String? image;

  num? rating;
  int? nights;
  String? address;
  String? phone;

  /// Room types offered, e.g. "غرف رباعية ، غرف خماسية". Not published by the
  /// trip endpoint yet.
  String? roomTypes;

  DateTime? checkIn;
  DateTime? checkOut;

  num? latitude;
  num? longitude;

  /// The hotel the trip books by default in its city.
  bool isDefault = false;

  /// Map artwork under "الموقع على الخريطة". Bundled until the API ships one.
  String? mapImage;

  HotelModel.fromTripHotel(TripHotelModel hotel) {
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

  /// "٢١.٤٢٢، ٣٩.٨٢٦" — the note printed under the map, which is the only
  /// location detail the trip endpoint carries beyond the address.
  String? get mapNote {
    final lat = latitude;
    final lng = longitude;
    if (lat == null || lng == null) return null;
    return '$lat, $lng';
  }

  /// `true` when the hotel matches a free-text search over its name, city and
  /// address — the list filters in memory because `GET app/trips/{id}` takes
  /// no query parameters.
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

/// Order applied by the sort button next to the hotel search field.
enum HotelSort {
  rating('rating', 'sort_by_rating'),
  nearest('nearest', 'sort_by_nearest'),
  name('name', 'sort_by_name');

  const HotelSort(this.slug, this.labelKey);

  final String slug;
  final String labelKey;

  /// Compares two hotels the way this order wants them.
  ///
  /// Sorting happens on the device for the same reason searching does: the
  /// trip endpoint hands back the whole list at once and takes no `sort`
  /// parameter. "الأقرب" falls back to the trip's own order, which is the one
  /// the itinerary visits the cities in.
  int compare(HotelModel a, HotelModel b) => switch (this) {
    HotelSort.rating => (b.rating ?? 0).compareTo(a.rating ?? 0),
    HotelSort.name => (a.name ?? '').compareTo(b.name ?? ''),
    HotelSort.nearest => 0,
  };
}
