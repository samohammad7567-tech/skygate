import 'package:skygate/core/utils/api_parse.dart';

class Meta {
  Meta.empty();

  Meta.fromJson(Map<String, dynamic> json) {
    total = ApiParse.intOf(json['total']);
    count = ApiParse.intOf(json['count']);
    perPage = ApiParse.intOf(json['per_page']);
    currentPage = ApiParse.intOf(json['current_page']);
    totalPages = ApiParse.intOf(json['total_pages'] ?? json['last_page']);
    nextCursor = ApiParse.stringOf(json['next_cursor']);
    prevCursor = ApiParse.stringOf(json['prev_cursor']);
    _hasMorePages = json['has_more_pages'] is bool
        ? json['has_more_pages'] as bool
        : null;
  }
  factory Meta.of(dynamic value) {
    if (value is! Map) return Meta.empty();
    final block = value['pagination'];
    final json = block is Map ? block : value;
    return Meta.fromJson(Map<String, dynamic>.from(json));
  }

  int? total;
  int? count;
  int? perPage;
  int? currentPage;
  int? totalPages;
  String? nextCursor;
  String? prevCursor;

  bool? _hasMorePages;
  bool get hasMorePages {
    final stated = _hasMorePages;
    if (stated != null) return stated;
    if (nextCursor != null) return true;

    final current = currentPage ?? 1;
    final pages =
        totalPages ??
        (((total ?? 0) / ((perPage ?? 0) == 0 ? 1 : perPage!)).ceil());
    return current < pages;
  }

  int? get nextPage => hasMorePages ? (currentPage ?? 1) + 1 : null;
}
