class Pagination<T> {
  final int page;
  final int total;
  final int pageSize;
  final int lastPage;
  final List<T> results;

  bool get isLastPage {
    return page == lastPage;
  }

  Pagination({
    required this.page,
    required this.total,
    required this.pageSize,
    required this.lastPage,
    required this.results,
  });

  Pagination.fromJson(Map json, T Function(Map) itemBuilder)
      : page = json['page'],
        total = json['total'],
        pageSize = json['page_size'],
        lastPage = json['last_page'],
        results = (json['results'] as List).map((e) => itemBuilder(e)).toList();

  Pagination.empty({this.pageSize = 20})
      : page = 1,
        total = 0,
        lastPage = 1,
        results = [];

  Pagination<T> next([int? value]) {
    int nextPage = value ?? page + 1;
    if (nextPage > lastPage || nextPage < 1) {
      nextPage = page;
    }

    return Pagination<T>(
      page: nextPage,
      total: total,
      pageSize: pageSize,
      lastPage: lastPage,
      results: [],
    );
  }

  Pagination<T> previous() {
    return Pagination<T>(
      page: page > 1 ? page - 1 : 1,
      total: total,
      pageSize: pageSize,
      lastPage: lastPage,
      results: [],
    );
  }
}
