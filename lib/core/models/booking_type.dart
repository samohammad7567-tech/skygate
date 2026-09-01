/// "حجز فردي" / "حجز مجموعة" — how a trip offer is taken.
///
/// Shared by "عروض الرحلة", where it labels a chip on an offer card, and by the
/// booking wizard, whose first step is choosing between the two.
enum BookingType {
  individual('individual', 'booking_individual'),
  group('group', 'booking_group');

  const BookingType(this.slug, this.labelKey);

  /// Value the API sends and expects back.
  final String slug;
  final String labelKey;

  static BookingType fromSlug(String? slug) => values.firstWhere(
    (type) => type.slug == slug,
    orElse: () => BookingType.individual,
  );
}
