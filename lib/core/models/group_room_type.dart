enum GroupRoomType {
  single('single', 'room_type_single', 1),
  twin('twin', 'room_type_twin', 2),
  triple('triple', 'room_type_triple', 3),
  quad('quad', 'room_type_quad', 4),
  quint('quint', 'room_type_quint', 5),
  sextuple('sextuple', 'room_type_sextuple', 6);

  const GroupRoomType(this.slug, this.labelKey, this.capacity);
  final String slug;
  final String labelKey;
  final int capacity;

  static GroupRoomType fromSlug(String? slug) => values.firstWhere(
    (type) => type.slug == slug,
    orElse: () => GroupRoomType.single,
  );
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
