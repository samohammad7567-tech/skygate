import 'package:skygate/core/constants/journey_assets.dart';

/// The two cities the wizard asks for a hotel in, in the order step 5 walks
/// through them.
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

  /// How the trip's hotels may spell the city. `GET app/trips/{id}` prints a
  /// city name rather than a slug and takes no `city` filter, so the wizard
  /// sorts the hotels into the two steps itself.
  final List<String> aliases;

  /// `true` when a hotel's `city` names this city, in either language.
  bool matches(String? city) {
    final value = city?.toLowerCase().trim() ?? '';
    if (value.isEmpty) return false;
    return aliases.any(value.contains);
  }

  /// The city asked for after this one, or `null` when step 5 is finished.
  BookingCity? get next {
    final position = values.indexOf(this);
    return position < values.length - 1 ? values[position + 1] : null;
  }
}
