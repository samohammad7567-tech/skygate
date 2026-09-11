import 'package:skygate/core/constants/journey_assets.dart';

enum BookingCity {
  makkah('makkah', 'city_makkah', JourneyAssets.makkah, [
    'makk',
    'mecca',
    'مكة',
    'مكه',
  ]),
  madinah('madinah', 'city_madinah', JourneyAssets.madinah, [
    'madin',
    'medin',
    'المدينة',
    'المدينه',
  ]);

  const BookingCity(this.slug, this.labelKey, this.icon, this.aliases);

  final String slug;
  final String labelKey;
  final String icon;
  final List<String> aliases;
  bool matches(String? city) {
    final value = city?.toLowerCase().trim() ?? '';
    if (value.isEmpty) return false;
    return aliases.any(value.contains);
  }

  String get nightsLabelKey => switch (this) {
    BookingCity.makkah => 'makkah_nights',
    BookingCity.madinah => 'madinah_nights',
  };
  String get hotelLabelKey => switch (this) {
    BookingCity.makkah => 'makkah_hotel',
    BookingCity.madinah => 'madinah_hotel',
  };
  BookingCity? get next {
    final position = values.indexOf(this);
    return position < values.length - 1 ? values[position + 1] : null;
  }
}
