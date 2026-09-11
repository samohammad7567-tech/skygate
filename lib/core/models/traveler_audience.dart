enum TravelerAudience {
  adult('adult', 'audience_adult', 'audience_adults'),
  child('child', 'audience_child', 'audience_children'),
  infant('infant', 'audience_infant', 'audience_infants');

  const TravelerAudience(this.slug, this.labelKey, this.countLabelKey);
  final String slug;
  final String labelKey;
  final String countLabelKey;
  static const int infantMaxAge = 2;
  static const int childMaxAge = 12;
  bool get needsGuardian => this != adult;
  static TravelerAudience fromBirthDate(DateTime? birthDate) {
    if (birthDate == null) return adult;

    final now = DateTime.now();
    var age = now.year - birthDate.year;
    final hadBirthday =
        now.month > birthDate.month ||
        (now.month == birthDate.month && now.day >= birthDate.day);
    if (!hadBirthday) age--;

    if (age < infantMaxAge) return infant;
    if (age < childMaxAge) return child;
    return adult;
  }
}
