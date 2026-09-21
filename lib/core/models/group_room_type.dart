enum GroupRoomType {
  single('single', 'room_type_single', 1, id: 1),
  twin('twin', 'room_type_twin', 2, id: 2),
  triple('triple', 'room_type_triple', 3, id: 3),
  quad('quad', 'room_type_quad', 4, id: 4),
  quint('quint', 'room_type_quint', 5, id: 5),
  sextuple('sextuple', 'room_type_sextuple', 6, id: 6);

  const GroupRoomType(
    this.slug,
    this.labelKey,
    this.capacity, {
    required this.id,
  });
  final String slug;
  final String labelKey;

  /// Beds in the room — a UI/allocation concern, never sent to the server.
  final int capacity;

  /// Primary key of the row in the backend `room_types` table, sent as
  /// `room_type_ids` on `POST app/private-trip-requests`.
  ///
  /// These mirror the seed order and are assumed to line up with the server;
  /// the API exposes no route that lists room types, so they cannot be looked
  /// up at runtime. If the backend renumbers them, this is the only place to
  /// correct — `capacity` is deliberately kept separate so the two meanings
  /// never drift into each other.
  final int id;

  static GroupRoomType fromSlug(String? slug) => values.firstWhere(
    (type) => type.slug == slug,
    orElse: () => GroupRoomType.single,
  );

  /// Resolves an id coming back on `room_type_ids`. Returns null for an id the
  /// app does not know, so a renumbered server shows nothing rather than the
  /// wrong room type.
  static GroupRoomType? fromId(int? id) {
    if (id == null) return null;
    for (final type in values) {
      if (type.id == id) return type;
    }
    return null;
  }
  static GroupRoomType fromApi(String? roomType) {
    final value = roomType?.toLowerCase().trim() ?? '';
    if (value.isEmpty) return single;

    bool has(List<String> words) => words.any(value.contains);

    if (has(['sextuple', 'six', 'سداسي'])) return sextuple;
    if (has(['quint', 'five', 'خماسي'])) return quint;
    if (has(['quad', 'four', 'رباعي'])) return quad;
    if (has(['triple', 'three', 'ثلاثي'])) return triple;
    if (has(['twin', 'double', 'two', 'ثنائي', 'مزدوج'])) return twin;
    return single;
  }
}
