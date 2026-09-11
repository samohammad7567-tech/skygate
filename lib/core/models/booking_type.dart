enum BookingType {
  individual('individual', 'booking_individual'),
  group('group', 'booking_group');

  const BookingType(this.slug, this.labelKey);
  final String slug;
  final String labelKey;

  static BookingType fromSlug(String? slug) => values.firstWhere(
    (type) => type.slug == slug,
    orElse: () => BookingType.individual,
  );
}
