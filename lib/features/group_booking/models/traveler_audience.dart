/// Who a traveller is priced as — the "بالغ / طفل / رضيع" chip printed on every
/// group card.
///
/// The wizard never asks for it: it is read off the date of birth on the
/// passport, so a scanned and a typed traveller are classified the same way.
enum TravelerAudience {
  adult('adult', 'audience_adult', 'audience_adults'),
  child('child', 'audience_child', 'audience_children'),
  infant('infant', 'audience_infant', 'audience_infants');

  const TravelerAudience(this.slug, this.labelKey, this.countLabelKey);

  /// Value sent to the API.
  final String slug;

  /// Singular, as the chip on a traveller card prints it.
  final String labelKey;

  /// Plural, as the head-count tiles print it.
  final String countLabelKey;

  /// Age under which a traveller is an infant, in years.
  static const int infantMaxAge = 2;

  /// Age under which a traveller is a child.
  static const int childMaxAge = 12;

  /// Everyone but an adult travels under a guardian — the "ولي الأمر" row on
  /// the traveller cards.
  bool get needsGuardian => this != adult;

  /// Classifies a traveller from the birth date the passport carries. An
  /// unknown date is treated as an adult, which is the only class that can
  /// stand on its own.
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
