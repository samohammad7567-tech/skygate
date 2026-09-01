/// Pagination block returned under `json['meta']['pagination']`.
class Meta {
  int? total;
  int? count;
  int? perPage;
  int? currentPage;
  int? totalPages;

  Meta.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    count = json['count'];
    perPage = json['per_page'];
    currentPage = json['current_page'];
    totalPages = json['total_pages'];
  }

  /// True when another page can still be requested.
  bool get hasMorePages {
    final current = currentPage ?? 1;
    final pages =
        totalPages ??
        (((total ?? 0) / ((perPage ?? 0) == 0 ? 1 : perPage!)).ceil());
    return current < pages;
  }
}
